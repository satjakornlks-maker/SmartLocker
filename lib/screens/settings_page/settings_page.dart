import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:untitled/services/app_settings.dart';
import 'package:untitled/services/device_config_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController _appTitleController;
  late final TextEditingController _homeTitleController;
  late final TextEditingController _logoAssetController;
  late final TextEditingController _footerLeftController;
  late final TextEditingController _contactInfoController;
  late final TextEditingController _apiBaseUrlController;
  late final TextEditingController _hfConnectionsController;
  late final TextEditingController _restartHourController;
  late final TextEditingController _pollSecController;
  late final TextEditingController _sockTimeoutController;
  late final TextEditingController _settingsPasswordController;

  @override
  void initState() {
    super.initState();

    final settings = AppSettings.instance;

    _appTitleController = TextEditingController(text: settings.appTitle);
    _homeTitleController = TextEditingController(text: settings.homeTitle);
    _logoAssetController = TextEditingController(text: settings.logoAsset);
    _footerLeftController = TextEditingController(text: settings.footerLeft);
    _contactInfoController = TextEditingController(text: settings.contactInfo);
    _apiBaseUrlController = TextEditingController(
      text: settings.apiBaseUrl,
    );
    _hfConnectionsController = TextEditingController(
      text: settings.hfConnections,
    );
    _restartHourController = TextEditingController(
      text: settings.restartHour.toString(),
    );
    _pollSecController = TextEditingController(
      text: settings.pollSec.toString(),
    );
    _sockTimeoutController = TextEditingController(
      text: settings.sockTimeout.toString(),
    );
    _settingsPasswordController = TextEditingController(
      text: settings.settingsPassword,
    );
  }

  @override
  void dispose() {
    _appTitleController.dispose();
    _homeTitleController.dispose();
    _logoAssetController.dispose();
    _footerLeftController.dispose();
    _contactInfoController.dispose();
    _apiBaseUrlController.dispose();
    _hfConnectionsController.dispose();
    _restartHourController.dispose();
    _pollSecController.dispose();
    _sockTimeoutController.dispose();
    _settingsPasswordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await AppSettings.instance.updateGeneral(
      appTitle: _appTitleController.text,
      homeTitle: _homeTitleController.text,
      logoAsset: _logoAssetController.text,
      footerLeft: _footerLeftController.text,
      contactInfo: _contactInfoController.text,
    );

    await AppSettings.instance.updateSystem(
      apiBaseUrl: _apiBaseUrlController.text,
      hfConnections: _hfConnectionsController.text,
      restartHour: int.tryParse(_restartHourController.text) ?? 0,
      pollSec: double.tryParse(_pollSecController.text) ?? 0.3,
      sockTimeout: double.tryParse(_sockTimeoutController.text) ?? 2.0,
    );

    await DeviceConfigService.updateBaseUrl(_apiBaseUrlController.text);

    await AppSettings.instance.updateSettingsPassword(
      _settingsPasswordController.text,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Text('บันทึกการตั้งค่าเรียบร้อย'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
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
              top: 120,
              right: -90,
              size: 220,
              color: isDark
                  ? Colors.blueAccent.withOpacity(0.08)
                  : Colors.indigo.withOpacity(0.12),
            ),
            _BackgroundGlow(
              bottom: -120,
              left: 40,
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
                  child: Column(
                    children: [
                      _SettingsHeader(isDark: isDark),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                          children: [
                            _SectionCard(
                              isDark: isDark,
                              icon: Icons.palette_outlined,
                              title: 'หน้าจอ',
                              child: Column(
                                children: [
                                  _SettingsField(
                                    label: 'ชื่อแอป',
                                    hint: 'เช่น SmartLocker',
                                    controller: _appTitleController,
                                  ),
                                  _SettingsField(
                                    label: 'ชื่อหน้าแรก',
                                    hint: 'เช่น Smart Locker',
                                    controller: _homeTitleController,
                                  ),
                                  _SettingsField(
                                    label: 'ที่อยู่โลโก้',
                                    hint: 'เช่น assets/images/logo.png',
                                    controller: _logoAssetController,
                                  ),
                                  _SettingsField(
                                    label: 'ข้อความด้านล่างฝั่งซ้าย',
                                    hint: 'เช่น ©LANNACOM 2026',
                                    controller: _footerLeftController,
                                  ),
                                  _SettingsField(
                                    label: 'ติดต่อกรณีมีปัญหา',
                                    hint:
                                        'เช่น โทร 02-xxx-xxxx | LINE: @lannacom',
                                    controller: _contactInfoController,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _SectionCard(
                              isDark: isDark,
                              icon: Icons.settings_ethernet_outlined,
                              title: 'ระบบ',
                              child: Column(
                                children: [
                                  _SettingsField(
                                    label: 'Bootstrap URL',
                                    hint: 'เช่น http://10.3.0.4:5183',
                                    controller: _apiBaseUrlController,
                                  ),
                                  _SettingsField(
                                    label: 'HF Connections',
                                    controller: _hfConnectionsController,
                                  ),
                                  _SettingsField(
                                    label: 'Restart Hour',
                                    hint: '0 - 23',
                                    controller: _restartHourController,
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _SectionCard(
                              isDark: isDark,
                              icon: Icons.tune_outlined,
                              title: 'Advanced',
                              child: Column(
                                children: [
                                  _SettingsField(
                                    label: 'Poll Seconds',
                                    hint: 'เช่น 0.3',
                                    controller: _pollSecController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                  ),
                                  _SettingsField(
                                    label: 'Socket Timeout',
                                    hint: 'เช่น 2.0',
                                    controller: _sockTimeoutController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _SectionCard(
                              isDark: isDark,
                              icon: Icons.lock_outline,
                              title: 'ความปลอดภัย',
                              child: Column(
                                children: [
                                  _SettingsField(
                                    label: 'รหัสผ่านเข้าหน้าตั้งค่า',
                                    hint: 'ตั้งรหัสใหม่ (ค่าเริ่มต้น: admin)',
                                    controller: _settingsPasswordController,
                                    obscureText: true,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 22),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(54),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      side: BorderSide(
                                        color: isDark
                                            ? Colors.white.withOpacity(0.18)
                                            : Colors.black.withOpacity(0.08),
                                      ),
                                    ),
                                    child: const Text('ยกเลิก'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _save,
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      minimumSize: const Size.fromHeight(54),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: const Text('บันทึก'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _SettingsHeader extends StatelessWidget {
  final bool isDark;

  const _SettingsHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.white.withOpacity(0.72),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.12)
                    : Colors.black.withOpacity(0.06),
              ),
            ),
            child: Icon(
              Icons.settings_rounded,
              color: isDark ? Colors.white : Colors.black87,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ตั้งค่า',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF102033),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ปรับแต่งหน้าจอและค่าระบบของเครื่อง',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? Colors.white.withOpacity(0.65)
                        : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close_rounded,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.isDark,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.58),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.white.withOpacity(0.70),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.20)
                : Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isDark ? Colors.white70 : const Color(0xFF32465E),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF102033),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _SettingsField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool obscureText;

  const _SettingsField({
    required this.label,
    required this.controller,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final effectiveMaxLines = obscureText ? 1 : maxLines;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: effectiveMaxLines,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
          filled: true,
          fillColor: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.white.withOpacity(0.75),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: isDark
                  ? Colors.white.withOpacity(0.10)
                  : Colors.black.withOpacity(0.06),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: isDark
                  ? Colors.white.withOpacity(0.28)
                  : Colors.blue.withOpacity(0.45),
              width: 1.4,
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }
}

class _GlassShell extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const _GlassShell({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(34),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.white.withOpacity(0.32),
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
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      ),
    );
  }
}
