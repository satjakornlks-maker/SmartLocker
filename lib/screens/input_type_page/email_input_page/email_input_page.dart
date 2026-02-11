import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/screens/common/otp_page/otp_page.dart';
import 'package:untitled/screens/input_type_page/email_input_page/email_component/email_body.dart';
import 'package:untitled/screens/input_type_page/input_type_page/input_type_page.dart';
import 'package:untitled/services/api_service.dart';
import 'package:untitled/widgets/header/header.dart';
import 'package:untitled/widgets/snackbar/snackbar.dart';

import '../../../main.dart';

class EmailInputPage extends StatefulWidget {
  final String? selectedLocker;
  final String? lockerName;
  final FromPage from;

  const EmailInputPage({
    super.key,
    this.selectedLocker,
    this.lockerName,
    required this.from,
  });

  @override
  State<EmailInputPage> createState() => _EmailInputPageState();
}

class _EmailInputPageState extends State<EmailInputPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isLoading = false; // Add loading state

  @override
  void dispose() {
    _emailController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    if (_isValidEmail) {
      setState(() => _isLoading = true);
      String cleanValue = _emailController.text.trim();
      try {
        // Check forgetPassword FIRST
        if (widget.from == FromPage.forgetPassword) {
          // print('forgetPassword');
          final result = await _apiService.handleForgotPassword(
            cleanValue,
            true, // isEmail = true
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
                ),
              ),
            );
          } else {
            // print(result);
            context.showErrorSnackBar(AppLocalizations.of(context)!.wrongEmail);
          }
        }
        // Then check resetPassword
        else if (widget.from == FromPage.resetPassword) {
          // print('resetPassword');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPPage(
                from: FromPage.resetPassword,
                lockerId: widget.selectedLocker,
                lockerName: widget.lockerName,
                telOrEmail: cleanValue,
              ),
            ),
          );
        }
        // Default case: instance, normal, visitor, unlock
        else {
          final result = await _apiService.sendOTP(
            cleanValue,
            true, // isEmail = true
            widget.selectedLocker!,
            widget.from == FromPage.visitor ? true : false,
          );
          if (!mounted) return;
          setState(() => _isLoading = false);
          if (result['success']) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPPage(
                  telOrEmail: _emailController.text,
                  from: widget.from,
                  lockerId: widget.selectedLocker,
                  lockerName: widget.lockerName,
                  userId: result['data']['userId'],
                  refCode: result['data']['refercode'],
                ),
              ),
            );
          } else {
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
  }

  bool get _isValidEmail {
    final email = _emailController.text.trim();
    if (email.isEmpty) return false;

    // Basic email validation
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
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                Header(
                  currentLocale: currentLocale,
                  onLanguageSwitch: () {
                    appState?.toggleLocale();
                  },
                ),
                EmailBody(
                  isLoading: _isLoading,
                  isValidEmail: _isValidEmail,
                  focusNode: _focusNode,
                  emailController: _emailController,
                  onConfirm: _onConfirm,
                  onChanged: (){setState(() {

                  });},
                ),
              ],
            ),

            // Loading overlay
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
