// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';

// class ThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
//   ThemeMode _themeMode = ThemeMode.system;

//   ThemeProvider() {
//     WidgetsBinding.instance.addObserver(this);
//   }

//   ThemeMode get themeMode => _themeMode;

//   bool get isDarkMode {
//     if (_themeMode == ThemeMode.system) {
//       return WidgetsBinding.instance.window.platformBrightness ==
//           Brightness.dark;
//     }
//     return _themeMode == ThemeMode.dark;
//   }

//   void setThemeMode(ThemeMode mode) {
//     _themeMode = mode;
//     notifyListeners();
//   }

//   @override
//   void didChangePlatformBrightness() {
//     if (_themeMode == ThemeMode.system) {
//       notifyListeners();
//     }
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
// }
