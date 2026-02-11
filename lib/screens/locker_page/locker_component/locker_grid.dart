import 'package:flutter/material.dart';
import '../locker_selection_page.dart';
import 'locker_section.dart';

class LockerGrid extends StatelessWidget {
  final Map<int, List<Map<String, dynamic>>> groupedLockers;
  final double availableWidth;
  final double availableHeight;
  final LockerSelectionMode mode;
  final String? selectedLocker;
  final Function(String lockerId, bool isAvailable, String lockerName) onTap;

  const LockerGrid({
    super.key,
    required this.groupedLockers,
    required this.availableWidth,
    required this.availableHeight,
    required this.mode,
    required this.selectedLocker,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (groupedLockers.isEmpty) {
      return const Text('No lockers available');
    }

    final int sectionCount = groupedLockers.length;
    const double sectionGap = 30.0;

    // Available width per section
    final double availableWidthPerSection =
        (availableWidth - (sectionCount - 1) * sectionGap) / sectionCount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedLockers.entries.map((entry) {
        final lockerId = entry.key;
        final units = entry.value;
        final isLast = entry.key == groupedLockers.keys.last;

        return Row(
          children: [
            LockerSection(
              lockerId: lockerId,
              units: units,
              availableWidth: availableWidthPerSection,
              availableHeight: availableHeight,
              mode: mode,
              selectedLocker: selectedLocker,
              onTap: onTap,
            ),
            if (!isLast) const SizedBox(width: 30),
          ],
        );
      }).toList(),
    );
  }
}