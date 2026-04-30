import 'package:flutter/material.dart';
import 'package:untitled/services/device_config_service.dart';
import 'package:untitled/theme/theme.dart';
import 'package:untitled/widgets/header/header.dart';

import 'deposit_type_component/deposit_type_main_content.dart';
import 'package:untitled/main.dart';

class DepositTypePage extends StatefulWidget {
  const DepositTypePage({super.key});

  @override
  State<DepositTypePage> createState() => _DepositTypePageState();
}

class _DepositTypePageState extends State<DepositTypePage> {
  String? selectedType;
  String get systemMode => DeviceConfigService.systemMode;

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final appState = MyApp.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                currentLocale: currentLocale,
                onLanguageSwitch: () {
                  appState?.toggleLocale();
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: DepositTypeMainContent(systemMode: systemMode),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
