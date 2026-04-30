import 'package:flutter/widgets.dart';

/// 4-point spacing scale. Prefer these over ad-hoc `EdgeInsets.all(17)` values.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 48;

  // Common page padding
  static const EdgeInsets pagePadding = EdgeInsets.all(xl);
  static const EdgeInsets pagePaddingWide = EdgeInsets.symmetric(
    horizontal: xxxl,
    vertical: xl,
  );
}

/// Minimum accessible tap-target size (WCAG 2.1 AA = 44x44 dp).
class AppTouch {
  AppTouch._();
  static const double minTarget = 48; // 48 matches Material guideline & exceeds WCAG
  static const double keypadButton = 72;
}
