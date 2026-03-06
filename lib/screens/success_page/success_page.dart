import 'package:flutter/material.dart';
import 'dart:async';

import 'package:untitled/l10n/app_localizations.dart';

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

    // Circle expansion animation
    _circleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Content fade-in animation
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Circle expands from center
    _circleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _circleController,
      curve: Curves.easeInOut,
    ));

    // Icon scales in after circle fills
    _iconScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.elasticOut,
    ));

    // Text fades in
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeIn,
    ));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    // Start circle expansion
    await _circleController.forward();

    // Wait a bit then start content fade-in
    await Future.delayed(const Duration(milliseconds: 100));
    await _contentController.forward();

    // Wait for display duration then navigate back or call onComplete
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
    final currentLocale = Localizations.localeOf(context);
    final isThai = currentLocale.languageCode == 'th';
    final isEnglish = currentLocale.languageCode == 'en';
    String title = AppLocalizations.of(context)!.successTitle;
    String subtitle = AppLocalizations.of(context)!.successSupTitle;
    final size = MediaQuery.of(context).size;
    // Use the larger dimension and multiply by 3 to ensure full coverage
    final maxDimension = size.width > size.height ? size.width : size.height;
    final maxRadius = maxDimension * 3;

    return Scaffold(
      body: Stack(
        children: [
          // White background
          Container(color: Colors.white),

          // Expanding green circle - allowed to overflow
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
                      color: Color(0xFF2E7D32), // Dark green
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),

          // Content (icon and text)
          AnimatedBuilder(
            animation: _contentController,
            builder: (context, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Checkmark icon with scale animation
                    Transform.scale(
                      scale: _iconScaleAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Title with fade animation
                    Opacity(
                      opacity: _textOpacityAnimation.value,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Subtitle with fade animation
                    Opacity(
                      opacity: _textOpacityAnimation.value,
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9),
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
    );
  }
}