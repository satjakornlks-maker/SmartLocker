import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/screens/register_page/register_component/register_body.dart';
import 'package:untitled/widgets/header/header.dart';
import 'package:untitled/widgets/snackbar/snackbar.dart';
import '../../../services/api_service.dart';
import 'package:untitled/main.dart';

import '../notice_page/notice_page.dart';

class RegisterPage extends StatefulWidget {
  final String selectedLocker;
  const RegisterPage({super.key, required this.selectedLocker});

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
        widget.selectedLocker,
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
