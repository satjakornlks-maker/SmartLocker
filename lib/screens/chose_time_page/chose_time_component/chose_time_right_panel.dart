import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
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
    final eligiblePromos = mockPromotions
        .where((p) => p.isEligible(bookingType, quantity))
        .toList();
    final bestPromo = eligiblePromos.isEmpty
        ? null
        : eligiblePromos.reduce((a, b) =>
            a.computeDiscount(subtotal) >= b.computeDiscount(subtotal) ? a : b);

    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            l10n.priceDetails,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),
          _PromotionsSection(
            bookingType: bookingType,
            quantity: quantity,
            subtotal: subtotal,
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 20),
          Text(
            l10n.promoCode,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          _PromoInput(
            controller: promoController,
            promoError: promoError,
            promoDiscount: promoDiscount,
            isPromoApplied: isPromoApplied,
            onApply: onApplyPromo,
            onChanged: onPromoChanged,
          ),
          const SizedBox(height: 24),
          const Spacer(),
          _ConfirmButton(onConfirm: onConfirm),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.price,
                  style:
                      TextStyle(color: Colors.grey.shade600, fontSize: 14)),
              Text(
                '$typeLabel ($quantity $unitLabel)',
                style:
                    TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$subtotal ${l10n.baht}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          if (autoPromoDiscount > 0) ...[
            const SizedBox(height: 8),
            _DiscountRow(
              label: autoPromoLabel,
              discount: autoPromoDiscount,
              bahtLabel: l10n.baht,
              icon: Icons.auto_awesome,
            ),
          ],
          if (isPromoApplied) ...[
            const SizedBox(height: 8),
            _DiscountRow(
              label: '${l10n.discountCode} "$appliedCode"',
              discount: promoDiscount,
              bahtLabel: l10n.baht,
              icon: Icons.discount_outlined,
            ),
          ],
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.totalAmount,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$total ${l10n.baht}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90D9),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green, size: 14),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          Text(
            '-$discount $bahtLabel',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.green,
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
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
    final bgColor = isEligible
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFF5F5F5);
    final borderColor = isEligible
        ? const Color(0xFF81C784)
        : Colors.grey.shade300;
    final textColor = isEligible ? Colors.green.shade700 : Colors.grey.shade500;
    final discountColor = isEligible ? Colors.green : Colors.grey.shade400;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(
            isEligible ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isEligible ? Colors.green : Colors.grey.shade400,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  conditionText,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Text(
            discountText,
            style: TextStyle(
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
              child: TextField(
                controller: controller,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: l10n.enterPromoCode,
                  prefixIcon: const Icon(Icons.discount_outlined,
                      color: Color(0xFF4A90D9)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Color(0xFF4A90D9), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 13),
                ),
                onChanged: (_) => onChanged(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onApply,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90D9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Text(l10n.applyCode,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        if (promoError.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 14),
              const SizedBox(width: 4),
              Text(promoError,
                  style:
                      const TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ),
        ],
        if (isPromoApplied) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 14),
              const SizedBox(width: 4),
              Text(
                '${l10n.promoApplied} -$promoDiscount ${l10n.baht}',
                style:
                    const TextStyle(color: Colors.green, fontSize: 12),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final VoidCallback onConfirm;

  const _ConfirmButton({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onConfirm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A90D9),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          elevation: 3,
        ),
        child: Text(
          l10n.proceedBooking,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
