import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/screens/input_type_page/email_input_page/email_component/email_body.dart';
import 'package:untitled/screens/input_type_page/input_type_page/input_type_page.dart';
import 'package:untitled/services/api_service.dart';
import 'package:untitled/theme/theme.dart';
import 'package:untitled/widgets/header/header.dart';
import 'package:untitled/widgets/snackbar/snackbar.dart';

import '../../../main.dart';
import '../../otp_page/otp_page.dart';

class EmailInputPage extends StatefulWidget {
  final String? selectedLocker;
  final String? lockerName;
  final FromPage from;
  final List<Map<String, dynamic>> lockerData;

  const EmailInputPage({
    super.key,
    this.selectedLocker,
    this.lockerName,
    required this.from,
    this.lockerData = const [],
  });

  @override
  State<EmailInputPage> createState() => _EmailInputPageState();
}

class _EmailInputPageState extends State<EmailInputPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    if (!_isValidEmail) return;

    setState(() => _isLoading = true);
    String cleanValue = _emailController.text.trim();
    try {
      if (widget.from == FromPage.forgetPassword) {
        final result = await _apiService.handleForgotPassword(
          cleanValue,
          true,
          widget.selectedLocker,
        );
        if (!mounted) return;
        setState(() => _isLoading = false);
        if (result['success']) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPPage(
                from: FromPage.unlock,
                lockerName: widget.lockerName,
                lockerId: widget.selectedLocker,
                telOrEmail: cleanValue,
                lockerData: widget.lockerData,
              ),
            ),
          );
        } else {
          context.showErrorSnackBar(AppLocalizations.of(context)!.wrongEmail);
          _emailController.clear();
          setState(() {});
        }
      } else if (widget.from == FromPage.resetPassword) {
        setState(() => _isLoading = false);
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPPage(
              from: FromPage.resetPassword,
              lockerId: widget.selectedLocker,
              lockerName: widget.lockerName,
              telOrEmail: cleanValue,
              lockerData: widget.lockerData,
            ),
          ),
        );
      } else {
        if (widget.selectedLocker == null) {
          setState(() => _isLoading = false);
          if (mounted) {
            context.showErrorSnackBar(
                AppLocalizations.of(context)!.noLocker);
          }
          return;
        }
        final result = await _apiService.sendOTP(
          cleanValue,
          true,
          widget.selectedLocker!,
          widget.from == FromPage.visitor,
        );
        if (!mounted) return;
        setState(() => _isLoading = false);
        if (result['success']) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPPage(
                telOrEmail: cleanValue,
                from: widget.from,
                lockerId: widget.selectedLocker,
                lockerName: widget.lockerName,
                userId: result['data']['userId'],
                refCode: result['data']['refercode'],
                lockerData: widget.lockerData,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          context.showErrorSnackBar(
              '${AppLocalizations.of(context)!.errorOccur}: ${result['error']}');
          _emailController.clear();
          setState(() {});
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      context.showErrorSnackBar(
          '${AppLocalizations.of(context)!.errorOccur}: $e');
    }
  }

  bool get _isValidEmail {
    final email = _emailController.text.trim();
    if (email.isEmpty) return false;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final appState = MyApp.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.lg,
                  ),
                  child: Header(
                    currentLocale: currentLocale,
                    onLanguageSwitch: () {
                      appState?.toggleLocale();
                    },
                  ),
                ),
                EmailBody(
                  isLoading: _isLoading,
                  isValidEmail: _isValidEmail,
                  focusNode: _focusNode,
                  emailController: _emailController,
                  onConfirm: _onConfirm,
                  onChanged: () {
                    setState(() {});
                  },
                ),
              ],
            ),
            if (_isLoading)
              Container(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
