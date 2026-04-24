import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/screens/register_page/register_component/register_body.dart';
import 'package:untitled/services/device_config_service.dart';
import 'package:untitled/theme/theme.dart';
import 'package:untitled/widgets/header/header.dart';
import 'package:untitled/widgets/snackbar/snackbar.dart';
import '../../../services/api_service.dart';
import 'package:untitled/main.dart';

import '../notice_page/notice_page.dart';

class RegisterPage extends StatefulWidget {
  final String selectedLocker;
  const RegisterPage({super.key, this.selectedLocker = ''});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _telController = TextEditingController();
  final _emailController = TextEditingController();
  final _reasonController = TextEditingController();

  String get _qrUrl {
    final deviceId = DeviceConfigService.deviceId;
    return 'http://smart-locker.lanna.co.th/member-register?device_id=$deviceId';
  }

  Widget _buildQrCard(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Semantics(
        label: '${l.scanQrTitle}. ${l.scanQrSubtitle}',
        child: Row(
          children: [
            QrImageView(
              data: _qrUrl,
              version: QrVersions.auto,
              size: 90,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: AppColors.primary,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.scanQrTitle,
                    style: const TextStyle(
                      fontFamily: AppText.family,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l.scanQrSubtitle,
                    style: const TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                Header(
                  currentLocale: currentLocale,
                  onLanguageSwitch: () {
                    appState?.toggleLocale();
                  },
                ),
                _buildQrCard(context),
                Expanded(
                  child: RegisterBody(
                    formKey: _formKey,
                    nameController: _nameController,
                    telController: _telController,
                    emailController: _emailController,
                    reasonController: _reasonController,
                    handleUnlockMember: _handleUnlockMember,
                  ),
                ),
              ],
            ),
            if (_isLoading)
              Container(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleUnlockMember() async {
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.regisAccount(
        _nameController.text,
        _telController.text,
        _emailController.text,
        _reasonController.text,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        context.showSuccessSnackBar(
          AppLocalizations.of(context)!.registerSuccess,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NoticePage()),
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

  @override
  void dispose() {
    _nameController.dispose();
    _telController.dispose();
    _emailController.dispose();
    _reasonController.dispose();
    super.dispose();
  }
}
