import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

class OrderSummary extends StatelessWidget {
  final AppLocalizations l10n;
  final String locale;
  final String bookingType;
  final int quantity;
  final int total;

  const OrderSummary({
    super.key,
    required this.l10n,
    required this.locale,
    required this.bookingType,
    required this.quantity,
    required this.total,
  });

  String get _durationText {
    if (bookingType == 'day') {
      final hours = quantity * 24;
      return locale == 'th'
          ? '$quantity วัน ($hours ชั่วโมง)'
          : '$quantity day(s) ($hours hours)';
    }
    return locale == 'th' ? '$quantity ชั่วโมง' : '$quantity hour(s)';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.totalDuration,
          style: const TextStyle(
            fontFamily: AppText.family,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.amount,
              style: AppText.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              _durationText,
              style: AppText.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.amountDue,
              style: AppText.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '$total ${l10n.baht}',
              style: const TextStyle(
                fontFamily: AppText.family,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
