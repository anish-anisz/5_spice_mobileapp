import 'package:flutter/cupertino.dart';

class Responsiveness {
  final BuildContext context;

  Responsiveness(this.context);

  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;

  bool get isDesktop => screenWidth >= 1024;
  bool get isExtraLarge => screenWidth >= 1600;
  bool get  isLargeWidth => screenWidth >= 1200;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  static double sidebarWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1400) {
      return 180; // large desktop
    } else if (screenWidth >= 1100) {
      return 160; // tablet / small desktop
    } else if (screenWidth >= 800) {
      return 120; // tablet
    } else {
      return 100; // mobile
    }
  }



  static double menuBoxSize(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    if (w >= 1400) return 56; // large desktop
    if (w >= 1100) return 80; // desktop
    if (w >= 800) return 46;  // tablet
    return 40;                // mobile
  }

  static double menuIconSize(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
print(w);
    if (w >= 1400) return 60;
    if (w >= 1100) return 60;
    if (w >= 800) return 26;
    return 22;
  }

  static double menuTextSize(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    if (w >= 1400) return 15;
    if (w >= 1100) return 14;
    if (w >= 800) return 13;
    return 12;
  }

}
