import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../widgets/grid/HoverMenuCard.dart';

class HomepageMenu extends StatelessWidget{
  const HomepageMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: HoverMenuCard(
            titleTh: Text(AppLocalizations.of(context)!.deposit),
            icon: Icons.download_outlined,
            color: Colors.orange,
            onPressed: () => Navigator.pushNamed(context, '/user-type-page'),
            aspectRatio: 1.4,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: HoverMenuCard(
            titleTh :Text(AppLocalizations.of(context)!.receive),
            icon : Icons.upload_outlined,
            color : Colors.blue,
            onPressed : ()=> Navigator.pushNamed(context, '/unlock'),
            aspectRatio: 1.4,
          ),
        ),
      ],
    );
  }
}