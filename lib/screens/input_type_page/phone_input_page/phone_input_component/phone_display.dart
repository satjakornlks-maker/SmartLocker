import 'package:flutter/material.dart';
import 'package:untitled/theme/theme.dart';

class PhoneDisplay extends StatelessWidget {
  final String phoneNumber;
  const PhoneDisplay({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.height <= 800;
    return Semantics(
      label: phoneNumber.isEmpty
          ? 'Phone number field, empty'
          : 'Phone number: ${phoneNumber.split('').join(' ')}',
      liveRegion: true,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 400, minHeight: compact ? 52 : 80),
        padding: EdgeInsets.symmetric(
          vertical: compact ? AppSpacing.sm : AppSpacing.xl,
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
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: compact ? 24.0 : 32.0,
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
