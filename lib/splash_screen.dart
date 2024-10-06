// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pigen_vpn/ads_helper.dart';
import 'package:pigen_vpn/home_screen.dart';
import 'package:pigen_vpn/navigation_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  final AdHelper adHelper;
  const SplashScreen({Key? key, required this.adHelper}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  // Function to check if the onboarding has been seen
  Future<void> _checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seenOnboard = prefs.getBool('seenOnboard') ?? false;

    // Navigate to the appropriate screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      NavigationHelper.pushReplacement(
          context,
          seenOnboard
              ? HomeScreen(adHelper: widget.adHelper)
              : OnboardingScreen(
                  adHelper: widget.adHelper,
                ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 250,
            ).animate().fade().slideY(
                curve: Curves.bounceOut,
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 200)),
            Text(
              "Pigeon VPN".toUpperCase(),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xff1A3661),
              ),
            ).animate().fade().slideY(
                curve: Curves.fastEaseInToSlowEaseOut,
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 200)),
          ],
        ),
      ),
    );
  }
}
