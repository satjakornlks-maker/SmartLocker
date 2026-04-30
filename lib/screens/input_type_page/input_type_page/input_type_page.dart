import 'package:flutter/material.dart';
import 'package:untitled/theme/theme.dart';
import 'package:untitled/widgets/header/header.dart';
import 'package:untitled/main.dart';
import 'input_type_component/input_type_main_content.dart';

enum FromPage {
  instance,
  normal,
  unlock,
  forgetPassword,
  resetPassword,
  visitor,
  resetPassword2,
  dropBox,
}

class InputTypePage extends StatefulWidget {
  final FromPage from;
  final String? selectedLocker;
  final String? lockerName;
  final String? size;
  final List<Map<String, dynamic>> lockerData;

  const InputTypePage({
    super.key,
    required this.from,
    this.selectedLocker,
    this.lockerName,
    this.size,
    this.lockerData = const [],
  });

  @override
  State<InputTypePage> createState() => _InputTypePageState();
}

class _InputTypePageState extends State<InputTypePage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final appState = MyApp.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    Header(
                      currentLocale: currentLocale,
                      onLanguageSwitch: () {
                        appState?.toggleLocale();
                      },
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    InputTypeMainContent(
                      from: widget.from,
                      selectedLocker: widget.selectedLocker,
                      lockerName: widget.lockerName,
                      size: widget.size,
                      lockerData: widget.lockerData,
                      onLoadingChanged: (v) => setState(() => _isLoading = v),
                    ),
                  ],
                ),
              ),
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
