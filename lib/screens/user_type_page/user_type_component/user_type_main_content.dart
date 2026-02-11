import 'package:flutter/material.dart';
import 'package:untitled/screens/user_type_page/user_type_component/user_type_bottom.dart';
import 'package:untitled/screens/user_type_page/user_type_component/user_type_menu.dart';
import '../../../l10n/app_localizations.dart';

class UserTypeMainContent extends StatelessWidget{
  final String systemMode;
  const UserTypeMainContent({super.key, required this.systemMode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              AppLocalizations.of(context)!.userType,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            UserTypeMenu(systemMode: systemMode),
            const SizedBox(height: 60),
            const UserTypeBottom(),
          ],
        ),
      ),
    );
  }
}