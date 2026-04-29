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
  /// When set, the card uses this as its background colour (with white text).
  /// When null, the card uses the default white surface.
  final Color? cardColor;
  /// When false the card is visually dimmed and non-interactive.
  final bool enabled;

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
    this.cardColor,
    this.enabled = true,
  });

  @override
  State<HoverMenuCard> createState() => _HoverMenuCardState();
}

class _HoverMenuCardState extends State<HoverMenuCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool disabled = !widget.enabled;
    final bool colored = widget.cardColor != null && !disabled;

    final Color bgColor = disabled
        ? Colors.grey.shade200
        : (colored ? widget.cardColor! : AppColors.surface);
    final Color textColor = disabled
        ? Colors.grey.shade400
        : (colored
            ? Colors.white
            : (_isHovered ? widget.hoverColor : AppColors.textPrimary));
    final Color borderColor = disabled
        ? Colors.grey.shade300
        : (colored
            ? (_isHovered
                ? Colors.white.withValues(alpha: 0.6)
                : Colors.transparent)
            : (_isHovered ? widget.hoverColor : AppColors.border));
    final Color shadowColor = disabled
        ? Colors.transparent
        : (colored
            ? widget.cardColor!.withValues(alpha: _isHovered ? 0.45 : 0.25)
            : AppColors.shadow.withValues(alpha: _isHovered ? 0.18 : 0.08));

    return Semantics(
      label: widget.semanticLabel ?? widget.titleEn,
      button: true,
      enabled: widget.enabled,
      child: MouseRegion(
        cursor: disabled
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        onEnter: disabled ? null : (_) => setState(() => _isHovered = true),
        onExit: disabled ? null : (_) => setState(() => _isHovered = false),
        child: AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: AppRadius.xlRadius,
              border: Border.all(color: borderColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: _isHovered ? 15 : 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: disabled
                    ? null
                    : () {
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
                      // ── icon ───────────────────────────────────────────
                      if (widget.haveIcon!)
                        Align(
                          alignment: Alignment.topRight,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: disabled
                                  ? Colors.grey.shade300
                                  : (colored
                                      ? Colors.white.withValues(alpha: 0.2)
                                      : (_isHovered
                                          ? widget.hoverColor
                                              .withValues(alpha: 0.2)
                                          : AppColors.surfaceMuted)),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              widget.icon,
                              size: 32,
                              color: disabled
                                  ? Colors.grey.shade400
                                  : (colored
                                      ? Colors.white
                                      : (_isHovered
                                          ? widget.hoverColor
                                          : AppColors.textSecondary)),
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),

                      // ── text ───────────────────────────────────────────
                      // haveIcon=true  → plain Align so it sits at the bottom-left
                      // haveIcon=false → Expanded+Center so FittedBox has a
                      //                  real bounded height to scale into
                      if (widget.haveIcon!)
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.bottomLeft,
                            child: _textColumn(textColor, colored),
                          ),
                        )
                      else
                        Expanded(
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: _textColumn(textColor, colored),
                            ),
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

  Widget _textColumn(Color textColor, bool colored) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: widget.haveIcon!
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontFamily: AppText.family,
            fontSize: _responsiveTitleSize(context),
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          child: widget.titleTh,
        ),
        if (widget.titleEn != null && widget.titleEn!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 14,
              color: colored
                  ? Colors.white.withValues(alpha: 0.85)
                  : (_isHovered
                      ? widget.hoverColor
                      : AppColors.textSecondary),
            ),
            child: Text(
              widget.titleEn!,
              textAlign:
                  widget.haveIcon! ? TextAlign.left : TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }

  double _responsiveTitleSize(BuildContext ctx) {
    final width = MediaQuery.of(ctx).size.width;
    if (width < 600) return 28;
    if (width < 1000) return 34;
    return 40;
  }
}
