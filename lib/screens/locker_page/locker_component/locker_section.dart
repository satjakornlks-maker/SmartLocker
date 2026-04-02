import 'package:flutter/material.dart';
import '../locker_selection_page.dart';
import 'locker_cell.dart';

class LockerSection extends StatelessWidget {
  final int lockerId;
  final String? lockerName;
  final List<Map<String, dynamic>> units;
  final double availableWidth;
  final double availableHeight;
  final LockerSelectionMode mode;
  final String? selectedLocker;
  final Function(String lockerId, bool isAvailable, String lockerName) onTap;

  const LockerSection({
    super.key,
    required this.lockerId,
    this.lockerName,
    required this.units,
    required this.availableWidth,
    required this.availableHeight,
    required this.mode,
    required this.selectedLocker,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dimensions = _calculateGroupDimensions(units);
    final int columns = dimensions['columns']!;
    final int rows = dimensions['rows']!;

    if (columns == 0 || rows == 0) {
      return const SizedBox.shrink();
    }

    const double gap = 8.0;
    const double topSpacing = 10.0;

    // Adjust available height for the top spacer
    final double gridAvailableHeight = availableHeight - topSpacing;

    // Calculate cell size
    final double maxCellByWidth =
        (availableWidth - (columns - 1) * gap) / columns;
    final double maxCellByHeight =
        (gridAvailableHeight - (rows - 1) * gap) / rows;
    final double cellSize =
    (maxCellByWidth < maxCellByHeight ? maxCellByWidth : maxCellByHeight)
        .clamp(40.0, 120.0);

    // Calculate actual grid dimensions
    final double gridWidth = columns * cellSize + (columns - 1) * gap;
    final double gridHeight = rows * cellSize + (rows - 1) * gap;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        // Grid
        SizedBox(
          width: gridWidth,
          height: gridHeight,
          child: Stack(
            children: units.map((entry) {
              return LockerCell(
                entry: entry,
                cellWidth: cellSize,
                cellHeight: cellSize,
                gap: gap,
                mode: mode,
                selectedLocker: selectedLocker,
                onTap: onTap,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Calculate grid dimensions for a specific group
  static Map<String, int> _calculateGroupDimensions(
      List<Map<String, dynamic>> units,
      ) {
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

    return {'columns': maxCol, 'rows': maxRow};
  }
}