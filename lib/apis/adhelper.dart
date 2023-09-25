import 'dart:io';

class AdHelper {
  static String nativeAdAndroid() {
    if (Platform.isAndroid) {
      return 'cca-app-pub-2219477966427754/2147035273';
    } else {
      return 'ca-app-pub-2219477966427754/4216749125';
    }
  }
}
