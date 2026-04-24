import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/theme/theme.dart';

class SelectionCard extends StatefulWidget {
  final Widget title;
  final IconData icon;
  final VoidCallback onTap;
  final String? semanticLabel;

  const SelectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.semanticLabel,
  });

  @override
  State<SelectionCard> createState() => _SelectionCardState();
}

class _SelectionCardState extends State<SelectionCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Material(
          color: AppColors.surface,
          borderRadius: AppRadius.xlRadius,
          child: InkWell(
            borderRadius: AppRadius.xlRadius,
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onTap();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              constraints: const BoxConstraints(
                minHeight: AppTouch.minTarget * 3,
              ),
              padding: const EdgeInsets.all(AppSpacing.huge),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.xlRadius,
                border: Border.all(
                  color: _hovered ? AppColors.accent : AppColors.border,
                  width: _hovered ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(_hovered ? 0.10 : 0.05),
                    blurRadius: _hovered ? 15 : 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: _hovered
                          // ignore: deprecated_member_use
                          ? AppColors.accent.withOpacity(0.18)
                          : AppColors.surfaceMuted,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      size: 40,
                      color: _hovered
                          ? AppColors.accent
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _hovered
                          ? AppColors.accent
                          : AppColors.textPrimary,
                    ),
                    child: widget.title,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
