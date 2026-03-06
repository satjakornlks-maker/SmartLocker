import 'package:flutter/material.dart';
import 'package:untitled/main.dart';
import 'package:untitled/widgets/header/header.dart';
import '../../l10n/app_localizations.dart';
import '../../services/api_service.dart';
import '../../widgets/grid/HoverMenuCard.dart';
import '../../widgets/snackbar/snackbar.dart';
import '../success_page/success_page.dart';

class ConfirmationPage extends StatefulWidget {
  final String lockerId;
  final String otp;
  const ConfirmationPage({super.key, required this.lockerId, required this.otp});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPage();
}

class _ConfirmationPage extends State<ConfirmationPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final appState = MyApp.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          SafeArea(
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
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 1400),
                        child: Row(
                          children: [
                            Expanded(
                              child: HoverMenuCard(
                                titleTh: Text(
                                  AppLocalizations.of(context)!.addMoreItem,
                                ),
                                haveIcon: false,
                                color: Colors.orange,
                                onPressed: ()=>_unlockLocker(widget.otp,true),
                                aspectRatio: 1.2, icon: Icons.eighteen_mp,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: HoverMenuCard(
                                haveIcon: false,
                                titleTh: Text(
                                  AppLocalizations.of(context)!.endOfUse,
                                ),
                                icon: Icons.upload_outlined,
                                color: Colors.blue,
                                onPressed: ()=>_unlockLocker(widget.otp,false),
                                aspectRatio: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
    );
  }

  Future<void> _unlockLocker(String otp ,bool stillUse) async {
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.handleFillPIN(pin: otp, lockerId: widget.lockerId,stillUse: stillUse);
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
}
