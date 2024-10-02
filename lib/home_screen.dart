import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pigen_vpn/colors.dart';
import 'package:pigen_vpn/customText.dart';
import 'package:pigen_vpn/customTextButton.dart';
import 'package:pigen_vpn/ip_information_screen.dart';
import 'package:pigen_vpn/navigation_helper.dart';
import 'dart:async';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pigen_vpn/size.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late OpenVPN engine;

  VpnStatus? status;

  String buttonText = "Tap to Connect";

  Gradient buttonColor = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.topRight,
      colors: [
        const Color(0xff16BFFD),
        const Color(0xffCB3066).withOpacity(0.35),
      ]);

  // Variable to track the connection duration
  int connectionDuration = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    engine = OpenVPN(
      onVpnStatusChanged: (data) {
        setState(() {
          status = data;
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
            // Start the timer to count the connection duration
            startConnectionTimer();
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
            // Stop the timer and reset connection duration
            stopConnectionTimer();
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
            startConnectionTimer(); // Start the timer on connection
          } else if (stage == VPNStage.disconnected) {
            buttonText = "Tap to Connect";
            buttonColor = LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [
                  const Color(0xff16BFFD),
                  const Color(0xffCB3066).withOpacity(0.35),
                ]);
            stopConnectionTimer(); // Stop the timer if disconnected
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

  void startConnectionTimer() {
    connectionDuration = 0; // Reset duration when starting
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        connectionDuration++;
      });
    });
  }

  void stopConnectionTimer() {
    timer?.cancel(); // Stop the timer when disconnected
    connectionDuration = 0; // Reset duration
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

  Widget _buildVPNButton() {
    return Semantics(
      button: true,
      child: InkWell(
        splashColor: Colors.transparent,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        onTap: () {
          if (buttonText == "Connected") {
            engine.disconnect(); // Disconnect the VPN
            stopConnectionTimer(); // Stop the timer when disconnecting
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

  @override
  Widget build(BuildContext context) {
    // Calculate hours, minutes, and seconds for display
    int hours = connectionDuration ~/ 3600;
    int minutes = (connectionDuration % 3600) ~/ 60;
    int seconds = connectionDuration % 60;

    // Format the duration string
    String durationText =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        title: const CustomText(
          text: 'Pigeon VPN',
          color: AppColors.primaryColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    CupertinoIcons.globe,
                    color: AppColors.primaryColor,
                    size: 30,
                  ),
                  onPressed: () => NavigationHelper.push(
                      context, const IPInformationScreen()),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primaryColor,
                    size: 30,
                  ),
                  onPressed: () => NavigationHelper.push(
                      context, const IPInformationScreen()),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
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
                    stopConnectionTimer(); // Stop the timer when disconnecting
                  } else {
                    buttonText = "Connecting"; // Change text to "Connecting"
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
          10.h,
          CustomText(
            text: durationText,
            color: AppColors.blackColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )
        ],
      ),
    );
  }
}

const String defaultVpnUsername = "openvpn"; // Replace with your VPN username
const String defaultVpnPassword =
    "Pigeon_VPN1"; // Replace with your VPN password
