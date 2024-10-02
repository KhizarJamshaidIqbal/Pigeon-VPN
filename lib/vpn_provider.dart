// import 'package:flutter/material.dart';

// class VpnProvider extends ChangeNotifier {
//   bool _isConnected = false;

//   bool get isConnected => _isConnected;

//   Future<void> connectToVpn() async {
//     try {
//       await FlutterOpenvpn.connect(
//         serverAddress: 'assets/files/vpnconfig.ovpn',
//         username: 'vpn',
//         password: 'vpn',
//       );
//       _isConnected = true;
//       notifyListeners();
//     } catch (e) {
//       _isConnected = false;
//       notifyListeners();
//       // Handle VPN connection error
//     }
//   }

//   Future<void> disconnectFromVpn() async {
//     try {
//       await FlutterOpenvpn.disconnect();
//       _isConnected = false;
//       notifyListeners();
//     } catch (e) {
//       // Handle VPN disconnection error
//     }
//   }
// }
