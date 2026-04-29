import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

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

    final int x = entry['x'] as int? ?? 0;
    final int y = entry['y'] as int? ?? 0;
    final int w = entry['w'] as int? ?? 1;
    final int h = entry['h'] as int? ?? 1;

    final double left = x * (cellWidth + gap);
    final double top = y * (cellHeight + gap);
    final double width = w * cellWidth + (w - 1) * gap;
    final double height = h * cellHeight + (h - 1) * gap;

    final isAvailable = mode == LockerSelectionMode.unlock
        ? status
        : !(status && isEnable);

    final isSelected = selectedLocker == lockerId;

    final Color buttonColor = _getButtonColor(
      isFiltered: isFiltered,
      isSelected: isSelected,
      isEnable: isEnable,
      status: status,
      isAvailable: isAvailable,
    );

    final double baseFontSize = (cellWidth * 0.18).clamp(10.0, 16.0);
    final double iconSize = (cellWidth * 0.3).clamp(16.0, 32.0);

    final String? groupTag = entry['lockerName'] as String?;

    // Build accessible status string for screen reader
    final l = AppLocalizations.of(context)!;
    String semanticStatus;
    if (!isEnable) {
      semanticStatus = l.lockerStatusDisabled;
    } else if (!isFiltered) {
      semanticStatus = l.lockerStatusNotAvailable;
    } else if (mode == LockerSelectionMode.unlock) {
      semanticStatus = status ? l.lockerStatusOccupiedUnlock : l.lockerStatusEmpty;
    } else {
      semanticStatus = isAvailable ? l.lockerStatusAvailable : l.lockerStatusOccupied;
    }

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Semantics(
        label: l.lockerSemanticLabel(lockerName, semanticStatus),
        button: isFiltered && isEnable,
        enabled: isFiltered && isEnable,
        selected: isSelected,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: AppRadius.smRadius,
            border: isSelected
                ? Border.all(color: AppColors.accent, width: 3)
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: AppColors.accent.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: AppRadius.smRadius,
                    onTap: isFiltered && isEnable
                        ? () {
                            HapticFeedback.selectionClick();
                            onTap(lockerId, isAvailable, lockerName);
                          }
                        : null,
                    child: Container(
                      padding: EdgeInsets.all(cellWidth * 0.08),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            w >= 2 || h >= 2
                                ? Icons.inventory_2
                                : Icons.inventory_2_outlined,
                            size: iconSize,
                            color: AppColors.textOnPrimary,
                          ),
                          SizedBox(height: cellHeight * 0.05),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              lockerName,
                              style: TextStyle(
                                fontFamily: AppText.family,
                                fontSize: baseFontSize,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textOnPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (groupTag != null && groupTag.isNotEmpty)
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.smRadius,
                    ),
                    child: Text(
                      groupTag,
                      style: const TextStyle(
                        fontFamily: AppText.family,
                        color: AppColors.textOnPrimary,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getButtonColor({
    required bool isFiltered,
    required bool isSelected,
    required bool isEnable,
    required bool status,
    required bool isAvailable,
  }) {
    if (!isEnable) return AppColors.lockerDisabled;
    if (!isFiltered) return AppColors.lockerDisabled;
    if (isSelected) return AppColors.lockerChoosing;
    if (mode == LockerSelectionMode.unlock) {
      return status ? AppColors.lockerOccupied : AppColors.lockerEmpty;
    }
    return isAvailable ? AppColors.lockerEmpty : AppColors.lockerOccupied;
  }
}
