// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebViewBlocker extends StatelessWidget {
//   final Set<String> blockedUrls = {
//     'youtube.com',
//     'adultwebsite.com',
//     // Add more URLs to block
//   };

//   WebViewBlocker({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return WebView(
//       initialUrl: 'https://www.example.com',
//       javascriptMode: JavascriptMode.unrestricted,
//       navigationDelegate: (NavigationRequest request) {
//         if (blockedUrls.any((url) => request.url.contains(url))) {
//           return NavigationDecision.prevent;
//         }
//         return NavigationDecision.navigate;
//       },
//     );
//   }
// }
