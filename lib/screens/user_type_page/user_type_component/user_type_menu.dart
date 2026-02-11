import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../widgets/grid/HoverMenuCard.dart';
import '../../common/chose_size_page/chose_size_page.dart';
import '../../deposite_type_page/deposit_type_page.dart';
import '../../input_type_page/input_type_page/input_type_page.dart';

class UserTypeMenu extends StatelessWidget{
  final String systemMode;
  const UserTypeMenu({super.key, required this.systemMode});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: HoverMenuCard(
            titleTh: Text(AppLocalizations.of(context)!.employee),
            icon: Icons.home_work,
            color: Colors.blue,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DepositTypePage(),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: HoverMenuCard(
            titleTh: Text(AppLocalizations.of(context)!.visitor),
            icon: Icons.person,
            color: Colors.blue,
            onPressed: () => systemMode == 'B2C'
                ? Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChoseSizePage(
                      from: FromPage.visitor,
                    ),
              ),
            )
                : Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    InputTypePage(
                      from: FromPage.visitor,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}