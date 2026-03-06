import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import '../../widgets/header/header.dart';
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
  final ApiService _apiService = ApiService();

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
        _showSnackBar(l10n.lockerOpenedSuccess, Colors.green);
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        _showSnackBar('${l10n.errorOccur}: ${result['error']}', Colors.red);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnackBar('${l10n.errorOccur}: $e', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);
    final appState = MyApp.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                Header(
                  currentLocale: currentLocale,
                  onLanguageSwitch: () => appState?.toggleLocale(),
                  onBackPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: _buildBody(l10n),
                ),
              ],
            ),
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.paymentSubtitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  isWide
                      ? IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: _buildLeftPanel()),
                              const SizedBox(width: 20),
                              Expanded(child: _buildRightPanel()),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            _buildLeftPanel(),
                            const SizedBox(height: 20),
                            _buildRightPanel(),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).padding.bottom + 20,
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
