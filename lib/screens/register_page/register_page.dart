import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/screens/register_page/register_component/register_body.dart';
import 'package:untitled/services/device_config_service.dart';
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

  Widget _buildQrCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          QrImageView(
            data: _qrUrl,
            version: QrVersions.auto,
            size: 90,
            eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Color(0xFF673AB7)),
            dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Color(0xFF673AB7)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('สแกน QR เพื่อลงทะเบียน', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF673AB7))),
                const SizedBox(height: 4),
                const Text('ลงทะเบียนผ่านมือถือของคุณ\nโดยสแกน QR code นี้', style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
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
                },),
                _buildQrCard(),
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
        context.showSuccessSnackBar(AppLocalizations.of(context)!.registerSuccess);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NoticePage()),
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

  @override
  void dispose() {
    _nameController.dispose();
    _telController.dispose();
    _emailController.dispose();
    _reasonController.dispose();
    super.dispose();
  }
}
