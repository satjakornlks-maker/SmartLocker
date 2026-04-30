import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

class Header extends StatelessWidget {
  final Locale currentLocale;
  final VoidCallback? onBackPressed;
  final VoidCallback onLanguageSwitch;

  const Header({
    super.key,
    required this.currentLocale,
    required this.onLanguageSwitch,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final displayText = l.currentLanguageName;
    final otherLanguageLabel =
        currentLocale.languageCode == 'th' ? l.switchToEnglish : l.switchToThai;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          Semantics(
            label: l.goBack,
            button: true,
            child: Material(
              color: AppColors.surface,
              borderRadius: AppRadius.mdRadius,
              child: InkWell(
                borderRadius: AppRadius.mdRadius,
                onTap: () {
                  HapticFeedback.lightImpact();
                  if (onBackPressed != null) {
                    onBackPressed!();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: AppTouch.minTarget,
                  height: AppTouch.minTarget,
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.mdRadius,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                ),
              ),
            ),
          ),
          Text(
            l.appTitle,
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: AppColors.textPrimary,
            ),
          ),

          // Language switch
          Semantics(
            label: otherLanguageLabel,
            button: true,
            child: Material(
              color: AppColors.surface,
              borderRadius: AppRadius.mdRadius,
              child: InkWell(
                borderRadius: AppRadius.mdRadius,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onLanguageSwitch();
                },
                child: Container(
                  constraints: const BoxConstraints(minHeight: AppTouch.minTarget),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.mdRadius,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.language, size: 20, color: AppColors.textPrimary),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        displayText,
                        style: const TextStyle(
                          fontFamily: AppText.family,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
