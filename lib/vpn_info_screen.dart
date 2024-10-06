// ignore_for_file: unused_element, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:pigen_vpn/ads_helper.dart';
import 'package:pigen_vpn/colors.dart';
import 'package:pigen_vpn/customText.dart';
import 'package:pigen_vpn/custom_appbar.dart';
import 'package:pigen_vpn/navigation_helper.dart';
import 'package:pigen_vpn/vpn_status_manager.dart';

class VpnInfoScreen extends StatefulWidget {
  final AdHelper adHelper;
  const VpnInfoScreen({Key? key, required this.adHelper}) : super(key: key);

  @override
  _VpnInfoScreenState createState() => _VpnInfoScreenState();
}

class _VpnInfoScreenState extends State<VpnInfoScreen> {
  VpnStatus? currentStatus;

  @override
  void initState() {
    super.initState();
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
      appBar: CustomAppBar(
        onPressed: () {
          NavigationHelper.pop(context);

          _showInterstitialAd();
        },
        leadingIcon: const Icon(
          Icons.arrow_back,
          color: AppColors.primaryColor,
          size: 36,
        ),
        actionIcon: const [],
        titleText: 'VPN Information',
      ),
      body: const Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 20,
            ),
            child: CustomText(
                color: AppColors.blackColor,
                fontSize: 18,
                textAlign: TextAlign.justify,
                fontWeight: FontWeight.w500,
                text:
                    'PIGEON VPN is specifically designed to provide you with seamless WhatsApp connectivity services. You can stay connected for audio/video calls and messages without any interruptions and geo restrictions. However, rest assured that all your other internet services will also continue to function smoothly, without any issues. We prioritize your WhatsApp connectivity while ensuring that your data remains protected with a multi-layer state of the art encryption alogrithm, and no part of your data is logged or compromised. Enjoy secure, safe and uninterrupted access across all services!'),
          )
        ],
      ),
    );
  }
}
