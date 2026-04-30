import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/services/device_config_service.dart';
import 'package:untitled/screens/confirmation_page/confirmation_page.dart';
import 'package:untitled/screens/input_type_page/input_type_page/input_type_page.dart';
import 'package:untitled/screens/input_type_page/phone_input_page/phone_input_page.dart';
import 'package:untitled/theme/theme.dart';
import 'package:untitled/widgets/header/header.dart';
import 'package:untitled/widgets/snackbar/snackbar.dart';
import '../../../services/api_service.dart';
import 'package:untitled/main.dart';
import 'otp_page_component/phone_display.dart';
import '../success_page/success_page.dart';
import 'otp_page_component/keypad_row.dart';
import 'otp_page_component/locker_mini_map.dart';
import 'otp_page_component/otp_confirm_button.dart';
import 'otp_page_component/otp_input_box.dart';
import 'otp_page_component/otp_title.dart';
import 'otp_page_component/refcode_and_resend.dart';

class OTPPage extends StatefulWidget {
  final FromPage from;
  final String? lockerId;
  final String? lockerName;
  final String? telOrEmail;
  final String? refCode;
  final int? userId;
  final List<Map<String, dynamic>> lockerData;

  const OTPPage({
    super.key,
    required this.from,
    this.lockerId,
    this.lockerName,
    this.telOrEmail,
    this.refCode,
    this.userId,
    this.lockerData = const [],
  });

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final ApiService _apiService = ApiService.instance;

  late int resetPass;
  bool _isLoading = false;

  final List<String> _otpDigits = List.filled(6, '', growable: true);
  int _currentIndex = 0;

  String? refCode;
  int? userId;

  String get systemMode => DeviceConfigService.systemMode;

  @override
  void initState() {
    super.initState();
    resetPass = 3;
    refCode = widget.refCode;
    userId = widget.userId;
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final appState = MyApp.of(context);
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [
                    Color(0xFF08111F),
                    Color(0xFF0D1B2A),
                    Color(0xFF132238),
                  ]
                : const [
                    Color(0xFFF7FAFF),
                    Color(0xFFEFF4FB),
                    Color(0xFFE4EDF8),
                  ],
          ),
        ),
        child: Stack(
          children: [
            _BackgroundGlow(
              top: -120,
              left: -80,
              size: 260,
              color: isDark
                  ? Colors.cyanAccent.withOpacity(0.08)
                  : Colors.blue.withOpacity(0.16),
            ),
            _BackgroundGlow(
              top: 100,
              right: -90,
              size: 220,
              color: isDark
                  ? Colors.blueAccent.withOpacity(0.08)
                  : Colors.indigo.withOpacity(0.12),
            ),
            _BackgroundGlow(
              bottom: -120,
              left: 30,
              size: 280,
              color: isDark
                  ? Colors.tealAccent.withOpacity(0.06)
                  : Colors.cyan.withOpacity(0.10),
            ),
            SafeArea(
              child: Builder(builder: (context) {
              final compact = MediaQuery.of(context).size.height <= 800;
              return Padding(
                padding: EdgeInsets.all(compact ? 6 : 14),
                child: _GlassShell(
                  isDark: isDark,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              20,
                              compact ? 6 : 14,
                              20,
                              compact ? 4 : 8,
                            ),
                            child: Header(
                              currentLocale: currentLocale,
                              onLanguageSwitch: () {
                                appState?.toggleLocale();
                              },
                              onBackPressed: _handleBackPressed,
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.fromLTRB(20, 6, 20, compact ? 8 : 20),
                              child: _buildBody(isDark),
                            ),
                          ),
                        ],
                      ),
                      if (_isLoading)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.45),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(bool isDark) {
    final hasLockerData = widget.lockerData.isNotEmpty;
    final isNarrow = MediaQuery.of(context).size.width < 980;

    if (hasLockerData && !isNarrow) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: isDark
                        ? Colors.white.withOpacity(0.04)
                        : Colors.white.withOpacity(0.35),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.black.withOpacity(0.05),
                    ),
                  ),
                  child: LockerMiniMap(
                    lockerData: widget.lockerData,
                    selectedLockerId: widget.lockerId,
                    selectedLockerName: widget.lockerName,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(flex: 6, child: _buildOtpContent(isDark)),
            ],
          ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: Column(
        children: [
          if (hasLockerData) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: isDark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.white.withOpacity(0.35),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.black.withOpacity(0.05),
                ),
              ),
              child: LockerMiniMap(
                lockerData: widget.lockerData,
                selectedLockerId: widget.lockerId,
                selectedLockerName: widget.lockerName,
              ),
            ),
            const SizedBox(height: 16),
          ],
          _buildOtpContent(isDark),
        ],
      ),
    );
  }

  Widget _buildOtpContent(bool isDark) {
    final compact = MediaQuery.of(context).size.height <= 800;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 18,
        vertical: compact ? 10 : 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark
            ? Colors.white.withOpacity(0.04)
            : Colors.white.withOpacity(0.35),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: compact ? 2 : 4),
          OtpTitle(resetPass: resetPass, from: widget.from),
          SizedBox(height: compact ? 4 : 8),
          if (widget.from != FromPage.unlock)
            PhoneDisplay(
              telOrEmail: widget.telOrEmail,
              lockerName: widget.lockerName,
            ),
          SizedBox(height: compact ? 6 : 14),
          OtpInputBox(otpDigits: _otpDigits),
          SizedBox(height: compact ? 4 : 12),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              if (resetPass == 3)
                widget.from != FromPage.unlock
                    ? RefcodeAndResend(
                        refCode: refCode,
                        handleResendOTP: _handleResendOTP,
                      )
                    : _buildForgotPassword(),
              if (widget.from == FromPage.unlock &&
                  resetPass == 3 &&
                  systemMode != "B2C")
                _buildResetPassword(),
            ],
          ),
          SizedBox(height: compact ? 8 : 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              children: [
                _buildNumericKeypad(),
                SizedBox(height: compact ? 8 : 20),
                OtpConfirmButton(
                  otpDigits: _otpDigits,
                  handleSubmitOTP: _handleSubmitOTP,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumericKeypad() {
    final compact = MediaQuery.of(context).size.height <= 800;
    final rowGap = compact ? 6.0 : 12.0;
    return Column(
      children: [
        KeypadRow(
          keys: ['1', '2', '3'],
          handleDelete: _handleDelete,
          handleNumberTap: _handleNumberTap,
        ),
        SizedBox(height: rowGap),
        KeypadRow(
          keys: ['4', '5', '6'],
          handleDelete: _handleDelete,
          handleNumberTap: _handleNumberTap,
        ),
        SizedBox(height: rowGap),
        KeypadRow(
          keys: ['7', '8', '9'],
          handleDelete: _handleDelete,
          handleNumberTap: _handleNumberTap,
        ),
        SizedBox(height: rowGap),
        KeypadRow(
          keys: ['0', 'delete'],
          handleDelete: _handleDelete,
          handleNumberTap: _handleNumberTap,
        ),
      ],
    );
  }

  void _handleNumberTap(String number) {
    if (_currentIndex < 6) {
      setState(() {
        _otpDigits[_currentIndex] = number;
        _currentIndex++;
      });
    }
  }

  void _handleDelete() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _otpDigits[_currentIndex] = '';
      });
    }
  }

  Future<void> _handleSendOTP() async {
    if (widget.lockerId == null) {
      context.showErrorSnackBar(AppLocalizations.of(context)!.noLocker);
      return;
    }
    if (widget.telOrEmail == null) {
      context.showErrorSnackBar(AppLocalizations.of(context)!.errorOccur);
      return;
    }
    setState(() => _isLoading = true);
    final cleanValue = widget.telOrEmail!.replaceAll(' ', '');
    try {
      final result = await _apiService.sendOTP(
        cleanValue,
        cleanValue.contains('@'),
        widget.lockerId!,
        widget.from == FromPage.visitor,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        context.showSuccessSnackBar(AppLocalizations.of(context)!.otpSuccess);
        setState(() {
          refCode = result['data']['refercode'] ?? '';
          userId = result['data']['userId'];
        });
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        context.showErrorSnackBar(
          '${AppLocalizations.of(context)!.errorOccur}: ${result['error']}',
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      context.showErrorSnackBar(
        '${AppLocalizations.of(context)!.errorOccur}: $e',
      );
    }
  }

  Future<void> _handleResendOTP() async {
    setState(() {
      _otpDigits.fillRange(0, 6, '');
      _currentIndex = 0;
    });
    await _handleSendOTP();
  }

  Future<void> _handleSubmitOTP() async {
    final otpCode = _otpDigits.join('');
    if (otpCode.length != 6) {
      context.showWarningSnackBar(AppLocalizations.of(context)!.otpWarning);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.from == FromPage.unlock && resetPass == 3) {
        final result = await _apiService.handleCheckOTP(
          widget.lockerId!,
          otpCode,
        );
        if (result['success']) {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ConfirmationPage(lockerId: widget.lockerId!, otp: otpCode),
            ),
          );
        } else {
          if (!mounted) return;
          context.showErrorSnackBar(AppLocalizations.of(context)!.wrongOtp);
        }
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      } else if (resetPass == 1) {
        try {
          final result = await _apiService.handleCheckOTP(
            widget.lockerId!,
            otpCode,
          );
          if (!mounted) return;
          setState(() {
            _isLoading = false;
          });
          final extractedUserId = result['data']?['userID'] as int?;
          if (result['success'] && extractedUserId != null) {
            setState(() {
              resetPass = 2;
              userId = extractedUserId;
              _otpDigits.fillRange(0, 6, '');
              _currentIndex = 0;
            });
          } else {
            if (!mounted) return;
            context.showErrorSnackBar(AppLocalizations.of(context)!.wrongOtp);
          }
        } catch (e) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).clearSnackBars();
          context.showErrorSnackBar(
            '${AppLocalizations.of(context)!.errorOccur}: $e',
          );
        }
      } else if (resetPass == 2) {
        try {
          final result = await _apiService.handleResetPassword(
            userId!,
            otpCode,
          );
          setState(() {
            _isLoading = false;
          });
          if (!mounted) return;
          if (result['success']) {
            setState(() {
              resetPass = 3;
              _otpDigits.fillRange(0, 6, '');
              _currentIndex = 0;
            });
          } else {
            setState(() {
              _otpDigits.fillRange(0, 6, '');
              _currentIndex = 0;
            });
            context.showErrorSnackBar(AppLocalizations.of(context)!.wrongOtp);
          }
        } catch (e) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).clearSnackBars();
          context.showErrorSnackBar(
            '${AppLocalizations.of(context)!.errorOccur}: $e',
          );
        }
      } else {
        if (widget.telOrEmail == null) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          context.showErrorSnackBar(AppLocalizations.of(context)!.errorOccur);
          return;
        }
        final cleanValue = widget.telOrEmail!.replaceAll(' ', '');
        final result = await _apiService.handleSubmitOTP(
          cleanValue,
          otpCode,
          cleanValue.contains('@'),
        );

        if (!mounted) return;

        if (result['success']) {
          await _bookLocker(userId!, otpCode);
        } else {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).clearSnackBars();
          context.showErrorSnackBar(
            '${AppLocalizations.of(context)!.errorOccur}: ${result['error']}',
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      context.showErrorSnackBar(
        '${AppLocalizations.of(context)!.errorOccur}: $e',
      );
    }
  }

  Future<void> _bookLocker(int userId, String otp) async {
    if (widget.telOrEmail == null) {
      if (!mounted) return;
      context.showErrorSnackBar(AppLocalizations.of(context)!.errorOccur);
      return;
    }
    final now = DateTime.now();
    final cleanValue = widget.telOrEmail!.replaceAll(' ', '');
    try {
      final result = await _apiService.bookLocker(
        cleanValue.contains('@'),
        cleanValue,
        widget.lockerId!,
        otp,
        now,
        userId,
        widget.from == FromPage.visitor,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuccessPage()),
        );
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        context.showErrorSnackBar(AppLocalizations.of(context)!.errorOccur);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      context.showErrorSnackBar(
        '${AppLocalizations.of(context)!.errorOccur}:$e',
      );
    }
  }

  Future<void> _unlockLocker(String otp) async {
    try {
      final result = await _apiService.handleFillPIN(
        pin: otp,
        lockerId: widget.lockerId!,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuccessPage()),
        );
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        context.showErrorSnackBar(
          '${AppLocalizations.of(context)!.errorOccur}: ${result['error']}',
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      context.showErrorSnackBar(
        '${AppLocalizations.of(context)!.errorOccur}: $e',
      );
    }
  }

  Widget _buildResetPassword() {
    return TextButton(
      onPressed: () {
        setState(() {
          resetPass = 1;
        });
        _otpDigits.fillRange(0, 6, '');
        _currentIndex = 0;
      },
      child: Text(
        AppLocalizations.of(context)!.resetPassOption,
        style: const TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return TextButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhoneInputPage(
            from: FromPage.forgetPassword,
            selectedLocker: widget.lockerId,
            lockerName: widget.lockerName,
            lockerData: widget.lockerData,
          ),
        ),
      ),
      child: Text(
        AppLocalizations.of(context)!.forgotPass,
        style: const TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }

  void _handleBackPressed() {
    if (resetPass != 3) {
      setState(() {
        resetPass = 3;
        _otpDigits.fillRange(0, 6, '');
        _currentIndex = 0;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _GlassShell extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const _GlassShell({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.white.withOpacity(0.30),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.10)
                  : Colors.white.withOpacity(0.55),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.28)
                    : Colors.black.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  final double size;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final Color color;

  const _BackgroundGlow({
    required this.size,
    required this.color,
    this.top,
    this.left,
    this.right,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      ),
    );
  }
}
