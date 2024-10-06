// ignore_for_file: unused_field, library_private_types_in_public_api, unrelated_type_equality_checks

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:pigen_vpn/ads_helper.dart';
import 'package:pigen_vpn/colors.dart';
import 'package:pigen_vpn/customText.dart';
import 'package:pigen_vpn/size.dart';
import 'package:pigen_vpn/vpn_status_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'ip_info_model.dart';

class GloabScreen extends StatefulWidget {
  final AdHelper adHelper;
  const GloabScreen({Key? key, required this.adHelper}) : super(key: key);

  @override
  _GloabScreenState createState() => _GloabScreenState();
}

class _GloabScreenState extends State<GloabScreen> {
  IPInfo? _ipInfo;
  bool _isLoading = true;
  bool _isConnected = true;
  bool _isFetching = false; // For the shimmer effect
  VpnStatus? currentStatus;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    // Use widget.adHelper instead of adHelper
    widget.adHelper.createInterstitialAd();

    // Listen to VPN status changes
    VpnStatusManager().statusStream.listen((status) {
      setState(() {
        currentStatus = status;
      });
    });

    // Initialize with the latest status if available
    currentStatus = VpnStatusManager().currentStatus;
  }

  // Check for internet connectivity
  Future<void> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!mounted) return; // Ensure widget is still mounted
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isConnected = false;
        _isLoading = false;
      });
    } else {
      fetchIPInfo();
    }
  }

  // Fetches IP information from the API
  Future<void> fetchIPInfo() async {
    setState(() {
      _isFetching = true; // Start shimmer effect
    });

    try {
      final response = await http.get(Uri.parse('http://ip-api.com/json/'));
      await Future.delayed(
          const Duration(seconds: 2)); // Simulate slow connection

      if (!mounted) return; // Ensure widget is still mounted
      if (response.statusCode == 200) {
        setState(() {
          _ipInfo = IPInfo.fromJson(json.decode(response.body));
          _isFetching = false;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load IP Information');
      }
    } catch (e) {
      if (!mounted) return; // Ensure widget is still mounted
      setState(() {
        _isFetching = false;
        _isLoading = false;
      });
      showErrorDialog(e.toString());
    }
  }

  // Show an error dialog if there's an issue fetching data
  void showErrorDialog(String message) {
    if (!mounted) return; // Ensure widget is still mounted
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        backgroundColor: AppColors.warningColor,
        content: SizedBox(
          height: 200,
          width: 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning,
                  color: AppColors.errorColor,
                  size: 50,
                ),
                SizedBox(height: 30),
                SizedBox(height: 10),
                CustomText(
                  text: 'Please Check Your Internet Connection',
                  color: AppColors.whiteColor,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showInterstitialAd() {
    // Use widget.adHelper instead of adHelper
    widget.adHelper.showInterstitialAd();
  }

  @override
  void dispose() {
    // Use widget.adHelper instead of adHelper
    widget.adHelper.disposeInterstitialAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: AppColors.whiteColor,
        excludeHeaderSemantics: true,
        scrolledUnderElevation: 0,
        title: const CustomText(
          text: 'VP Status Information',
          fontSize: 22,
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);

              _showInterstitialAd();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.primaryColor,
            )),
      ),
      body: _isLoading
          ? _isConnected
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildShimmerEffect(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/animations/internet_off.json'),
                    20.h,
                    const CustomText(
                      text: 'No internet connection',
                      color: AppColors.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    )
                  ],
                )
          : _ipInfo != null
              ? ListView(
                  padding: const EdgeInsets.all(10),
                  children: [
                    buildInfoCard(
                      'IP Address',
                      _ipInfo!.query,
                      Icons.public,
                    ),
                    buildInfoCard(
                      'Connected On',
                      currentStatus?.connectedOn?.toString() ?? 'Not Connected',
                      Icons.wifi,
                      iconColor: Colors.green,
                    ),
                    buildInfoCard(
                      'Duration',
                      currentStatus?.duration?.toString() ?? '0:00:00',
                      Icons.timer,
                      iconColor: Colors.blue,
                    ),
                    buildInfoCard(
                      'Downloading Speed in Bytes',
                      currentStatus?.byteIn?.toString() ?? '0',
                      Icons.download,
                      iconColor: Colors.red,
                    ),
                    buildInfoCard(
                      'uploading Speed in Bytes',
                      currentStatus?.byteOut?.toString() ?? '0',
                      Icons.upload,
                      iconColor: Colors.orange,
                    ),
                    buildInfoCard(
                      'Packets In',
                      currentStatus?.packetsIn?.toString() ?? '0',
                      Icons.arrow_downward,
                      iconColor: Colors.purple,
                    ),
                    buildInfoCard(
                      'Packets Out',
                      currentStatus?.packetsOut?.toString() ?? '0',
                      Icons.arrow_upward,
                      iconColor: Colors.pink,
                    ),
                    buildInfoCard(
                      'Latitude',
                      _ipInfo!.lat.toString(),
                      Icons.gps_fixed,
                    ),
                    buildInfoCard(
                      'Longitude',
                      _ipInfo!.lon.toString(),
                      Icons.gps_not_fixed,
                    ),
                  ],
                )
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/animations/internet_off.json'),
                    20.h,
                    const CustomText(
                      text: 'Failed to load IP information',
                      color: AppColors.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isLoading = true; // Reset loading state
            checkInternetConnection(); // Check internet and fetch data
          });
        },
        backgroundColor: AppColors.whiteColor,
        shape: const CircleBorder(
          eccentricity: 0.5,
        ),
        tooltip: 'Refresh IP Information',
        splashColor: AppColors.primaryColor.withOpacity(0.5),
        hoverColor: AppColors.primaryColor.withOpacity(0.5),
        focusColor: AppColors.primaryColor.withOpacity(0.5),
        elevation: 0.7,
        child: const Icon(
          Icons.refresh,
          color: AppColors.primaryColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Shimmer effect for loading data
  Widget buildShimmerEffect() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          direction: ShimmerDirection.ltr,
          baseColor: Colors.white,
          highlightColor: Colors.grey.shade300,
          child: Card(
            shape: Border.all(
              color: AppColors.primaryColor,
            ),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: Container(width: 40, height: 40, color: Colors.white),
              title: Container(
                  width: double.infinity, height: 16, color: Colors.white),
              subtitle: Container(
                  width: double.infinity, height: 14, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // Reusable method to build a card widget for each IP information detail
  Widget buildInfoCard(String title, String value, IconData icon,
      {Color iconColor = Colors.blue}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shadowColor: AppColors.primaryColor.withOpacity(0.25),
      color: AppColors.whiteColor,
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
