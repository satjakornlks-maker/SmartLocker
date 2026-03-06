import 'package:flutter/material.dart';
import 'package:untitled/screens/input_type_page/input_type_page/input_type_page.dart';
import 'package:untitled/widgets/header/header.dart';
import 'package:untitled/main.dart';

import '../locker_page/locker_selection_page.dart';
import 'chose_size_component/chose_size_main_content.dart';

class ChoseSizePage extends StatefulWidget {
  final LockerSelectionMode? mode;
  final FromPage? from;
  const ChoseSizePage({super.key, this.mode, this.from});

  @override
  State<ChoseSizePage> createState() => _ChoseSizePage();
}

class _ChoseSizePage extends State<ChoseSizePage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final appState = MyApp.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Header(
                      currentLocale: currentLocale,
                      onLanguageSwitch: () => appState?.toggleLocale(),
                    ),
                    const SizedBox(height: 60),
                    ChoseSizeMainContent(
                      from: widget.from,
                      mode: widget.mode,
                      onLoadingChanged: (v) => setState(() => _isLoading = v),
                    ),
                  ],
                ),
              ),
            ),
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
