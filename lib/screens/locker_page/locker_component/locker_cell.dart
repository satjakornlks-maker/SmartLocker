import 'package:flutter/material.dart';

import '../locker_selection_page.dart';

class LockerCell extends StatelessWidget {
  final Map<String, dynamic> entry;
  final double cellWidth;
  final double cellHeight;
  final double gap;
  final LockerSelectionMode mode;
  final String? selectedLocker;
  final Function(String lockerId, bool isAvailable, String lockerName) onTap;

  const LockerCell({
    super.key,
    required this.entry,
    required this.cellWidth,
    required this.cellHeight,
    required this.gap,
    required this.mode,
    required this.selectedLocker,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final lockerId = entry['id']?.toString() ?? '';
    final lockerName = entry['name']?.toString() ?? lockerId;
    final isEnable = entry['enable'] == true;
    final status = entry['status'] == true;
    final isFiltered = entry['_isFiltered'] == true;

    // Position data
    final int x = entry['x'] as int? ?? 0; // Column
    final int y = entry['y'] as int? ?? 0; // Row
    final int w = entry['w'] as int? ?? 1; // Width in cells
    final int h = entry['h'] as int? ?? 1; // Height in cells

    // Calculate position and size
    final double left = x * (cellWidth + gap);
    final double top = y * (cellHeight + gap);
    final double width = w * cellWidth + (w - 1) * gap;
    final double height = h * cellHeight + (h - 1) * gap;

    // Determine availability based on mode
    final isAvailable = mode == LockerSelectionMode.unlock
        ? status // For unlock mode, select occupied (status: true)
        : !status && !isEnable; // For booking mode, select available

    final isSelected = selectedLocker == lockerId;

    // Determine color
    final Color buttonColor = _getButtonColor(
      isFiltered: isFiltered,
      isSelected: isSelected,
      status: status,
      isAvailable: isAvailable,
    );
    final Color borderColor = Colors.transparent;

    // Calculate responsive font and icon sizes based on cell size
    final double baseFontSize = (cellWidth * 0.18).clamp(10.0, 16.0);
    final double iconSize = (cellWidth * 0.3).clamp(16.0, 32.0);

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: isSelected ? 3 : 0),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.orange.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: isFiltered
                ? () => onTap(lockerId, isAvailable, lockerName)
                : null,
            child: Container(
              padding: EdgeInsets.all(cellWidth * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Icon(
                    w >= 2 || h >= 2
                        ? Icons.inventory_2
                        : Icons.inventory_2_outlined,
                    size: iconSize,
                    color: Colors.white,
                  ),
                  SizedBox(height: cellHeight * 0.05),
                  // Locker name
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      lockerName,
                      style: TextStyle(
                        fontSize: baseFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Status indicator for occupied lockers
                  if (status && isFiltered && height > 60)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const FittedBox(fit: BoxFit.scaleDown),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getButtonColor({
    required bool isFiltered,
    required bool isSelected,
    required bool status,
    required bool isAvailable,
  }) {
    if (!isFiltered) {
      return Colors.grey.shade300;
    } else if (isSelected) {
      return Colors.yellow.shade700;
    } else if (mode == LockerSelectionMode.unlock) {
      // Unlock mode: Green = occupied (can unlock), Red = empty
      return status ? Colors.red.shade400 : Colors.green;
    } else {
      // Booking mode: Green = available, Red = occupied
      return isAvailable ? Colors.green : Colors.red.shade400;
    }
  }
}