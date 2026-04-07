import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:untitled/services/app_settings.dart';
import 'homepage_component/homepage_body.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, this.logoAsset});

  final String title;
  final String? logoAsset;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? _emergencyTimer;

  Future<void> _openSettings() async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _SettingsPasswordDialog(),
    );

    if (ok == true && context.mounted) {
      Navigator.pushNamed(context, '/settings');
    }
  }

  @override
  Widget build(BuildContext context) {
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

            Positioned.fill(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: _GlassShell(
                    isDark: isDark,
                    child: HomepageBody(
                      logoAsset: widget.logoAsset,
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

  @override
  void dispose() {
    _emergencyTimer?.cancel();
    super.dispose();
  }
}

class _HeaderCircleButton extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const _HeaderCircleButton({
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.white.withOpacity(0.70),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.15)
                  : Colors.black.withOpacity(0.08),
            ),
          ),
          child: Icon(
            icon,
            size: 22,
            color: isDark ? Colors.white : Colors.black87,
          ),
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

class _SettingsPasswordDialog extends StatefulWidget {
  const _SettingsPasswordDialog();

  @override
  State<_SettingsPasswordDialog> createState() =>
      _SettingsPasswordDialogState();
}

class _SettingsPasswordDialogState extends State<_SettingsPasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;
  String? _errorText;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final ok = AppSettings.instance.verifySettingsPassword(
      _passwordController.text,
    );

    if (ok) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _errorText = 'รหัสผ่านไม่ถูกต้อง';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF132238) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('กรอกรหัสผ่าน'),
      content: SizedBox(
        width: 360,
        child: TextField(
          controller: _passwordController,
          obscureText: _obscure,
          autofocus: true,
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: _errorText,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscure = !_obscure;
                });
              },
              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('ยกเลิก'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('เข้าใช้งาน')),
      ],
    );
  }
}
