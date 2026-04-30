import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

class LockerLegend extends StatelessWidget {
  const LockerLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: AppSpacing.sm,
      spacing: AppSpacing.xxl,
      children: [
        _buildLegendItem(AppColors.lockerEmpty, l.empty),
        _buildLegendItem(AppColors.lockerOccupied, l.occupiedLegend),
        _buildLegendItem(AppColors.lockerChoosing, l.choosing),
        _buildLegendItem(AppColors.lockerDisabled, l.cantBeUse),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppText.bodySmall.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
