import 'package:flutter/material.dart';

/// Centralized color palette for SmartLocker.
///
/// Every color used across the app should come from here. Do not hardcode
/// `Color(0xFF...)` or `Colors.*` values in screens/widgets.
class AppColors {
  AppColors._();

  // --- Brand ---
  /// Primary brand color. Accessible on white (contrast ~4.5:1 target).
  static const Color primary = Color(0xFF1E6BB8); // darker than old 0xFF4A90D9 for WCAG AA
  static const Color primaryLight = Color(0xFFEBF4FF);
  static const Color accent = Color(0xFFF9A825);

  // --- Surfaces ---
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xFFF2F3F5);
  static const Color divider = Color(0xFFE3E5E8);

  // --- Text ---
  static const Color textPrimary = Color(0xFF1A1F2B);   // near-black
  static const Color textSecondary = Color(0xFF5B6471);
  static const Color textDisabled = Color(0xFF9AA3B0);
  static const Color textOnPrimary = Colors.white;

  // --- Semantic ---
  /// Success (e.g. locker opened, OTP verified).
  static const Color success = Color(0xFF2E8B57); // darker green for AA on white
  /// Error (e.g. failed validation, locker busy).
  static const Color error = Color(0xFFC62828);
  /// Warning (e.g. session timeout, overtime).
  static const Color warning = Color(0xFFB26A00); // darker amber for AA on white
  /// Info (neutral status).
  static const Color info = Color(0xFF1E6BB8);

  // --- Locker states ---
  static const Color lockerEmpty = success;
  static const Color lockerOccupied = error;
  static const Color lockerChoosing = accent;
  static const Color lockerDisabled = textDisabled;

  // --- Borders / Focus ---
  static const Color border = Color(0xFFD0D5DD);
  static const Color borderFocus = primary;
  static const Color shadow = Color(0x1A000000); // 10% black
}
