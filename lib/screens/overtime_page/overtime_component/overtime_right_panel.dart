import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'overtime_alipay_logo.dart';
import 'overtime_app_dots.dart';
import 'overtime_branded_qr_illustration.dart';
import 'overtime_card_leading.dart';
import 'overtime_credit_card_illustration.dart';
import 'overtime_icon_badge.dart';
import 'overtime_line_pay_logo.dart';
import 'overtime_method_card.dart';
import 'overtime_qr_illustration.dart';

class OvertimeRightPanel extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodChanged;
  final int fineAmount;
  final VoidCallback onPay;
  final bool isExpanded;

  const OvertimeRightPanel({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
    required this.fineAmount,
    required this.onPay,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.overtimePaymentTitle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            l10n.paymentChannels,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 12),

          OvertimeMethodCard(
            isSelected: selectedMethod == 'qr_payment',
            onTap: () => onMethodChanged('qr_payment'),
            leading: const OvertimeIconBadge(
              icon: Icons.qr_code_2,
              color: Colors.white,
              bg: Color(0xFF4A90D9),
            ),
            title: l10n.qrPayment,
            subtitle: l10n.qrPaymentSubtitle,
            extra: const OvertimeAppDots(),
          ),
          OvertimeMethodCard(
            isSelected: selectedMethod == 'credit_card',
            onTap: () => onMethodChanged('credit_card'),
            leading: const OvertimeCardLeading(),
            title: l10n.creditCard,
            subtitle: l10n.creditCardSubtitle,
          ),
          OvertimeMethodCard(
            isSelected: selectedMethod == 'alipay',
            onTap: () => onMethodChanged('alipay'),
            leading: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(4),
              child: Image.asset('assets/images/alipay.png', fit: BoxFit.contain),
            ),
            title: 'Alipay',
            subtitle: l10n.aliPaySubtitle,
          ),
          OvertimeMethodCard(
            isSelected: selectedMethod == 'line_pay',
            onTap: () => onMethodChanged('line_pay'),
            leading: const OvertimeIconBadge(
              icon: Icons.chat_bubble,
              color: Colors.white,
              bg: Color(0xFF06C755),
            ),
            title: 'LINE Pay',
            subtitle: l10n.linePaySubtitle,
          ),

          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),

          if (isExpanded)
            Expanded(
              child: Center(child: _buildIllustration(selectedMethod, l10n)),
            )
          else
            Center(child: _buildIllustration(selectedMethod, l10n)),

          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.overtimeFine,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              Text(
                '$fineAmount ${l10n.baht}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE53935),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: const Color(0xFF4A90D9).withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: Color(0xFF4A90D9), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.autoOpenNote,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPay,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90D9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 3,
              ),
              child: Text(
                l10n.payNow,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration(String method, AppLocalizations l10n) {
    return switch (method) {
      'qr_payment' => OvertimeQrIllustration(l10n: l10n),
      'credit_card' => OvertimeCreditCardIllustration(l10n: l10n),
      'alipay' => OvertimeBrandedQrIllustration(
          brandColor: const Color(0xFF00AAEF),
          bgColor: const Color(0xFFE0F5FD),
          logoWidget: const OvertimeAlipayLogo(),
          scanLabel: l10n.aliPaySubtitle,
        ),
      'line_pay' => OvertimeBrandedQrIllustration(
          brandColor: const Color(0xFF06C755),
          bgColor: const Color(0xFFE6F9ED),
          logoWidget: const OvertimeLinePayLogo(),
          scanLabel: l10n.linePaySubtitle,
        ),
      _ => OvertimeQrIllustration(l10n: l10n),
    };
  }
}
