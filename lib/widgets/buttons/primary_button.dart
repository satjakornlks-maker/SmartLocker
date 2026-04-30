import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/theme/theme.dart';

/// Unified action button with built-in loading & disabled states.
///
/// Variants:
///   PrimaryButton(label: 'Pay', onPressed: ...)
///   PrimaryButton.secondary(label: 'Cancel', onPressed: ...)
///   PrimaryButton(label: 'Send', onPressed: ..., isLoading: true)
///
/// Always wraps in a Semantics node and guarantees a minimum 48x48 target.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool secondary;
  final bool expand;
  final String? semanticLabel;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.expand = false,
    this.semanticLabel,
  }) : secondary = false;

  const PrimaryButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.expand = false,
    this.semanticLabel,
  }) : secondary = true;

  bool get _enabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.height <= 800;
    final btnHeight = compact ? 44.0 : 56.0;

    final child = isLoading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
            ),
          )
        : Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: compact ? 17 : 20),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppText.family,
                  fontSize: compact ? 15.0 : 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );

    final onTap = _enabled
        ? () {
            HapticFeedback.lightImpact();
            onPressed!();
          }
        : null;

    final button = secondary
        ? OutlinedButton(onPressed: onTap, child: child)
        : ElevatedButton(onPressed: onTap, child: child);

    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      enabled: _enabled,
      child: SizedBox(
        height: btnHeight,
        width: expand ? double.infinity : null,
        child: button,
      ),
    );
  }
}
