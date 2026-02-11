import 'package:flutter/material.dart';
import 'package:untitled/widgets/header/header.dart';

import 'deposite_type_component/deposit_type_main_content.dart';
import 'package:untitled/main.dart';

class DepositTypePage extends StatefulWidget {
  const DepositTypePage({super.key});

  @override
  State<DepositTypePage> createState() => _DepositTypePageState();
}

class _DepositTypePageState extends State<DepositTypePage> {
  String? selectedType; // Track selected type: 'login' or 'member'
  static const String systemMode = String.fromEnvironment('TYPE', defaultValue: 'B2C');
  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final appState = MyApp.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Header(currentLocale: currentLocale, onLanguageSwitch: () {
                  appState?.toggleLocale();
                },),
                const SizedBox(height: 40),
                DepositTypeMainContent(systemMode: systemMode)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
