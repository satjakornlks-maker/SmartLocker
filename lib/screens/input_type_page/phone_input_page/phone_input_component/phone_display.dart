import 'package:flutter/material.dart';
import 'package:untitled/theme/theme.dart';

class PhoneDisplay extends StatelessWidget {
  final String phoneNumber;
  const PhoneDisplay({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: phoneNumber.isEmpty
          ? 'Phone number field, empty'
          : 'Phone number: ${phoneNumber.split('').join(' ')}',
      liveRegion: true,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 400, minHeight: 80),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xl,
          horizontal: AppSpacing.xxxl,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(color: AppColors.border),
        ),
        child: Center(
          child: Text(
            phoneNumber,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppText.family,
              fontSize: 32,
              fontWeight: FontWeight.w500,
              letterSpacing: 3,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
