import 'dart:ui';

import 'package:flutter/foundation.dart';

/// Web-safe platform utilities. Replaces `dart:io` Platform which crashes on web.
class PlatformHelper {
  static String getPlatformName() {
    if (kIsWeb) return "Web";
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return "Android";
      case TargetPlatform.iOS:
        return "iOS";
      case TargetPlatform.macOS:
        return "macOS";
      case TargetPlatform.linux:
        return "Linux";
      case TargetPlatform.windows:
        return "Windows";
      case TargetPlatform.fuchsia:
        return "Fuchsia";
    }
  }

  static String getLocaleName() {
    try {
      final locale = PlatformDispatcher.instance.locale;
      return locale.toLanguageTag().replaceAll('-', '_');
    } catch (_) {
      return "en";
    }
  }
}
