import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/theme/theme.dart';

class HoverMenuCard extends StatefulWidget {
  /// Primary title. Historically called `titleTh`; name kept for backward
  /// compatibility — accepts any Widget (e.g. localized Text).
  final Widget titleTh;
  final String? titleEn;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double aspectRatio;
  final Color hoverColor;
  final bool? haveIcon;
  final String? semanticLabel;

  const HoverMenuCard({
    super.key,
    required this.titleTh,
    this.titleEn,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.aspectRatio = 1.4,
    this.hoverColor = AppColors.accent,
    this.haveIcon = true,
    this.semanticLabel,
  });

  @override
  State<HoverMenuCard> createState() => _HoverMenuCardState();
}

class _HoverMenuCardState extends State<HoverMenuCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel ?? widget.titleEn,
      button: true,
      enabled: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.xlRadius,
              border: Border.all(
                color: _isHovered ? widget.hoverColor : AppColors.border,
                width: _isHovered ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: _isHovered ? 0.18 : 0.08),
                  blurRadius: _isHovered ? 15 : 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onPressed();
                },
                borderRadius: AppRadius.xlRadius,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Column(
                    mainAxisAlignment: widget.haveIcon!
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      if (widget.haveIcon!)
                        Align(
                          alignment: Alignment.topRight,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: _isHovered
                                  ? widget.hoverColor.withValues(alpha: 0.2)
                                  : AppColors.surfaceMuted,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              widget.icon,
                              size: 32,
                              color: _isHovered
                                  ? widget.hoverColor
                                  : AppColors.textSecondary,
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),

                      Align(
                        alignment: widget.haveIcon!
                            ? Alignment.bottomLeft
                            : Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                fontFamily: AppText.family,
                                fontSize: _responsiveTitleSize(context),
                                fontWeight: FontWeight.bold,
                                color: _isHovered
                                    ? widget.hoverColor
                                    : AppColors.textPrimary,
                              ),
                              child: widget.titleTh,
                            ),
                            if (widget.titleEn != null &&
                                widget.titleEn!.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.xs),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  fontFamily: AppText.family,
                                  fontSize: 14,
                                  color: _isHovered
                                      ? widget.hoverColor
                                      : AppColors.textSecondary,
                                ),
                                child: Text(
                                  widget.titleEn!,
                                  textAlign: widget.haveIcon!
                                      ? TextAlign.left
                                      : TextAlign.center,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _responsiveTitleSize(BuildContext ctx) {
    final width = MediaQuery.of(ctx).size.width;
    if (width < 600) return 28;
    if (width < 1000) return 34;
    return 40;
  }
}
