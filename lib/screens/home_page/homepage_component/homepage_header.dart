import 'package:flutter/material.dart';
import 'package:untitled/main.dart';
import 'package:untitled/services/app_settings.dart';

class HomepageHeader extends StatelessWidget {
  const HomepageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final displayText =
        currentLocale.languageCode == 'th' ? 'ไทย' : 'English';

    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 940;
    final appState = MyApp.of(context);

    final isDark =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    final logoSize = isTablet ? 150.0 : 150.0;

    return AnimatedBuilder(
      animation: AppSettings.instance,
      builder: (context, _) {
        final logoPath = AppSettings.instance.logoAsset;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLogo(logoPath, logoSize),

            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  _HeaderActionButton(
                    isDark: isDark,
                    borderRadius: 12,
                    onTap: () => appState?.toggleLocale(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.language,
                          size: 20,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          displayText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  _HeaderActionButton(
                    isDark: isDark,
                    borderRadius: 12,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    onTap: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const _SettingsPasswordDialog(),
                      );

                      if (ok == true && context.mounted) {
                        Navigator.pushNamed(context, '/settings');
                      }
                    },
                    child: Icon(
                      Icons.settings,
                      size: 20,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLogo(String path, double size) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          return _fallbackLogo(size);
        },
      );
    }

    return Image.asset(
      path.isEmpty ? 'assets/images/logo.png' : path,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) {
        return _fallbackLogo(size);
      },
    );
  }

  Widget _fallbackLogo(double size) {
    return Icon(
      Icons.image_not_supported,
      size: size * 0.6,
      color: Colors.grey,
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool isDark;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const _HeaderActionButton({
    required this.child,
    required this.onTap,
    required this.isDark,
    required this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.15)
              : Colors.grey.shade300,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
            child: child,
          ),
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
    final isDark =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

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
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('ยกเลิก'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('เข้าใช้งาน'),
        ),
      ],
    );
  }
}