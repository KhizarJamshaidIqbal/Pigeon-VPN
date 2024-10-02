// ignore_for_file: library_private_types_in_public_api, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:pigen_vpn/colors.dart';
import 'package:pigen_vpn/customText.dart';
import 'package:pigen_vpn/customTextButton.dart';
import 'package:pigen_vpn/home_screen.dart';
import 'package:pigen_vpn/navigation_helper.dart';
import 'package:pigen_vpn/size.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  Future setSeenonboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seenOnboard = await prefs.setBool('seenOnboard', true);
  }

  @override
  void initState() {
    super.initState();
    setSeenonboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => isLastPage = index == 2);
                },
                children: [
                  buildPage(
                    title: "Welcome to Pigeon VPN",
                    description:
                        "Easily connect to secure VPN server to enjoy limitless HD audio/video calls on WhatsApp with your family and friends",
                    imagePath: "assets/animations/animation_1.json",
                  ),
                  buildPage(
                    title: "Safe & Secure",
                    description:
                        "Truely safe, secure and ultra-fast multi layered encrypted connections with no data log policy",
                    imagePath: "assets/animations/animation_2.json",
                  ),
                  buildPage(
                    title: "One-click Connect",
                    description:
                        "Simple and hassle free one-click start/stop interface",
                    imagePath: "assets/animations/animation_3.json",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: const WormEffect(
                  dotColor: AppColors.lightTextColor,
                  activeDotColor: AppColors.primaryColor),
              onDotClicked: (index) => _controller.animateToPage(index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn),
            ),
            const SizedBox(height: 20),
            isLastPage
                ? CustomTextButton(
                    text: "Get Started",
                    onPressed: () {
                      NavigationHelper.pushReplacement(
                          context,  HomeScreen());
                    },
                    width: AppSizes.screenHeight(context),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextButton(
                        text: "Skip",
                        onPressed: () {
                          NavigationHelper.pushReplacement(
                              context,  HomeScreen());
                        },
                        width: 65,
                      ),
                      CustomTextButton(
                        text: "Next",
                        onPressed: () => _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut),
                        width: 100,
                        fontSize: AppSizes.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  // Helper function to build each onboarding page
  Widget buildPage({
    required String title,
    required String description,
    required String imagePath,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(imagePath, height: 300),
        const SizedBox(height: 40),
        CustomText(
          text: title,
          color: AppColors.blackColor,
          fontSize: 28,
          fontWeight: FontWeight.normal,
        ).animate().fade().slideY(
            curve: Curves.bounceOut,
            duration: const Duration(milliseconds: 1000),
            delay: const Duration(milliseconds: 200)),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: CustomText(
            text: description,
            color: AppColors.blackColor.withOpacity(0.5),
            fontSize: 18,
            textAlign: TextAlign.center,
          ).animate().fade().slideY(
              curve: Curves.bounceOut,
              duration: const Duration(milliseconds: 1000),
              delay: const Duration(milliseconds: 200)),
        ),
      ],
    );
  }
}
