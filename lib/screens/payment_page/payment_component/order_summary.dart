import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';

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
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.amount,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
            Text(_durationText,
                style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.amountDue,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
            Text(
              '$total ${l10n.baht}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A90D9),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
