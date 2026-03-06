import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';

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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.bookingTypeTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _TypeCard(
            type: 'day',
            selectedType: bookingType,
            icon: Icons.calendar_today_rounded,
            label: l10n.bookByDay,
            price: '$dailyRate ${l10n.baht} / ${l10n.day}',
            iconColor: const Color(0xFF4A90D9),
            onTap: () => onTypeChanged('day'),
          ),
          const SizedBox(height: 12),
          _TypeCard(
            type: 'hour',
            selectedType: bookingType,
            icon: Icons.access_time_rounded,
            label: l10n.bookByHour,
            price: '$hourlyRate ${l10n.baht} / ${l10n.hour}',
            iconColor: Colors.blueGrey,
            onTap: () => onTypeChanged('hour'),
          ),
          const SizedBox(height: 24),
          Text(
            '${l10n.amount} ($unitLabel)',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          _buildQuantityStepper(unitLabel),
        ],
      ),
    );
  }

  Widget _buildQuantityStepper(String unitLabel) {
    return Row(
      children: [
        _StepperButton(
          icon: Icons.remove,
          enabled: quantity > 1,
          onTap: () => onQuantityChanged(quantity - 1),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              color: const Color(0xFFEBF4FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF4A90D9).withValues(alpha: 0.35),
              ),
            ),
            child: Center(
              child: Text(
                '$quantity $unitLabel',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90D9),
                ),
              ),
            ),
          ),
        ),
        _StepperButton(
          icon: Icons.add,
          enabled: quantity < _max,
          onTap: () => onQuantityChanged(quantity + 1),
        ),
      ],
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: _isSelected ? const Color(0xFFEBF4FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isSelected ? const Color(0xFF4A90D9) : Colors.grey.shade300,
            width: _isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _isSelected
                          ? const Color(0xFF4A90D9)
                          : Colors.black87,
                    ),
                  ),
                  Text(
                    price,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            if (_isSelected)
              Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _StepperButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF4A90D9) : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white : Colors.grey.shade500,
          size: 22,
        ),
      ),
    );
  }
}
