import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';
import 'package:untitled/widgets/buttons/primary_button.dart';
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
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIllustration(selectedMethod, l10n),
          const SizedBox(height: AppSpacing.xl),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.xl),
          OrderSummary(
            l10n: l10n,
            locale: locale,
            bookingType: bookingType,
            quantity: quantity,
            total: total,
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton.secondary(
            label: l10n.discountDetails,
            icon: Icons.local_offer_outlined,
            onPressed: () {},
          ),
          const Spacer(),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: l10n.payNow,
            icon: Icons.payments_outlined,
            expand: true,
            onPressed: onPay,
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
