import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:t_hunt/apis/adhelper.dart';

class AdProvider extends ChangeNotifier {
  bool isNativeAdLoaded = false;
  late NativeAd nativeAd;

  void initalizeNativeAd() async {
    nativeAd = NativeAd(
        adUnitId: AdHelper.nativeAdAndroid(),
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            log('Native Ad Loaded');
            isNativeAdLoaded = true;
          },
          onAdFailedToLoad: (ad, error) {
            log(error.message);
            isNativeAdLoaded = false;

            ad.dispose();
          },
          onAdClosed: (ad) {
            log('Native Ad Closed');
            isNativeAdLoaded = false;

            ad.dispose();
          },
        ),
        request: AdRequest());

    await nativeAd.load();
    notifyListeners();
  }
}
