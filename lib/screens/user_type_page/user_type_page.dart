import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:untitled/services/device_config_service.dart';
import 'package:untitled/screens/user_type_page/user_type_component/user_type_main_content.dart';
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [
                    Color(0xFF08111F),
                    Color(0xFF0D1B2A),
                    Color(0xFF132238),
                  ]
                : const [
                    Color(0xFFF7FAFF),
                    Color(0xFFEFF4FB),
                    Color(0xFFE4EDF8),
                  ],
          ),
        ),
        child: Stack(
          children: [
            _BackgroundGlow(
              top: -120,
              left: -80,
              size: 260,
              color: isDark
                  ? Colors.cyanAccent.withOpacity(0.08)
                  : Colors.blue.withOpacity(0.16),
            ),
            _BackgroundGlow(
              top: 100,
              right: -90,
              size: 220,
              color: isDark
                  ? Colors.blueAccent.withOpacity(0.08)
                  : Colors.indigo.withOpacity(0.12),
            ),
            _BackgroundGlow(
              bottom: -120,
              left: 30,
              size: 280,
              color: isDark
                  ? Colors.tealAccent.withOpacity(0.06)
                  : Colors.cyan.withOpacity(0.10),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: _GlassShell(
                  isDark: isDark,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Column(
                        children: [
                          Header(
                            currentLocale: currentLocale,
                            onLanguageSwitch: () {
                              appState?.toggleLocale();
                            },
                          ),
                          const SizedBox(height: 8),
                          UserTypeMainContent(systemMode: systemMode),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassShell extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const _GlassShell({
    required this.child,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.white.withOpacity(0.30),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.10)
                  : Colors.white.withOpacity(0.55),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.28)
                    : Colors.black.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: child,
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