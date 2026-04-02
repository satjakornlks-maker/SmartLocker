import 'dart:async';
import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';

class RefcodeAndResend extends StatefulWidget {
  final String? refCode;
  final VoidCallback handleResendOTP;
  const RefcodeAndResend({super.key, this.refCode, required this.handleResendOTP});

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
    final bool canResend = _secondsLeft == 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.referCode,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.refCode ?? 'XXXXXX',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(width: 80),
        TextButton.icon(
          onPressed: canResend ? _onResendPressed : null,
          icon: Icon(
            Icons.refresh,
            color: canResend ? Colors.orange : Colors.grey,
            size: 20,
          ),
          label: Text(
            canResend
                ? AppLocalizations.of(context)!.resend
                : '${AppLocalizations.of(context)!.resend} ($_secondsLeft s)',
            style: TextStyle(
              color: canResend ? Colors.orange : Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}
