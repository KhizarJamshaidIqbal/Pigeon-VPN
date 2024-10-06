// import 'dart:io';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AdHelper {
//   InterstitialAd? _interstitialAd;
//   int _numInterstitialLoadAttempts = 0;
//   static const int maxFailedLoadAttempts = 3;

//   Future<void> initialize() async {
//     await MobileAds.instance.initialize();
//   }

//   void createInterstitialAd() {
//     InterstitialAd.load(
//       adUnitId: _interstitialAdUnitId,
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (InterstitialAd ad) {
//           _interstitialAd = ad;
//           _numInterstitialLoadAttempts = 0;
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           _numInterstitialLoadAttempts += 1;
//           _interstitialAd = null;
//           if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
//             createInterstitialAd();
//           }
//         },
//       ),
//     );
//   }

//   void showInterstitialAd() {
//     if (_interstitialAd != null) {
//       _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//         onAdDismissedFullScreenContent: (InterstitialAd ad) {
//           ad.dispose();
//           createInterstitialAd();
//         },
//         onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//           ad.dispose();
//           createInterstitialAd();
//         },
//       );
//       _interstitialAd!.show();
//       _interstitialAd = null;
//     }
//   }

//   void disposeInterstitialAd() {
//     _interstitialAd?.dispose();
//   }

//   static String get _interstitialAdUnitId {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-3940256099942544/1033173712'; // Android test ad unit ID
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-3940256099942544/4411468910'; // iOS test ad unit ID
//     } else {
//       throw UnsupportedError('Unsupported platform');
//     }
//   }
// }
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  static const int maxFailedLoadAttempts = 3;

  BannerAd? topBannerAd;
  BannerAd? bottomBannerAd;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            createInterstitialAd();
          }
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  void disposeInterstitialAd() {
    _interstitialAd?.dispose();
  }

  void createBannerAds() {
    topBannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.mediumRectangle,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {},
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    topBannerAd!.load();

    bottomBannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {},
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    bottomBannerAd!.load();
  }

  void disposeBannerAds() {
    topBannerAd?.dispose();
    bottomBannerAd?.dispose();
  }

  static String get _interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Android test ad unit ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // iOS test ad unit ID
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get _bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Android test ad unit ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // iOS test ad unit ID
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
