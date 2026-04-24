import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

class RefcodeAndResend extends StatefulWidget {
  final String? refCode;
  final VoidCallback handleResendOTP;
  const RefcodeAndResend({
    super.key,
    this.refCode,
    required this.handleResendOTP,
  });

  @override
  State<RefcodeAndResend> createState() => _RefcodeAndResendState();
}

class _RefcodeAndResendState extends State<RefcodeAndResend> {
  static const int _cooldownSeconds = 60;
  int _secondsLeft = _cooldownSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  void _startCooldown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _cooldownSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _onResendPressed() {
    HapticFeedback.lightImpact();
    widget.handleResendOTP();
    _startCooldown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bool canResend = _secondsLeft == 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.referCode,
              style: AppText.caption,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              widget.refCode ?? 'XXXXXX',
              style: const TextStyle(
                fontFamily: AppText.family,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.huge),
        Semantics(
          label: canResend
              ? '${l.resend}. Tap to resend the OTP code.'
              : 'Resend available in $_secondsLeft seconds.',
          button: true,
          enabled: canResend,
          child: TextButton.icon(
            onPressed: canResend ? _onResendPressed : null,
            icon: Icon(
              Icons.refresh,
              color: canResend ? AppColors.accent : AppColors.textDisabled,
              size: 20,
            ),
            label: Text(
              canResend
                  ? l.resend
                  : '${l.resend} (${_secondsLeft}s)',
              style: TextStyle(
                fontFamily: AppText.family,
                color: canResend ? AppColors.accent : AppColors.textDisabled,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              minimumSize: const Size(AppTouch.minTarget, AppTouch.minTarget),
            ),
          ),
        ),
      ],
    );
  }
}
