import 'package:flutter/material.dart';
import 'package:untitled/screens/deposit_type_page/deposit_type_component/selection_card.dart';
import 'package:untitled/theme/theme.dart';

import '../../../l10n/app_localizations.dart';
import '../../chose_size_page/chose_size_page.dart';
import '../../input_type_page/input_type_page/input_type_page.dart';
import '../../locker_page/locker_selection_page.dart';

class TopSelectionCard extends StatelessWidget {
  final String systemMode;
  const TopSelectionCard({super.key, required this.systemMode});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: SelectionCard(
            title: Text(l.choseLocker),
            semanticLabel: '${l.choseLocker}. Tap to choose a locker.',
            icon: Icons.login_rounded,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChoseSizePage(
                  mode: LockerSelectionMode.booking,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: SelectionCard(
            title: Text(l.randomLocker),
            semanticLabel: '${l.randomLocker}. Tap for quick booking.',
            icon: Icons.flash_on_rounded,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChoseSizePage(
                  from: FromPage.instance,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
