import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import '../../theme/theme.dart';
import '../../widgets/header/header.dart';
import '../../widgets/snackbar/snackbar.dart';
import '../payment_page/payment_page.dart';
import 'chose_time_component/booking_promotion.dart';
import 'chose_time_component/chose_time_left_panel.dart';
import 'chose_time_component/chose_time_right_panel.dart';

class ChoseTimePage extends StatefulWidget {
  final String lockerId;
  final String lockerName;
  final String telOrEmail;
  final String otp;
  final int userId;
  final bool isVisitor;
  const ChoseTimePage({
    super.key,
    required this.lockerId,
    required this.telOrEmail,
    required this.otp,
    required this.lockerName,
    required this.userId,
    this.isVisitor = false,
  });
  @override
  State<ChoseTimePage> createState() => _ChoseTimePage();
}

class _ChoseTimePage extends State<ChoseTimePage> {
  String _bookingType = 'day';
  int _quantity = 1;

  final TextEditingController _promoController = TextEditingController();
  int _promoDiscount = 0;
  bool _isPromoApplied = false;
  String _promoMessage = '';
  String _promoError = '';

  // Example promo codes — replace with real API call as needed
  static const Map<String, int> _promoCodes = {
    'SAVE10': 10,
    'DISCOUNT20': 20,
  };

  int get _unitPrice =>
      _bookingType == 'day' ? ChoseTimeLeftPanel.dailyRate : ChoseTimeLeftPanel.hourlyRate;
  int get _subtotal => _unitPrice * _quantity;

  int get _autoPromoDiscount {
    final eligible = mockPromotions
        .where((p) => p.isEligible(_bookingType, _quantity))
        .toList();
    if (eligible.isEmpty) return 0;
    final best = eligible.reduce((a, b) =>
        a.computeDiscount(_subtotal) >= b.computeDiscount(_subtotal) ? a : b);
    return best.computeDiscount(_subtotal);
  }

  int get _total =>
      (_subtotal - _autoPromoDiscount - _promoDiscount).clamp(0, 999999);

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _onTypeChanged(String type) {
    setState(() {
      _bookingType = type;
      _quantity = 1;
    });
  }

  void _onQuantityChanged(int value) {
    setState(() => _quantity = value);
  }

  void _onPromoChanged() {
    if (_isPromoApplied || _promoError.isNotEmpty) {
      setState(() {
        _isPromoApplied = false;
        _promoDiscount = 0;
        _promoMessage = '';
        _promoError = '';
      });
    }
  }

  void _applyPromoCode() {
    final l10n = AppLocalizations.of(context)!;
    final code = _promoController.text.trim().toUpperCase();
    if (code.isEmpty) {
      setState(() {
        _promoError = l10n.pleaseEnterPromoCode;
        _promoMessage = '';
        _isPromoApplied = false;
        _promoDiscount = 0;
      });
      return;
    }
    if (_promoCodes.containsKey(code)) {
      final discount = _promoCodes[code]!;
      setState(() {
        _promoDiscount = discount;
        _isPromoApplied = true;
        _promoMessage = '${l10n.discountCode} "$code": -$discount ${l10n.baht}';
        _promoError = '';
      });
    } else {
      setState(() {
        _promoDiscount = 0;
        _isPromoApplied = false;
        _promoMessage = '';
        _promoError = l10n.invalidPromoCode;
      });
    }
  }

  void _handleSubmit() {
    final l10n = AppLocalizations.of(context)!;
    if (_quantity == 0) {
      final unitLabel = _bookingType == 'day' ? l10n.day : l10n.hour;
      context.showErrorSnackBar('${l10n.pleaseSpecifyAmount} ($unitLabel)');
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaymentPage(
          lockerId: widget.lockerId,
          lockerName: widget.lockerName,
          telOrEmail: widget.telOrEmail,
          otp: widget.otp,
          userId: widget.userId,
          isVisitor: widget.isVisitor,
          bookingType: _bookingType,
          quantity: _quantity,
          total: _total,
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
        bottom: false,
        child: Column(
          children: [
            Header(
              currentLocale: currentLocale,
              onLanguageSwitch: () => appState?.toggleLocale(),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 680;
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: isWide
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeftPanel() {
    return ChoseTimeLeftPanel(
      bookingType: _bookingType,
      quantity: _quantity,
      onTypeChanged: _onTypeChanged,
      onQuantityChanged: _onQuantityChanged,
    );
  }

  Widget _buildRightPanel() {
    return ChoseTimeRightPanel(
      bookingType: _bookingType,
      quantity: _quantity,
      subtotal: _subtotal,
      total: _total,
      promoDiscount: _promoDiscount,
      autoPromoDiscount: _autoPromoDiscount,
      isPromoApplied: _isPromoApplied,
      promoMessage: _promoMessage,
      promoError: _promoError,
      promoController: _promoController,
      onApplyPromo: _applyPromoCode,
      onPromoChanged: _onPromoChanged,
      onConfirm: _handleSubmit,
    );
  }
}
