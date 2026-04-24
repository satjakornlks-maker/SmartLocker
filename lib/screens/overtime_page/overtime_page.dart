import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import '../../theme/theme.dart';
import '../../widgets/header/header.dart';
import '../../widgets/snackbar/snackbar.dart';
import 'overtime_component/overtime_left_panel.dart';
import 'overtime_component/overtime_right_panel.dart';

class OvertimePage extends StatefulWidget {
  final String day;
  final String hour;
  final String minute;
  final String second;
  final String lockerId;
  final int fineAmount;

  const OvertimePage({
    super.key,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
    required this.lockerId,
    this.fineAmount = 0,
  });

  @override
  State<OvertimePage> createState() => _OvertimePageState();
}

class _OvertimePageState extends State<OvertimePage> {
  String _selectedMethod = 'qr_payment';
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  Future<void> _handlePay() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);
    try {
      final result =
          await _apiService.handleCheckLockerStatus(widget.lockerId);
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success'] && result['data']['lockStatus'] == 'Locked') {
        context.showSuccessSnackBar(l10n.lockerOpenedSuccess);
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (result['success'] &&
          result['data']['lockStatus'] == 'Unlocked') {
        context.showWarningSnackBar(
          '${l10n.errorOccur}: locker not locked yet',
        );
      } else {
        context.showErrorSnackBar(
          '${l10n.errorOccur}: ${result['error']}',
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      context.showErrorSnackBar('${l10n.errorOccur}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final appState = MyApp.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                Header(
                  currentLocale: currentLocale,
                  onLanguageSwitch: () => appState?.toggleLocale(),
                  onBackPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(child: _buildBody()),
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

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 680;

        if (isWide) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _buildLeftPanel()),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(child: _buildRightPanel(isExpanded: true)),
                  ],
                ),
              ),
            ),
          );
        }

        // Narrow: scrollable fallback
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  _buildLeftPanel(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildRightPanel(isExpanded: false),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom +
                        AppSpacing.xl,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeftPanel() {
    return OvertimeLeftPanel(
      hour: widget.hour,
      minute: widget.minute,
      fineAmount: widget.fineAmount,
    );
  }

  Widget _buildRightPanel({bool isExpanded = false}) {
    return OvertimeRightPanel(
      selectedMethod: _selectedMethod,
      onMethodChanged: (method) => setState(() => _selectedMethod = method),
      fineAmount: widget.fineAmount,
      onPay: _handlePay,
      isExpanded: isExpanded,
    );
  }
}
