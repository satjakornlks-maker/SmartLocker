import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';
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

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.paymentChannels,
            style: AppText.titleLargeR(context).copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.choosePreferredMethod,
            style: AppText.caption.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── QR Payment ──
          PaymentMethodCard(
            id: 'qr_payment',
            isSelected: selectedMethod == 'qr_payment',
            onTap: () => onMethodChanged('qr_payment'),
            leading: const PaymentIconBadge(
              icon: Icons.qr_code_2,
              color: AppColors.textOnPrimary,
              bg: AppColors.primary,
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
                color: AppColors.surface,
                borderRadius: AppRadius.smRadius,
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Image.asset(
                'assets/images/alipay.png',
                fit: BoxFit.contain,
              ),
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
              color: AppColors.textOnPrimary,
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
