import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';

class LockerLegend extends StatelessWidget {
  const LockerLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
          Colors.green,
          Text(
            AppLocalizations.of(context)!.empty,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        const SizedBox(width: 25),
        _buildLegendItem(Colors.red.shade400, Text(
          AppLocalizations.of(context)!.occupiedLegend,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),),
        const SizedBox(width: 25),
        _buildLegendItem(Colors.yellow.shade700, Text(
          AppLocalizations.of(context)!.choosing,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),),
        const SizedBox(width: 25),
        _buildLegendItem(Colors.grey.shade400, Text(
          AppLocalizations.of(context)!.cantBeUse,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),),
      ],
    );
  }

  Widget _buildLegendItem(Color color, Widget label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        label
      ],
    );
  }
}
