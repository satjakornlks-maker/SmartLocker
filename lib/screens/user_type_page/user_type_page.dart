import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:untitled/services/device_config_service.dart';
import 'package:untitled/screens/user_type_page/user_type_component/user_type_main_content.dart';
import 'package:untitled/theme/theme.dart';
import 'package:untitled/widgets/header/header.dart';
import 'package:untitled/main.dart';

class UserTypePage extends StatefulWidget {
  const UserTypePage({super.key});

  @override
  State<UserTypePage> createState() => _UserTypePageState();
}

class _UserTypePageState extends State<UserTypePage> {
  String get systemMode => DeviceConfigService.systemMode;

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final appState = MyApp.of(context);
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Header(currentLocale: currentLocale, onLanguageSwitch: () {
                appState?.toggleLocale();
              }),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: UserTypeMainContent(systemMode: systemMode),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _BackgroundGlow extends StatelessWidget {
  final double size;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final Color color;

  const _BackgroundGlow({
    required this.size,
    required this.color,
    this.top,
    this.left,
    this.right,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }
}