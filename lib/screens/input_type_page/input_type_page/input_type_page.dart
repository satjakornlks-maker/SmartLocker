import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final appState = MyApp.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Header(
                  currentLocale: currentLocale,
                  onLanguageSwitch: () {
                    appState?.toggleLocale();
                  },
                ),
                const SizedBox(height: 60),
                InputTypeMainContent(
                  from: widget.from,
                  selectedLocker: widget.selectedLocker,
                  lockerName: widget.lockerName,
                  size: widget.size,
                  lockerData: widget.lockerData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
