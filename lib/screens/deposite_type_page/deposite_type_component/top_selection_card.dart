import 'package:flutter/material.dart';
import 'package:untitled/screens/deposite_type_page/deposite_type_component/selection_card.dart';

import '../../../l10n/app_localizations.dart';
import '../../chose_size_page/chose_size_page.dart';
import '../../input_type_page/input_type_page/input_type_page.dart';
import '../../locker_page/locker_selection_page.dart';

class TopSelectionCard extends StatelessWidget{
  final String systemMode;
  const TopSelectionCard({super.key, required this.systemMode});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SelectionCard(
            title: Text(AppLocalizations.of(context)!.choseLocker),
            icon: Icons.login_rounded,
            onTap: () => systemMode == 'B2C'
                ? Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const ChoseSizePage(
                  mode:
                  LockerSelectionMode.booking,
                ),
              ),
            )
                : Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const LockerSelectionPage(
                  mode:
                  LockerSelectionMode.booking,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: SelectionCard(
            title: Text(AppLocalizations.of(context)!.randomLocker),
            icon: Icons.flash_on_rounded,
            onTap: () => systemMode == 'B2C'
                ? Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const ChoseSizePage(
                  from: FromPage.instance,
                ),
              ),
            )
                : Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const InputTypePage(
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