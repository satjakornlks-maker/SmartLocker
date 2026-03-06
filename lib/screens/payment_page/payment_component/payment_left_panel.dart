import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'payment_app_dots.dart';
import 'payment_card_leading.dart';
import 'payment_icon_badge.dart';
import 'payment_method_card.dart';

class PaymentLeftPanel extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodChanged;

  const PaymentLeftPanel({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.paymentChannels,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            locale == 'th'
                ? 'เลือกช่องทางที่ต้องการ'
                : 'Choose your preferred method',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 16),

          // ── QR Payment ──
          PaymentMethodCard(
            id: 'qr_payment',
            isSelected: selectedMethod == 'qr_payment',
            onTap: () => onMethodChanged('qr_payment'),
            leading: const PaymentIconBadge(
              icon: Icons.qr_code_2,
              color: Colors.white,
              bg: Color(0xFF4A90D9),
            ),
            title: l10n.qrPayment,
            subtitle: l10n.qrPaymentSubtitle,
            extra: const PaymentAppDots(),
          ),

          // ── Credit / Debit Card ──
          PaymentMethodCard(
            id: 'credit_card',
            isSelected: selectedMethod == 'credit_card',
            onTap: () => onMethodChanged('credit_card'),
            leading: const PaymentCardLeading(),
            title: l10n.creditCard,
            subtitle: l10n.creditCardSubtitle,
          ),

          // ── Alipay ──
          PaymentMethodCard(
            id: 'alipay',
            isSelected: selectedMethod == 'alipay',
            onTap: () => onMethodChanged('alipay'),
            leading: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(4),
              child: Image.asset('assets/images/alipay.png', fit: BoxFit.contain),
            ),
            title: 'Alipay',
            subtitle: l10n.aliPaySubtitle,
          ),

          // ── LINE Pay ──
          PaymentMethodCard(
            id: 'line_pay',
            isSelected: selectedMethod == 'line_pay',
            onTap: () => onMethodChanged('line_pay'),
            leading: const PaymentIconBadge(
              icon: Icons.chat_bubble,
              color: Colors.white,
              bg: Color(0xFF06C755),
            ),
            title: 'LINE Pay',
            subtitle: l10n.linePaySubtitle,
          ),
        ],
      ),
    );
  }
}
