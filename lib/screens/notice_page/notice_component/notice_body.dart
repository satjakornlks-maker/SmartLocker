import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';
import 'notice_confirm_button.dart';

class NoticeBody extends StatelessWidget {
  final BuildContext mainContext;
  const NoticeBody({super.key, required this.mainContext});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final title = l.registrationComplete;
    final subtitle = l.awaitingApproval;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Semantics(
              liveRegion: true,
              label: '$title. $subtitle',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.xxxl),
                  // Success Icon
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Color(0xFFE6F4EA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        size: 80,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  // Success Title
                  Center(
                    child: Text(
                      title,
                      style: AppText.displayMediumR(context).copyWith(
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: Text(
                      subtitle,
                      style: AppText.bodyLargeR(context).copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.huge),
                  NoticeConfirmButton(mainContext: mainContext),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
