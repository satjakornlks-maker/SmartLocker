import 'package:flutter/material.dart';
import 'package:untitled/main.dart';
import 'package:untitled/theme/theme.dart';
import 'package:untitled/widgets/header/header.dart';
import '../../l10n/app_localizations.dart';
import '../../services/api_service.dart';
import '../../widgets/grid/HoverMenuCard.dart';
import '../../widgets/snackbar/snackbar.dart';
import '../success_page/success_page.dart';

class ConfirmationPage extends StatefulWidget {
  final String lockerId;
  final String otp;
  const ConfirmationPage({
    super.key,
    required this.lockerId,
    required this.otp,
  });

  @override
  State<ConfirmationPage> createState() => _ConfirmationPage();
}

class _ConfirmationPage extends State<ConfirmationPage> {
  final ApiService _apiService = ApiService.instance;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final appState = MyApp.of(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
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
                  const SizedBox(height: AppSpacing.xxxl),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                    ),
                    child: Text(
                      l.whatWouldYouLikeToDo,
                      style: AppText.headingLargeR(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1400),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: HoverMenuCard(
                              titleTh: Text(l.addMoreItem),
                              haveIcon: false,
                              color: AppColors.accent,
                              onPressed: () =>
                                  _unlockLocker(widget.otp, true),
                              aspectRatio: 1.2,
                              icon: Icons.add_circle_outline,
                              semanticLabel: l.addMoreItem,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: HoverMenuCard(
                              haveIcon: false,
                              titleTh: Text(l.endOfUse),
                              icon: Icons.upload_outlined,
                              color: AppColors.primary,
                              onPressed: () =>
                                  _unlockLocker(widget.otp, false),
                              aspectRatio: 1.2,
                              semanticLabel: l.endOfUse,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
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
    );
  }

  Future<void> _unlockLocker(String otp, bool stillUse) async {
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.handleFillPIN(
        pin: otp,
        lockerId: widget.lockerId,
        stillUse: stillUse,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SuccessPage()),
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
