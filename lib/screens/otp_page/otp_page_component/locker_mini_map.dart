import 'package:flutter/material.dart';
import 'package:untitled/theme/theme.dart';

class LockerMiniMap extends StatelessWidget {
  final List<Map<String, dynamic>> lockerData;
  final String? selectedLockerId;
  final String? selectedLockerName;

  const LockerMiniMap({
    super.key,
    required this.lockerData,
    required this.selectedLockerId,
    this.selectedLockerName,
  });

  @override
  Widget build(BuildContext context) {
    if (lockerData.isEmpty) return const SizedBox.shrink();

    final Map<int, List<Map<String, dynamic>>> grouped = {};
    for (var unit in lockerData) {
      final lockerId = unit['lockerId'] as int? ?? 0;
      grouped.putIfAbsent(lockerId, () => []);
      grouped[lockerId]!.add(unit);
    }

    return Semantics(
      label: selectedLockerName != null
          ? 'Locker map. Locker $selectedLockerName is selected.'
          : 'Locker map',
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.lgRadius,
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedLockerName != null) ...[
              Text(
                '#$selectedLockerName',
                style: const TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            FittedBox(
              fit: BoxFit.contain,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: grouped.entries.map((entry) {
                  final units = entry.value;
                  final isLast = entry.key == grouped.keys.last;
                  return Row(
                    children: [
                      _buildMiniSection(units),
                      if (!isLast) const SizedBox(width: AppSpacing.sm),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniSection(List<Map<String, dynamic>> units) {
    int maxCol = 0;
    int maxRow = 0;
    for (var unit in units) {
      final x = unit['x'] as int? ?? 0;
      final y = unit['y'] as int? ?? 0;
      final w = unit['w'] as int? ?? 1;
      final h = unit['h'] as int? ?? 1;
      if (x + w > maxCol) maxCol = x + w;
      if (y + h > maxRow) maxRow = y + h;
    }

    if (maxCol == 0 || maxRow == 0) return const SizedBox.shrink();

    const double cellSize = 80.0;
    const double gap = 4.0;

    final double gridWidth = maxCol * cellSize + (maxCol - 1) * gap;
    final double gridHeight = maxRow * cellSize + (maxRow - 1) * gap;

    return SizedBox(
      width: gridWidth,
      height: gridHeight,
      child: Stack(
        children: units.map((entry) {
          final lockerId = entry['id']?.toString() ?? '';
          final lockerName = entry['name']?.toString() ?? '';
          final int x = entry['x'] as int? ?? 0;
          final int y = entry['y'] as int? ?? 0;
          final int w = entry['w'] as int? ?? 1;
          final int h = entry['h'] as int? ?? 1;

          final double left = x * (cellSize + gap);
          final double top = y * (cellSize + gap);
          final double width = w * cellSize + (w - 1) * gap;
          final double height = h * cellSize + (h - 1) * gap;

          final isSelected = lockerId == selectedLockerId;

          return Positioned(
            left: left,
            top: top,
            width: width,
            height: height,
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.surfaceMuted,
                borderRadius: AppRadius.smRadius,
                border: isSelected
                    ? Border.all(
                        // ignore: deprecated_member_use
                        color: AppColors.accent.withOpacity(0.9),
                        width: 2,
                      )
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: AppColors.accent.withOpacity(0.5),
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    lockerName,
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? AppColors.textOnPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
