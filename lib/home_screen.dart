// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pigen_vpn/ads_helper.dart';
import 'package:pigen_vpn/colors.dart';
import 'package:pigen_vpn/customText.dart';
import 'package:pigen_vpn/customTextButton.dart';
import 'package:pigen_vpn/custom_appbar.dart';
import 'package:pigen_vpn/notification_services.dart';
import 'package:pigen_vpn/vpn_status_screen.dart';
import 'package:pigen_vpn/navigation_helper.dart';
import 'dart:async';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pigen_vpn/size.dart';
import 'package:pigen_vpn/vpn_info_screen.dart';
import 'package:pigen_vpn/vpn_status_manager.dart';

class HomeScreen extends StatefulWidget {
  final AdHelper adHelper;
  const HomeScreen({Key? key, required this.adHelper}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late OpenVPN engine;
  VpnStatus? status;

  String buttonText = "Tap to Connect";
// Notification
  final NotificationService _notificationService = NotificationService();

  Gradient buttonColor = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.topRight,
      colors: [
        const Color(0xff16BFFD),
        const Color(0xffCB3066).withOpacity(0.35),
      ]);

  @override
  void initState() {
    super.initState();
    // Use widget.adHelper instead of adHelper
    widget.adHelper.createInterstitialAd();
    widget.adHelper.createBannerAds();
    // for Notification
    _notificationService.initialize();
    // For VPN
    engine = OpenVPN(
      onVpnStatusChanged: (data) {
        setState(() {
          status = data;
          // Update VPN status in VpnStatusManager
          VpnStatusManager().updateStatus(data);
        });
      },
      onVpnStageChanged: (data, raw) {
        setState(() {
          if (data == VPNStage.connected) {
            buttonText = "Connected";
            buttonColor = LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [
                  const Color(0xff16BFFD),
                  const Color(0xff33CB30).withOpacity(0.35),
                ]);
            _showInterstitialAd(); // Show ad when connected
            // showConnectedNotification
            _notificationService.showConnectedNotification();
            // Start the timer to count the connection duration
            // startConnectionTimer();
          } else if (data == VPNStage.connecting) {
            buttonText = "Connecting";
            buttonColor = LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [
                  const Color(0xff16BFFD),
                  const Color.fromARGB(255, 46, 84, 189).withOpacity(0.35),
                ]);
          } else if (data == VPNStage.disconnected) {
            buttonText = "Disconnected";
            buttonColor = LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [
                  const Color(0xff16BFFD),
                  const Color(0xffDF1A1A).withOpacity(0.35),
                ]);
            _showInterstitialAd(); // Show ad when disconnected
            //showDisconnectedNotification
            _notificationService.showDisconnectedNotification();
            // Stop the timer and reset connection duration
            // stopConnectionTimer();

            // Reset button text after a delay
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                buttonText = "Tap to Connect";
                buttonColor = LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [
                      const Color(0xff16BFFD),
                      const Color(0xffCB3066).withOpacity(0.35),
                    ]);
              });
            });
          }
        });
      },
    );

    engine.initialize(
      groupIdentifier: "group.com.laskarmedia.vpn",
      providerBundleIdentifier:
          "id.laskarmedia.openvpnFlutterExample.VPNExtension",
      localizedDescription: "VPN by Nizwar",
      lastStage: (stage) {
        setState(() {
          // Request Permission
          engine.requestPermissionAndroid().then((value) {
            setState(() {});
          });
          if (stage == VPNStage.connected) {
            buttonText = "Connected";
            buttonColor = LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [
                  const Color(0xff16BFFD),
                  const Color(0xff33CB30).withOpacity(0.35),
                ]);

            // startConnectionTimer();
          } else if (stage == VPNStage.disconnected) {
            buttonText = "Tap to Connect";
            buttonColor = LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [
                  const Color(0xff16BFFD),
                  const Color(0xffCB3066).withOpacity(0.35),
                ]);
            // stopConnectionTimer();
          }
        });
      },
      lastStatus: (status) {
        setState(() {
          this.status = status;
        });
      },
    );
  }

  // Method to load the VPN configuration file from assets
  Future<String> loadVPNConfig() async {
    return await rootBundle.loadString('assets/files/Mumbai.ovpn');
  }

  Future<void> initPlatformState() async {
    // Load the VPN configuration from assets
    String config = await loadVPNConfig();

    engine.connect(
      config, // Use the loaded OVPN config
      "Mumbai", // Name for the connection
      username: defaultVpnUsername,
      password: defaultVpnPassword,
      certIsRequired: true,
    );

    if (!mounted) return;
  }

  void _showInterstitialAd() {
    // Use widget.adHelper instead of adHelper
    widget.adHelper.showInterstitialAd();
  }

  @override
  void dispose() {
    // Use widget.adHelper instead of adHelper
    widget.adHelper.disposeInterstitialAd();
    widget.adHelper.disposeBannerAds();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        titleText: 'Pigeon VPN',
        onPressed: () {
          if (buttonText == 'Connected') {
            NavigationHelper.push(
                context,
                GloabScreen(
                  adHelper: widget.adHelper,
                ));
          } else {
            setState(() {
              Fluttertoast.showToast(
                msg: 'VPN is Not Connnected',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: AppColors.primaryColor,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            });
          }
        },
        actionIcon: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(
                Icons.info_outlined,
                color: AppColors.primaryColor,
                size: 30,
              ),
              onPressed: () => NavigationHelper.push(
                  context,
                  VpnInfoScreen(
                    adHelper: widget.adHelper,
                  )),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          if (widget.adHelper.topBannerAd != null)
            Container(
              alignment: Alignment.center,
              width: widget.adHelper.topBannerAd!.size.width.toDouble(),
              height: widget.adHelper.topBannerAd!.size.height.toDouble(),
              child: AdWidget(ad: widget.adHelper.topBannerAd!),
            ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: _buildVPNButton()),
                35.h,
                SizedBox(
                  width: 160,
                  child: CustomTextButton(
                      text: buttonText,
                      onPressed: () {
                        if (buttonText == "Connected") {
                          engine.disconnect(); // Disconnect the VPN
                          // stopConnectionTimer();
                        } else {
                          buttonText =
                              "Connecting"; // Change text to "Connecting"
                          buttonColor = LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.topRight,
                              colors: [
                                const Color(0xff16BFFD),
                                const Color.fromARGB(255, 46, 84, 189)
                                    .withOpacity(0.35),
                              ]); // Change button color
                          setState(() {}); // Trigger a rebuild
                          initPlatformState(); // Start connecting to VPN
                        }
                      }),
                ),
              ],
            ),
          ),
          if (widget.adHelper.bottomBannerAd != null)
            Container(
              alignment: Alignment.center,
              width: widget.adHelper.bottomBannerAd!.size.width.toDouble(),
              height: widget.adHelper.bottomBannerAd!.size.height.toDouble(),
              child: AdWidget(ad: widget.adHelper.bottomBannerAd!),
            ),
        ],
      ),
    );
  }

  // VPN Button
  Widget _buildVPNButton() {
    return Semantics(
      button: true,
      child: InkWell(
        splashColor: Colors.transparent,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        onTap: () {
          if (buttonText == "Connected") {
            engine.disconnect(); // Disconnect the VPN
            setState(() {
              // Show Toast message
              Fluttertoast.showToast(
                msg: 'VPN is DisConnnected',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: AppColors.primaryColor,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              //
            });
            // stopConnectionTimer();
          } else {
            buttonText = "Connecting"; // Change text to "Connecting"
            buttonColor = LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [
                  const Color(0xff16BFFD),
                  const Color.fromARGB(255, 46, 84, 189).withOpacity(0.35),
                ]); // Change button color

            setState(() {}); // Trigger a rebuild
            initPlatformState(); // Start connecting to VPN
          }
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Container(
            height: 170,
            width: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              gradient: buttonColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.power_settings_new,
                          size: 40, color: Color(0xff7676EE)),
                      10.h,
                      CustomText(
                        text: buttonText,
                        fontSize: 16,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const String defaultVpnUsername = "openvpn"; // Replace with your VPN username
const String defaultVpnPassword =
    "Pigeon_VPN1"; // Replace with your VPN password
