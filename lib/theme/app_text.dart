import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Text style tokens. Sizes scale down 10% on narrow screens (<600px).
class AppText {
  AppText._();

  static const String family = 'Prompt';

  static TextStyle _scaled(BuildContext? ctx, double base, FontWeight w,
      {Color? color, double? height, double? letterSpacing}) {
    double size = base;
    if (ctx != null) {
      final width = MediaQuery.of(ctx).size.width;
      if (width < 600) size = base * 0.85;
      else if (width > 1400) size = base * 1.05;
    }
    return TextStyle(
      fontFamily: family,
      fontSize: size,
      fontWeight: w,
      color: color ?? AppColors.textPrimary,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // --- Static (non-responsive) variants for simple cases ---
  static const TextStyle displayLarge = TextStyle(
    fontFamily: family, fontSize: 40, fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const TextStyle displayMedium = TextStyle(
    fontFamily: family, fontSize: 32, fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const TextStyle headingLarge = TextStyle(
    fontFamily: family, fontSize: 28, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle headingMedium = TextStyle(
    fontFamily: family, fontSize: 22, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle titleLarge = TextStyle(
    fontFamily: family, fontSize: 20, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: family, fontSize: 18, fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: family, fontSize: 16, fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: family, fontSize: 14, fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  static const TextStyle button = TextStyle(
    fontFamily: family, fontSize: 18, fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary, letterSpacing: 0.3,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: family, fontSize: 12, fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // --- Responsive variants (use with BuildContext where available) ---
  static TextStyle displayLargeR(BuildContext c) =>
      _scaled(c, 40, FontWeight.bold);
  static TextStyle displayMediumR(BuildContext c) =>
      _scaled(c, 32, FontWeight.bold);
  static TextStyle headingLargeR(BuildContext c) =>
      _scaled(c, 24, FontWeight.w600);
  static TextStyle headingMediumR(BuildContext c) =>
      _scaled(c, 22, FontWeight.w600);
  static TextStyle titleLargeR(BuildContext c) =>
      _scaled(c, 20, FontWeight.w600);
  static TextStyle bodyLargeR(BuildContext c) =>
      _scaled(c, 18, FontWeight.normal);
  static TextStyle bodyMediumR(BuildContext c) =>
      _scaled(c, 16, FontWeight.normal);
}
