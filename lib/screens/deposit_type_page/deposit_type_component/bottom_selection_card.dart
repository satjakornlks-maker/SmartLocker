import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

import '../../register_page/register_page.dart';

class BottomSelectionCard extends StatelessWidget {
  final String systemMode;
  const BottomSelectionCard({super.key, required this.systemMode});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Semantics(
      label: '${l.register}. ${l.tapToRegisterNow}',
      button: true,
      child: Material(
        color: AppColors.primary,
        borderRadius: AppRadius.xlRadius,
        child: InkWell(
          borderRadius: AppRadius.xlRadius,
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterPage(),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: AppTouch.minTarget),
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.xxl,
              horizontal: AppSpacing.xxxl,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: AppColors.textOnPrimary.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_add_rounded,
                    color: AppColors.textOnPrimary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Text(
                  l.register,
                  style: const TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
