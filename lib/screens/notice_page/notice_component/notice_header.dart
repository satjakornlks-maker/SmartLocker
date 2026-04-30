import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

class NoticeHeader extends StatelessWidget {
  final BuildContext mainContext;
  const NoticeHeader({super.key, required this.mainContext});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxxl,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: [
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
                  Navigator.of(mainContext).popUntil((route) => route.isFirst);
                },
                child: Container(
                  width: AppTouch.minTarget,
                  height: AppTouch.minTarget,
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.mdRadius,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Text(
            l.appTitle,
            style: const TextStyle(
              fontFamily: AppText.family,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
