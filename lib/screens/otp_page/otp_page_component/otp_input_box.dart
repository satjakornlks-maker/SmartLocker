import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

class OtpInputBox extends StatelessWidget {
  final List<String> otpDigits;
  const OtpInputBox({super.key, required this.otpDigits});

  @override
  Widget build(BuildContext context) {
    final filledCount = otpDigits.where((d) => d.isNotEmpty).length;
    return Semantics(
      label: AppLocalizations.of(context)!.otpEntryStatus(filledCount),
      liveRegion: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (index) {
          final filled = otpDigits[index].isNotEmpty;
          return Container(
            width: 50,
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.mdRadius,
              border: Border.all(
                color: filled ? AppColors.primary : AppColors.border,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                filled ? '*' : '',
                style: const TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
