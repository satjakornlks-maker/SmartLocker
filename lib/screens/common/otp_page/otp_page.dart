import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/screens/common/otp_page/otp_page_component/keypad_row.dart';
import 'package:untitled/screens/common/otp_page/otp_page_component/otp_confirm_button.dart';
import 'package:untitled/screens/common/otp_page/otp_page_component/otp_input_box.dart';
import 'package:untitled/screens/common/otp_page/otp_page_component/otp_title.dart';
import 'package:untitled/screens/common/otp_page/otp_page_component/phone_display.dart';
import 'package:untitled/screens/common/otp_page/otp_page_component/refcode_and_resend.dart';
import 'package:untitled/screens/common/success_page/success_page.dart';
import 'package:untitled/screens/input_type_page/input_type_page/input_type_page.dart';
import 'package:untitled/widgets/header/header.dart';
import 'package:untitled/widgets/snackbar/snackbar.dart';
import '../../../services/api_service.dart';
import 'package:untitled/main.dart';

class OTPPage extends StatefulWidget {
  final FromPage from;
  final String? lockerId;
  final String? lockerName;
  final String? telOrEmail;
  final String? refCode; // Passed from previous page
  final int? userId; // Passed from previous page

  const OTPPage({
    super.key,
    required this.from,
    this.lockerId,
    this.lockerName,
    this.telOrEmail,
    this.refCode,
    this.userId,
  });

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final ApiService _apiService = ApiService();
  late int resetPass;
  bool _isLoading = false;
  // OTP input controllers - 6 digits
  final List<String> _otpDigits = List.filled(6, '');
  int _currentIndex = 0;

  // State variables
  String? refCode;
  int? userId;

  @override
  void initState() {
    super.initState();
    resetPass = 3;
    // Initialize from passed parameters (OTP already sent by previous page)
    refCode = widget.refCode;
    userId = widget.userId;
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final appState = MyApp.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                Header(currentLocale: currentLocale, onLanguageSwitch: () {
                  appState?.toggleLocale();
                },onBackPressed: _handleBackPressed,),
                Expanded(child: _buildBody()),
              ],
            ),
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.deepPurple,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            OtpTitle(resetPass: resetPass),
            const SizedBox(height: 10),
            if (widget.from != FromPage.unlock)
              PhoneDisplay(
                telOrEmail: widget.telOrEmail,
                lockerName: widget.lockerName,
              ),

            const SizedBox(height: 25),
            OtpInputBox(otpDigits: _otpDigits),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: .center,
              children: [
                resetPass == 1
                    ? const SizedBox.shrink()
                    : widget.from != FromPage.unlock
                    ? RefcodeAndResend(refCode: refCode, handleResendOTP: _handleResendOTP)
                    : _buildForgotPassword(),
                SizedBox(width: 10),
                if (widget.from == FromPage.unlock && resetPass == 3)
                  _buildResetPassword(),
              ],
            ),
            const SizedBox(height: 50),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350),
              child: Column(
                children: [
                  _buildNumericKeypad(),
                  const SizedBox(height: 30),
                  OtpConfirmButton(otpDigits: _otpDigits, handleSubmitOTP: _handleSubmitOTP),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumericKeypad() {
    return Column(
      children: [
        KeypadRow( keys: ['1', '2', '3'], handleDelete: _handleDelete, handleNumberTap: _handleNumberTap,),
        const SizedBox(height: 15),
        KeypadRow(keys :  ['4', '5', '6'], handleDelete: _handleDelete, handleNumberTap: _handleNumberTap,),
        const SizedBox(height: 15),
        KeypadRow(keys :['7', '8', '9'], handleDelete: _handleDelete, handleNumberTap: _handleNumberTap,),
        const SizedBox(height: 15),
        KeypadRow(keys :['0', 'delete'], handleDelete: _handleDelete, handleNumberTap: _handleNumberTap,),
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
    setState(() => _isLoading = true);
    String cleanValue = widget.telOrEmail!.replaceAll(' ', '');
    try {
      final result = await _apiService.sendOTP(
        cleanValue,
        cleanValue.contains('@'),
        widget.lockerId!,
        widget.from == FromPage.visitor ? true : false,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        context.showSuccessSnackBar(AppLocalizations.of(context)!.optSuccess);
        setState(() {
          refCode = result['data']['refercode'] ?? '';
          userId = result['data']['userId'] ?? '';
        });
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        context.showErrorSnackBar('${AppLocalizations.of(context)!.errorOccur}: ${result['error']}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      context.showErrorSnackBar('${AppLocalizations.of(context)!.errorOccur}: $e');
    }
  }

  Future<void> _handleResendOTP() async {
    // Clear current OTP input
    setState(() {
      _otpDigits.fillRange(0, 6, '');
      _currentIndex = 0;
    });

    await _handleSendOTP();
  }

  Future<void> _handleSubmitOTP() async {
    String otpCode = _otpDigits.join('');
    if (otpCode.length != 6) {
      context.showWarningSnackBar(AppLocalizations.of(context)!.otpWarning,);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.from == FromPage.unlock) {
        await _unlockLocker(otpCode);
      } else if (widget.from == FromPage.resetPassword) {
        try {
          final result = await _apiService.handleCheckOTP(
            widget.lockerId!,
            otpCode,
          );
          setState(() {
            _isLoading = false;
          });
          if (result['success']) {
            resetPass = 2;
            userId = result['data']['userID'];
            _otpDigits.clear();
          } else {
            if(!mounted) {
              return;
            }
            context.showErrorSnackBar(AppLocalizations.of(context)!.wrongOtp);
          }
        } catch (e) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).clearSnackBars();
          context.showErrorSnackBar('${AppLocalizations.of(context)!.errorOccur}: $e', );
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPPage(from: FromPage.unlock),
              ),
            );
          } else {
            // print(result['error']);
          }
        } catch (e) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).clearSnackBars();
          context.showErrorSnackBar('${AppLocalizations.of(context)!.errorOccur}: $e');
        }
      } else {
        String cleanValue = widget.telOrEmail!.replaceAll(' ', '');
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
          context.showErrorSnackBar('${AppLocalizations.of(context)!.errorOccur}: ${result['error']}');
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      context.showErrorSnackBar('${AppLocalizations.of(context)!.errorOccur}: $e');
    }
  }

  Future<void> _bookLocker(int userId, String otp) async {
    DateTime now = DateTime.now();
    String cleanValue = widget.telOrEmail!.replaceAll(' ', '');
    try {
      final result = await _apiService.bookLocker(
        cleanValue.contains('@'),
        cleanValue,
        widget.lockerId!,
        otp,
        now,
        userId,
        widget.from != FromPage.visitor ? false : true,
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
      context.showErrorSnackBar('${AppLocalizations.of(context)!.errorOccur}:$e');
    }
  }

  Future<void> _unlockLocker(String otp) async {
    try {
      final result = await _apiService.handleFillPIN(otp, widget.lockerId!);
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuccessPage()),
        );
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        context.showErrorSnackBar('${AppLocalizations.of(context)!.errorOccur}: ${result['error']}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      context.showErrorSnackBar('${AppLocalizations.of(context)!.errorOccur}: $e');
    }
  }

  Widget _buildResetPassword() {
    return TextButton(
      onPressed: () {
        setState(() {
          resetPass = 1;
        });
        _otpDigits.clear();
      },
      child: Text(
        AppLocalizations.of(context)!.resetPassOption,
        style: TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return TextButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InputTypePage(
            from: FromPage.forgetPassword,
            selectedLocker: widget.lockerId,
            lockerName: widget.lockerName,
          ),
        ),
      ),
      child: Text(
        AppLocalizations.of(context)!.forgotPass,
        style: TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }

  void _handleBackPressed() {
    if (resetPass != 3) {
      // Reset to initial state
      setState(() {
        resetPass = 3;
        _otpDigits.fillRange(0, 6, ''); // Clear OTP
        _currentIndex = 0;
      });
    } else {
      // Normal back navigation
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
