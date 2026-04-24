import 'package:flutter/material.dart';

class HomePageMenu extends StatelessWidget {
  const HomePageMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    if (isPortrait) {
      return Column(
        children: [
          _AnimatedMenuCard(
            title: 'ฝากของ',
            subtitle: 'เริ่มต้นฝากพัสดุเข้าตู้ล็อกเกอร์',
            icon: Icons.move_to_inbox_rounded,
            accentColor: const Color(0xFF2563EB),
            onTap: () {
              Navigator.pushNamed(context, '/user-type-page');
            },
          ),
          const SizedBox(height: 16),
          _AnimatedMenuCard(
            title: 'รับของ',
            subtitle: 'รับพัสดุด้วย OTP หรือรหัสยืนยัน',
            icon: Icons.inventory_2_rounded,
            accentColor: const Color(0xFF0F9D58),
            onTap: () {
              Navigator.pushNamed(context, '/otp-unlock-page');
            },
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _AnimatedMenuCard(
            title: 'ฝากของ',
            subtitle: 'เริ่มต้นฝากพัสดุเข้าตู้ล็อกเกอร์',
            icon: Icons.move_to_inbox_rounded,
            accentColor: const Color(0xFF2563EB),
            onTap: () {
              Navigator.pushNamed(context, '/user-type-page');
            },
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: _AnimatedMenuCard(
            title: 'รับของ',
            subtitle: 'รับพัสดุด้วย OTP หรือรหัสยืนยัน',
            icon: Icons.inventory_2_rounded,
            accentColor: const Color(0xFF0F9D58),
            onTap: () {
              Navigator.pushNamed(context, '/unlock');
            },
          ),
        ),
      ],
    );
  }
}

class _AnimatedMenuCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _AnimatedMenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_AnimatedMenuCard> createState() => _AnimatedMenuCardState();
}

class _AnimatedMenuCardState extends State<_AnimatedMenuCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() {
        _pressed = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: isDark
                ? Colors.white.withOpacity(_pressed ? 0.08 : 0.10)
                : Colors.white.withOpacity(_pressed ? 0.82 : 0.92),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.12)
                  : const Color(0xFFE7ECF3),
            ),
            boxShadow: [
              BoxShadow(
                color: _pressed
                    ? Colors.black.withOpacity(0.08)
                    : Colors.black.withOpacity(0.14),
                blurRadius: _pressed ? 10 : 24,
                offset: Offset(0, _pressed ? 4 : 12),
              ),
            ],
          ),
          child: AspectRatio(
            aspectRatio:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 1.45
                    : 1.65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: widget.accentColor.withOpacity(_pressed ? 0.24 : 0.14),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.accentColor,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    AnimatedSlide(
                      offset: _pressed ? const Offset(0.08, 0) : Offset.zero,
                      duration: const Duration(milliseconds: 160),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: widget.accentColor,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDark
                        ? Colors.white.withOpacity(0.72)
                        : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}