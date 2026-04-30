import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

class OtpInputBox extends StatelessWidget {
  final List<String> otpDigits;
  const OtpInputBox({super.key, required this.otpDigits});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.height <= 800;
    final filledCount = otpDigits.where((d) => d.isNotEmpty).length;
    return Semantics(
      label: AppLocalizations.of(context)!.otpEntryStatus(filledCount),
      liveRegion: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (index) {
          final filled = otpDigits[index].isNotEmpty;
          return Container(
            width: compact ? 38.0 : 50.0,
            height: compact ? 46.0 : 60.0,
            margin: EdgeInsets.symmetric(horizontal: compact ? 3.0 : 5.0),
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
                style: TextStyle(
                  fontFamily: AppText.family,
                  fontSize: compact ? 22.0 : 28.0,
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
