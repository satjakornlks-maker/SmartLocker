import 'package:flutter/widgets.dart';
import 'package:untitled/l10n/app_localizations.dart';

/// Context-aware validators. Prefer this over the static [Validators] class.
///
/// Usage:
///   final v = LocalizedValidators.of(context);
///   validator: v.emailOrPhone,
class LocalizedValidators {
  final AppLocalizations l;

  const LocalizedValidators._(this.l);

  factory LocalizedValidators.of(BuildContext context) =>
      LocalizedValidators._(AppLocalizations.of(context)!);

  String? emailOrPhone(String? value) {
    if (value == null || value.isEmpty) return l.errorEnterEmailOrPhone;
    final cleanValue = value.trim().replaceAll(' ', '').replaceAll('-', '');
    if (cleanValue.contains('@')) {
      final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(cleanValue)) return l.errorInvalidEmailFormat;
    } else if (cleanValue.startsWith('0')) {
      final phoneRegex = RegExp(r'^0[0-9]{9}$');
      if (!phoneRegex.hasMatch(cleanValue)) return l.errorPhoneMustBe10Digits;
    } else {
      return l.errorEnterValidEmailOrPhone;
    }
    return null;
  }

  String? otp(String? value) {
    if (value == null || value.isEmpty) return l.errorEnterOtp;
    if (value.length != 6) return l.errorOtpInvalid;
    return null;
  }

  String? tel(String? value) {
    if (value == null || value.isEmpty) return l.errorEnterPhone;
    final cleanValue = value.trim().replaceAll(' ', '');
    final phoneRegex = RegExp(r'^0[0-9]{9}$');
    if (!phoneRegex.hasMatch(cleanValue)) return l.errorPhoneMustBe10Digits;
    return null;
  }

  String? email(String? value) {
    if (value == null || value.isEmpty) return l.errorEnterEmail;
    final cleanValue = value.trim().replaceAll(' ', '');
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(cleanValue)) return l.errorInvalidEmail;
    return null;
  }
}

/// Legacy validators. Kept so existing screens keep compiling, but the
/// returned strings are now neutral English fallbacks. New code should use
/// [LocalizedValidators.of(context)] instead.
class Validators {
  static String? validateEmailOrPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number or email.';
    }
    final cleanValue = value.trim().replaceAll(' ', '').replaceAll('-', '');
    if (cleanValue.contains('@')) {
      final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(cleanValue)) {
        return "That email format isn't valid.";
      }
    } else if (cleanValue.startsWith('0')) {
      final phoneRegex = RegExp(r'^0[0-9]{9}$');
      if (!phoneRegex.hasMatch(cleanValue)) {
        return 'Phone number must be 10 digits.';
      }
    } else {
      return 'Please enter a valid email or phone number.';
    }
    return null;
  }

  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) return 'Please enter the OTP.';
    if (value.length != 6) return 'Please enter a valid 6-digit OTP.';
    return null;
  }

  static String? validateTel(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your phone number.';
    final cleanValue = value.trim().replaceAll(' ', '');
    final phoneRegex = RegExp(r'^0[0-9]{9}$');
    if (!phoneRegex.hasMatch(cleanValue)) {
      return 'Phone number must be 10 digits.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email.';
    final cleanValue = value.trim().replaceAll(' ', '');
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(cleanValue)) return "That email isn't valid.";
    return null;
  }
}
