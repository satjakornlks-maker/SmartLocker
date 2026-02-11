import 'package:flutter/material.dart';
import 'package:untitled/screens/user_type_page/user_type_component/user_type_main_content.dart';
import 'package:untitled/widgets/header/header.dart';
import 'package:untitled/main.dart';

class UserTypePage extends StatefulWidget {
  const UserTypePage({super.key});
  @override
  State<UserTypePage> createState() => _UserTypePage();
}

class _UserTypePage extends State<UserTypePage> {
  static const String systemMode = String.fromEnvironment('TYPE', defaultValue: 'B2C');
  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final appState = MyApp.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Header(currentLocale: currentLocale, onLanguageSwitch: () {
                      appState?.toggleLocale();
                    },),
                    const SizedBox(height: 60),

                    // Center content
                    const UserTypeMainContent(systemMode: systemMode)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
