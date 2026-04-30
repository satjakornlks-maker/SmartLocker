import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

class OvertimeLeftPanel extends StatelessWidget {
  final String hour;
  final String minute;
  final int fineAmount;

  const OvertimeLeftPanel({
    super.key,
    required this.hour,
    required this.minute,
    required this.fineAmount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Warning description
        Semantics(
          liveRegion: true,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: AppColors.error.withOpacity(0.12),
                  borderRadius: AppRadius.mdRadius,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.error,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  l10n.overtimeWarning,
                  style: AppText.headingMediumR(context).copyWith(
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Overtime duration card
        _InfoCard(
          icon: Icons.access_time_rounded,
          // ignore: deprecated_member_use
          iconBg: AppColors.info.withOpacity(0.12),
          iconColor: AppColors.info,
          label: l10n.overtimeExceeded,
          value: locale == 'th'
              ? '$hour ชั่วโมง $minute นาที'
              : '$hour hr $minute min',
          valueColor: AppColors.info,
        ),
        const SizedBox(height: AppSpacing.lg),

        // Fine amount card
        _InfoCard(
          icon: Icons.attach_money_rounded,
          // ignore: deprecated_member_use
          iconBg: AppColors.success.withOpacity(0.12),
          iconColor: AppColors.success,
          label: l10n.overtimeFine,
          value: '$fineAmount ${l10n.baht}',
          valueColor: AppColors.success,
          valueFontSize: 32,
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;
  final double valueFontSize;

  const _InfoCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
    this.valueFontSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: $value',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.lgRadius,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: AppColors.shadow.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: AppRadius.mdRadius,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppText.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: valueFontSize,
                      fontWeight: FontWeight.bold,
                      color: valueColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
