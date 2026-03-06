import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import '../../widgets/header/header.dart';
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
        _showSnackBar(l10n.lockerOpenedSuccess, Colors.green);
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (result['success'] &&
          result['data']['lockStatus'] == 'Unlocked') {
        _showSnackBar(
            '${l10n.errorOccur}: locker not locked yet', Colors.orange);
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
                Expanded(child: _buildBody()),
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

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 680;

        if (isWide) {
          // Wide: fills available height — no scroll needed
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _buildLeftPanel()),
                    const SizedBox(width: 20),
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
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildLeftPanel(),
                  const SizedBox(height: 20),
                  _buildRightPanel(isExpanded: false),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 20,
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
