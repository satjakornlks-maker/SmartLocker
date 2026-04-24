import 'package:flutter/material.dart';
import 'dart:async';

import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

class SuccessPage extends StatefulWidget {
  final VoidCallback? onComplete;
  final Duration displayDuration;

  const SuccessPage({
    super.key,
    this.onComplete,
    this.displayDuration = const Duration(seconds: 3),
  });

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage>
    with TickerProviderStateMixin {
  late AnimationController _circleController;
  late AnimationController _contentController;
  late Animation<double> _circleAnimation;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();

    _circleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _circleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _circleController,
      curve: Curves.easeInOut,
    ));

    _iconScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.elasticOut,
    ));

    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeIn,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await _circleController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    await _contentController.forward();
    await Future.delayed(widget.displayDuration);

    if (!mounted) return;

    if (widget.onComplete != null) {
      widget.onComplete!();
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  void dispose() {
    _circleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final title = l.successTitle;
    final subtitle = l.successSupTitle;
    final size = MediaQuery.of(context).size;
    final maxDimension = size.width > size.height ? size.width : size.height;
    final maxRadius = maxDimension * 3;

    return Scaffold(
      body: Semantics(
        liveRegion: true,
        label: '$title. $subtitle',
        child: Stack(
          children: [
            Container(color: AppColors.surface),
            Center(
              child: AnimatedBuilder(
                animation: _circleAnimation,
                builder: (context, child) {
                  return OverflowBox(
                    maxWidth: double.infinity,
                    maxHeight: double.infinity,
                    child: Container(
                      width: maxRadius * 2 * _circleAnimation.value,
                      height: maxRadius * 2 * _circleAnimation.value,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ),
            AnimatedBuilder(
              animation: _contentController,
              builder: (context, child) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: _iconScaleAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: AppColors.textOnPrimary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: AppColors.textOnPrimary,
                            size: 80,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Opacity(
                        opacity: _textOpacityAnimation.value,
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textOnPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Opacity(
                        opacity: _textOpacityAnimation.value,
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 18,
                            // ignore: deprecated_member_use
                            color: AppColors.textOnPrimary.withOpacity(0.92),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
