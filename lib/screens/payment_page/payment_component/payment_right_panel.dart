import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'alipay_logo.dart';
import 'branded_qr_illustration.dart';
import 'credit_card_illustration.dart';
import 'line_pay_logo.dart';
import 'order_summary.dart';
import 'qr_group_illustration.dart';

class PaymentRightPanel extends StatelessWidget {
  final String selectedMethod;
  final String bookingType;
  final int quantity;
  final int total;
  final VoidCallback onPay;

  const PaymentRightPanel({
    super.key,
    required this.selectedMethod,
    required this.bookingType,
    required this.quantity,
    required this.total,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIllustration(selectedMethod, l10n),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),
          OrderSummary(
            l10n: l10n,
            locale: locale,
            bookingType: bookingType,
            quantity: quantity,
            total: total,
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF4A90D9),
              side: const BorderSide(color: Color(0xFF4A90D9)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_offer_outlined, size: 16),
                const SizedBox(width: 6),
                Text(l10n.discountDetails,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPay,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90D9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 3,
              ),
              child: Text(
                l10n.payNow,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration(String method, AppLocalizations l10n) {
    return switch (method) {
      'qr_payment' => QrGroupIllustration(l10n: l10n),
      'credit_card' => CreditCardIllustration(l10n: l10n),
      'alipay' => BrandedQrIllustration(
          brandColor: const Color(0xFF00AAEF),
          bgColor: const Color(0xFFE0F5FD),
          logoWidget: const AlipayLogo(),
          scanLabel: l10n.aliPaySubtitle,
        ),
      'line_pay' => BrandedQrIllustration(
          brandColor: const Color(0xFF06C755),
          bgColor: const Color(0xFFE6F9ED),
          logoWidget: const LinePayLogo(),
          scanLabel: l10n.linePaySubtitle,
        ),
      _ => QrGroupIllustration(l10n: l10n),
    };
  }
}
