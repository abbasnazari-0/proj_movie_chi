import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum PltformSize {
  mobile,
  tablet,
  desktop,
}

class MobileDetector {
  static bool isMobile() {
    if (kIsWeb) return false;
    if (Platform.isAndroid) return true;
    if (Platform.isIOS) return true;
    return false;
  }

  static PltformSize getPlatformSize(Size size) {
    if (size.width < 600) return PltformSize.mobile;
    if (size.width < 900) return PltformSize.tablet;
    return PltformSize.desktop;
  }

  static sizeHelper(size,
      {double? mobileSize, double? tabletSize, double? desktopSize}) {
    if (getPlatformSize(size) == PltformSize.mobile) return mobileSize;
    if (getPlatformSize(size) == PltformSize.tablet) return tabletSize;
    return desktopSize;
  }

  static widgetHelper<T>(size,
      {T? mobileWidget, T? tabletWidget, T? desktopWidget}) {
    if (getPlatformSize(size) == PltformSize.mobile) return mobileWidget;
    if (getPlatformSize(size) == PltformSize.tablet) return tabletWidget;
    return desktopWidget;
  }
}
