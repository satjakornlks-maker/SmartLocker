import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

class ChoseTimeLeftPanel extends StatelessWidget {
  final String bookingType;
  final int quantity;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<int> onQuantityChanged;

  static const int dailyRate = 50;
  static const int hourlyRate = 15;

  const ChoseTimeLeftPanel({
    super.key,
    required this.bookingType,
    required this.quantity,
    required this.onTypeChanged,
    required this.onQuantityChanged,
  });

  int get _max => bookingType == 'day' ? 30 : 24;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final unitLabel = bookingType == 'day' ? l10n.day : l10n.hour;

    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.bookingTypeTitle,
            style: AppText.titleLargeR(context).copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _TypeCard(
            type: 'day',
            selectedType: bookingType,
            icon: Icons.calendar_today_rounded,
            label: l10n.bookByDay,
            price: '$dailyRate ${l10n.baht} / ${l10n.day}',
            iconColor: AppColors.primary,
            onTap: () => onTypeChanged('day'),
          ),
          const SizedBox(height: AppSpacing.md),
          _TypeCard(
            type: 'hour',
            selectedType: bookingType,
            icon: Icons.access_time_rounded,
            label: l10n.bookByHour,
            price: '$hourlyRate ${l10n.baht} / ${l10n.hour}',
            iconColor: AppColors.accent,
            onTap: () => onTypeChanged('hour'),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            '${l10n.amount} ($unitLabel)',
            style: AppText.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildQuantityStepper(context, unitLabel),
        ],
      ),
    );
  }

  Widget _buildQuantityStepper(BuildContext context, String unitLabel) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        _StepperButton(
          icon: Icons.remove,
          enabled: quantity > 1,
          semanticLabel: l10n.decreaseUnit(unitLabel),
          onTap: () => onQuantityChanged(quantity - 1),
        ),
        Expanded(
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: AppRadius.smRadius,
              border: Border.all(
                // ignore: deprecated_member_use
                color: AppColors.primary.withOpacity(0.35),
              ),
            ),
            child: Semantics(
              liveRegion: true,
              label: '$quantity $unitLabel',
              child: Center(
                child: Text(
                  '$quantity $unitLabel',
                  style: const TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
        _StepperButton(
          icon: Icons.add,
          enabled: quantity < _max,
          semanticLabel: l10n.increaseUnit(unitLabel),
          onTap: () => onQuantityChanged(quantity + 1),
        ),
      ],
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

class _TypeCard extends StatelessWidget {
  final String type;
  final String selectedType;
  final IconData icon;
  final String label;
  final String price;
  final Color iconColor;
  final VoidCallback onTap;

  const _TypeCard({
    required this.type,
    required this.selectedType,
    required this.icon,
    required this.label,
    required this.price,
    required this.iconColor,
    required this.onTap,
  });

  bool get _isSelected => selectedType == type;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label. $price',
      button: true,
      selected: _isSelected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: AppRadius.mdRadius,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: _isSelected
                  // ignore: deprecated_member_use
                  ? AppColors.primary.withOpacity(0.08)
                  : AppColors.surface,
              borderRadius: AppRadius.mdRadius,
              border: Border.all(
                color: _isSelected ? AppColors.primary : AppColors.border,
                width: _isSelected ? 2 : 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: iconColor.withOpacity(0.12),
                    borderRadius: AppRadius.smRadius,
                  ),
                  child: Icon(icon, color: iconColor, size: 26),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontFamily: AppText.family,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        price,
                        style: AppText.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isSelected)
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppColors.textOnPrimary,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final String semanticLabel;
  final VoidCallback onTap;

  const _StepperButton({
    required this.icon,
    required this.enabled,
    required this.semanticLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: enabled,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled
              ? () {
                  HapticFeedback.lightImpact();
                  onTap();
                }
              : null,
          borderRadius: AppRadius.smRadius,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: AppTouch.minTarget,
            height: AppTouch.minTarget,
            decoration: BoxDecoration(
              color: enabled ? AppColors.primary : AppColors.surfaceMuted,
              borderRadius: AppRadius.smRadius,
            ),
            child: Icon(
              icon,
              color:
                  enabled ? AppColors.textOnPrimary : AppColors.textDisabled,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
