import 'package:flutter/material.dart';
import 'package:untitled/screens/home_page/homepage_component/homepage_bottom.dart';
import 'package:untitled/screens/home_page/homepage_component/homepage_menu.dart';
import 'package:untitled/theme/theme.dart';

import '../../../l10n/app_localizations.dart';

class HomepageMainContent extends StatelessWidget{
  const HomepageMainContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final sidePad = width > 1200 ? 100.0 : (width > 800 ? 48.0 : 24.0);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: sidePad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.welcome,style: TextStyle(fontSize: 40),),
          const SizedBox(height: 5),
          Text(AppLocalizations.of(context)!.chose),
          const SizedBox(height: 20),
          const HomePageMenu(),
          const SizedBox(height: 30),
          const HomepageBottom(),
          // TextButton(onPressed: (){Navigator.pushNamed(context,'/test-page');}, child: Text("TestPage"))
        ],
      ),
    );
  }
}
