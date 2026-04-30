import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import '../../theme/theme.dart';
import '../../widgets/header/header.dart';
import '../../widgets/snackbar/snackbar.dart';
import 'payment_component/payment_left_panel.dart';
import 'payment_component/payment_right_panel.dart';

class PaymentPage extends StatefulWidget {
  final String lockerId;
  final String lockerName;
  final String telOrEmail;
  final String otp;
  final int userId;
  final bool isVisitor;
  final String bookingType;
  final int quantity;
  final int total;

  const PaymentPage({
    super.key,
    required this.lockerId,
    required this.lockerName,
    required this.telOrEmail,
    required this.otp,
    required this.userId,
    this.isVisitor = false,
    required this.bookingType,
    required this.quantity,
    required this.total,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedMethod = 'qr_payment';
  bool _isLoading = false;
  final ApiService _apiService = ApiService.instance;

  Future<void> _handlePay() async {
    final l10n = AppLocalizations.of(context)!;
    final hours =
        widget.bookingType == 'day' ? widget.quantity * 24 : widget.quantity;
    final futureTime = DateTime.now().add(Duration(hours: hours));
    setState(() => _isLoading = true);
    final cleanValue = widget.telOrEmail.replaceAll(' ', '');
    try {
      final result = await _apiService.bookLocker(
        cleanValue.contains('@'),
        cleanValue,
        widget.lockerId,
        widget.otp,
        futureTime,
        widget.userId,
        widget.isVisitor,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        context.showSuccessSnackBar(l10n.lockerOpenedSuccess);
        Navigator.of(context).popUntil((route) => route.isFirst);
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
    final l10n = AppLocalizations.of(context)!;
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
                Expanded(child: _buildBody(l10n)),
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

  Widget _buildBody(AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 680;
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.paymentSubtitle,
                    style: AppText.headingMediumR(context).copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  isWide
                      ? IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: _buildLeftPanel()),
                              const SizedBox(width: AppSpacing.xl),
                              Expanded(child: _buildRightPanel()),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            _buildLeftPanel(),
                            const SizedBox(height: AppSpacing.xl),
                            _buildRightPanel(),
                            SizedBox(
                              height: MediaQuery.of(context).padding.bottom +
                                  AppSpacing.xl,
                            ),
                          ],
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
    return PaymentLeftPanel(
      selectedMethod: _selectedMethod,
      onMethodChanged: (method) => setState(() => _selectedMethod = method),
    );
  }

  Widget _buildRightPanel() {
    return PaymentRightPanel(
      selectedMethod: _selectedMethod,
      bookingType: widget.bookingType,
      quantity: widget.quantity,
      total: widget.total,
      onPay: _handlePay,
    );
  }
}
