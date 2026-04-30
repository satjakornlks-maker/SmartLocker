import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';
import 'package:untitled/widgets/buttons/primary_button.dart';
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
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.overtimePaymentTitle,
            style: AppText.titleLargeR(context).copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            l10n.paymentChannels,
            style: AppText.caption.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),

          OvertimeMethodCard(
            isSelected: selectedMethod == 'qr_payment',
            onTap: () => onMethodChanged('qr_payment'),
            leading: const OvertimeIconBadge(
              icon: Icons.qr_code_2,
              color: AppColors.textOnPrimary,
              bg: AppColors.primary,
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
          OvertimeMethodCard(
            isSelected: selectedMethod == 'line_pay',
            onTap: () => onMethodChanged('line_pay'),
            leading: const OvertimeIconBadge(
              icon: Icons.chat_bubble,
              color: AppColors.textOnPrimary,
              bg: Color(0xFF06C755),
            ),
            title: 'LINE Pay',
            subtitle: l10n.linePaySubtitle,
          ),

          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),

          if (isExpanded)
            Expanded(
              child: Center(child: _buildIllustration(selectedMethod, l10n)),
            )
          else
            Center(child: _buildIllustration(selectedMethod, l10n)),

          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.overtimeFine,
                style: AppText.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '$fineAmount ${l10n.baht}',
                style: const TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: AppColors.info.withOpacity(0.08),
              borderRadius: AppRadius.smRadius,
              border: Border.all(
                // ignore: deprecated_member_use
                color: AppColors.info.withOpacity(0.25),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.info,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    l10n.autoOpenNote,
                    style: AppText.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          PrimaryButton(
            label: l10n.payNow,
            expand: true,
            icon: Icons.payments_outlined,
            onPressed: onPay,
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
