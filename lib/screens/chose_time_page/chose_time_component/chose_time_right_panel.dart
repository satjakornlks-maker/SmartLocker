import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';
import 'package:untitled/widgets/buttons/primary_button.dart';
import 'booking_promotion.dart';

class ChoseTimeRightPanel extends StatelessWidget {
  final String bookingType;
  final int quantity;
  final int subtotal;
  final int total;
  final int promoDiscount;
  final int autoPromoDiscount;
  final bool isPromoApplied;
  final String promoMessage;
  final String promoError;
  final TextEditingController promoController;
  final VoidCallback onApplyPromo;
  final VoidCallback onPromoChanged;
  final VoidCallback onConfirm;

  const ChoseTimeRightPanel({
    super.key,
    required this.bookingType,
    required this.quantity,
    required this.subtotal,
    required this.total,
    required this.promoDiscount,
    required this.autoPromoDiscount,
    required this.isPromoApplied,
    required this.promoMessage,
    required this.promoError,
    required this.promoController,
    required this.onApplyPromo,
    required this.onPromoChanged,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final typeLabel = bookingType == 'day' ? l10n.dayType : l10n.hourType;
    final unitLabel = bookingType == 'day' ? l10n.day : l10n.hour;

    // Find best eligible promo for label display in price summary
    final eligiblePromos =
        mockPromotions.where((p) => p.isEligible(bookingType, quantity)).toList();
    final bestPromo = eligiblePromos.isEmpty
        ? null
        : eligiblePromos.reduce((a, b) =>
            a.computeDiscount(subtotal) >= b.computeDiscount(subtotal) ? a : b);

    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            l10n.priceDetails,
            style: AppText.titleLargeR(context).copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _PriceSummary(
            typeLabel: typeLabel,
            unitLabel: unitLabel,
            quantity: quantity,
            subtotal: subtotal,
            total: total,
            autoPromoDiscount: autoPromoDiscount,
            autoPromoLabel: bestPromo?.label(locale) ?? '',
            promoDiscount: promoDiscount,
            isPromoApplied: isPromoApplied,
            promoMessage: promoMessage,
            appliedCode: promoController.text.trim().toUpperCase(),
          ),
          const SizedBox(height: AppSpacing.xl),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.lg),
          _PromotionsSection(
            bookingType: bookingType,
            quantity: quantity,
            subtotal: subtotal,
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.xl),
          Text(
            l10n.promoCode,
            style: AppText.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _PromoInput(
            controller: promoController,
            promoError: promoError,
            promoDiscount: promoDiscount,
            isPromoApplied: isPromoApplied,
            onApply: onApplyPromo,
            onChanged: onPromoChanged,
          ),
          const SizedBox(height: AppSpacing.xxl),
          const Spacer(),
          PrimaryButton(
            label: l10n.proceedBooking,
            expand: true,
            icon: Icons.arrow_forward,
            onPressed: onConfirm,
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
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
    );
  }
}

// ─── Private sub-widgets ──────────────────────────────────────────────────────

class _PriceSummary extends StatelessWidget {
  final String typeLabel;
  final String unitLabel;
  final int quantity;
  final int subtotal;
  final int total;
  final int autoPromoDiscount;
  final String autoPromoLabel;
  final int promoDiscount;
  final bool isPromoApplied;
  final String promoMessage;
  final String appliedCode;

  const _PriceSummary({
    required this.typeLabel,
    required this.unitLabel,
    required this.quantity,
    required this.subtotal,
    required this.total,
    required this.autoPromoDiscount,
    required this.autoPromoLabel,
    required this.promoDiscount,
    required this.isPromoApplied,
    required this.promoMessage,
    required this.appliedCode,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.price,
                style: AppText.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '$typeLabel ($quantity $unitLabel)',
                style: AppText.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$subtotal ${l10n.baht}',
              style: const TextStyle(
                fontFamily: AppText.family,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (autoPromoDiscount > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            _DiscountRow(
              label: autoPromoLabel,
              discount: autoPromoDiscount,
              bahtLabel: l10n.baht,
              icon: Icons.auto_awesome,
            ),
          ],
          if (isPromoApplied) ...[
            const SizedBox(height: AppSpacing.sm),
            _DiscountRow(
              label: '${l10n.discountCode} "$appliedCode"',
              discount: promoDiscount,
              bahtLabel: l10n.baht,
              icon: Icons.discount_outlined,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.totalAmount,
                style: const TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
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
      ),
    );
  }
}

class _DiscountRow extends StatelessWidget {
  final String label;
  final int discount;
  final String bahtLabel;
  final IconData icon;

  const _DiscountRow({
    required this.label,
    required this.discount,
    required this.bahtLabel,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: AppColors.success.withOpacity(0.12),
        borderRadius: AppRadius.smRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.success, size: 14),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          Text(
            '-$discount $bahtLabel',
            style: const TextStyle(
              fontFamily: AppText.family,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _PromotionsSection extends StatelessWidget {
  final String bookingType;
  final int quantity;
  final int subtotal;

  const _PromotionsSection({
    required this.bookingType,
    required this.quantity,
    required this.subtotal,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    // Only show promotions relevant to the current booking type
    final relevantPromos = mockPromotions
        .where((p) => p.bookingType == bookingType)
        .toList();

    if (relevantPromos.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.availablePromotions,
          style: AppText.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...relevantPromos.map((promo) {
          final isEligible = promo.isEligible(bookingType, quantity);
          final discount = promo.computeDiscount(subtotal);
          return _PromotionCard(
            label: promo.label(locale),
            conditionText: promo.conditionText(locale),
            discountText: promo.discountText(locale),
            discountAmount: discount,
            isEligible: isEligible,
            bahtLabel: l10n.baht,
          );
        }),
      ],
    );
  }
}

class _PromotionCard extends StatelessWidget {
  final String label;
  final String conditionText;
  final String discountText;
  final int discountAmount;
  final bool isEligible;
  final String bahtLabel;

  const _PromotionCard({
    required this.label,
    required this.conditionText,
    required this.discountText,
    required this.discountAmount,
    required this.isEligible,
    required this.bahtLabel,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    final bgColor = isEligible
        // ignore: deprecated_member_use
        ? AppColors.success.withOpacity(0.10)
        : AppColors.surfaceMuted;
    final borderColor = isEligible
        // ignore: deprecated_member_use
        ? AppColors.success.withOpacity(0.55)
        : AppColors.border;
    final textColor =
        isEligible ? AppColors.success : AppColors.textDisabled;
    final discountColor =
        isEligible ? AppColors.success : AppColors.textDisabled;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.smRadius,
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(
            isEligible ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isEligible ? AppColors.success : AppColors.textDisabled,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  conditionText,
                  style: AppText.caption
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            discountText,
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: discountColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoInput extends StatelessWidget {
  final TextEditingController controller;
  final String promoError;
  final int promoDiscount;
  final bool isPromoApplied;
  final VoidCallback onApply;
  final VoidCallback onChanged;

  const _PromoInput({
    required this.controller,
    required this.promoError,
    required this.promoDiscount,
    required this.isPromoApplied,
    required this.onApply,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                textField: true,
                label: l10n.enterPromoCode,
                child: TextField(
                  controller: controller,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: l10n.enterPromoCode,
                    prefixIcon: const Icon(
                      Icons.discount_outlined,
                      color: AppColors.primary,
                    ),
                    filled: true,
                    // ignore: deprecated_member_use
                    fillColor: AppColors.primary.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.smRadius,
                      borderSide:
                          const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.smRadius,
                      borderSide:
                          const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppRadius.smRadius,
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                  ),
                  onChanged: (_) => onChanged(),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            PrimaryButton(
              label: l10n.applyCode,
              onPressed: onApply,
            ),
          ],
        ),
        if (promoError.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Semantics(
            liveRegion: true,
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 14,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  promoError,
                  style: const TextStyle(
                    fontFamily: AppText.family,
                    color: AppColors.error,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (isPromoApplied) ...[
          const SizedBox(height: AppSpacing.xs),
          Semantics(
            liveRegion: true,
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 14,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${l10n.promoApplied} -$promoDiscount ${l10n.baht}',
                  style: const TextStyle(
                    fontFamily: AppText.family,
                    color: AppColors.success,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
