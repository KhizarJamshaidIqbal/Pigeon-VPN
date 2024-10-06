import 'package:flutter/material.dart';
import 'package:pigen_vpn/ads_helper.dart';
import 'package:pigen_vpn/splash_screen.dart';
import 'package:pigen_vpn/subscription_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ad Helper Class
  final adHelper = AdHelper();
  await adHelper.initialize();
  runApp(MyApp(adHelper: adHelper));
}

class MyApp extends StatelessWidget {
  final AdHelper adHelper;
  const MyApp({Key? key, required this.adHelper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => VpnProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
      ],
      child: MaterialApp(
        title: 'Pigeon VPN',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(
          adHelper: adHelper,
        ),
      ),
    );
  }
}
