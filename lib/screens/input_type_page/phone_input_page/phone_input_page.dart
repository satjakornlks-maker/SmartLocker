import 'package:flutter/material.dart';
import 'package:untitled/screens/input_type_page/input_type_page/input_type_page.dart';
import 'package:untitled/screens/input_type_page/phone_input_page/phone_input_component/phone_confirm_button.dart';
import 'package:untitled/screens/input_type_page/phone_input_page/phone_input_component/phone_display.dart';
import 'package:untitled/screens/input_type_page/phone_input_page/phone_input_component/phone_numpad.dart';
import 'package:untitled/services/api_service.dart';
import 'package:untitled/widgets/header/header.dart';
import 'package:untitled/widgets/snackbar/snackbar.dart';
import '../../../l10n/app_localizations.dart';
import '../../../main.dart';
import '../../otp_page/otp_page.dart';

class PhoneInputPage extends StatefulWidget {
  final String? selectedLocker;
  final String? lockerName;
  final FromPage from;
  final List<Map<String, dynamic>> lockerData;

  const PhoneInputPage({
    super.key,
    this.selectedLocker,
    this.lockerName,
    required this.from,
    this.lockerData = const [],
  });

  @override
  State<PhoneInputPage> createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends State<PhoneInputPage> {
  final ApiService _apiService = ApiService();
  String phoneNumber = '';
  final int maxLength = 10;
  bool _isLoading = false; // Add loading state

  void _onNumberPress(String number) {
    if (phoneNumber.length < maxLength) {
      setState(() {
        phoneNumber += number;
      });
    }
  }

  void _onBackspace() {
    if (phoneNumber.isNotEmpty) {
      setState(() {
        phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
      });
    }
  }

  Future<void> _onConfirm() async {
    if (phoneNumber.length == maxLength) {
      setState(() => _isLoading = true);
      try {
        // Check forgetPassword FIRST
        if (widget.from == FromPage.forgetPassword) {
          final result = await _apiService.handleForgotPassword(
            phoneNumber,
            false,
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
                  lockerData: widget.lockerData,
                ),
              ),
            );
          } else {
            // print(result);
            context.showErrorSnackBar(
              AppLocalizations.of(context)!.wrongPhone
            );
          }
        } else {
          // print(phoneNumber);
          final result = await _apiService.sendOTP(
            phoneNumber,
            phoneNumber.contains('@'),
            widget.selectedLocker!,
            widget.from == FromPage.visitor ? true : false,
          );
          if (!mounted) return;
          setState(() => _isLoading = false);
          // if(result['success']){
          //   Navigator.push(context, MaterialPageRoute(builder: (context)=>SuccessPage()));
          // }else{
          if (result['success']) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPPage(
                  telOrEmail: phoneNumber.toString(),
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

  bool get _isComplete => phoneNumber.length == maxLength;

  @override
  Widget build(BuildContext context) {
    print(widget.lockerData);
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Column(
                            children: [
                              const SizedBox(height: 25),
                              // Title
                              Text(
                                AppLocalizations.of(context)!.phoneInstruct,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 40),
                              // Phone number display
                              PhoneDisplay(phoneNumber: phoneNumber),
                              const SizedBox(height: 50),
                              // Numpad
                              PhoneNumpad(
                                phoneNumber: phoneNumber,
                                onNumberPress: _onNumberPress,
                                onBackspace: _onBackspace,
                                isLoading: _isLoading,
                              ),
                              const SizedBox(height: 40),
                              // Confirm button
                              PhoneConfirmButton(
                                isLoading: _isLoading,
                                isComplete: _isComplete,
                                onConfirm: _onConfirm,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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
