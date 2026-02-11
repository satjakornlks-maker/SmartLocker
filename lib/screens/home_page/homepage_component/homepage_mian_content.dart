import 'package:flutter/material.dart';
import 'package:untitled/screens/home_page/homepage_component/homepage_bottom.dart';
import 'package:untitled/screens/home_page/homepage_component/homepage_menu.dart';

import '../../../l10n/app_localizations.dart';

class HomepageMianContent extends StatelessWidget{
  const HomepageMianContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        100,
        0,
        100,
        0,
      ), // Tablet: add margin

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.welcome,style: TextStyle(fontSize: 40),),
          const SizedBox(height: 5),
          Text(AppLocalizations.of(context)!.chose),
          const SizedBox(height: 20),
          const HomepageMenu(),
          const SizedBox(height: 30),
          const HomepageBottom(),
        ],
      ),
    );
  }
}