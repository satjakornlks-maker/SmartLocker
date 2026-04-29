import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/screens/input_type_page/input_type_page/input_type_page.dart';
import 'package:untitled/screens/input_type_page/input_type_page/input_type_service/locker_service.dart';
import 'package:untitled/screens/input_type_page/phone_input_page/phone_input_component/phone_confirm_button.dart';
import 'package:untitled/screens/input_type_page/phone_input_page/phone_input_component/phone_display.dart';
import 'package:untitled/screens/input_type_page/phone_input_page/phone_input_component/phone_numpad.dart';
import 'package:untitled/services/api_service.dart';
import 'package:untitled/services/device_config_service.dart';
import 'package:untitled/theme/theme.dart';
import 'package:untitled/widgets/header/header.dart';
import 'package:untitled/widgets/locker_mini_map/locker_mini_map.dart';
import 'package:untitled/widgets/snackbar/snackbar.dart';
import '../../../l10n/app_localizations.dart';
import '../../../main.dart';
import '../../otp_page/otp_page.dart';

class PhoneInputPage extends StatefulWidget {
  final String? selectedLocker;
  final String? lockerName;
  final FromPage from;
  final List<Map<String, dynamic>> lockerData;
  final String? size;

  const PhoneInputPage({
    super.key,
    this.selectedLocker,
    this.lockerName,
    required this.from,
    this.lockerData = const [],
    this.size,
  });

  @override
  State<PhoneInputPage> createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends State<PhoneInputPage> {
  final ApiService _apiService = ApiService();
  final LockerService _lockerService = LockerService();

  String phoneNumber = '';
  final int maxLength = 10;
  bool _isLoading = false;
  bool _isLoadingLocker = false;

  String? _selectedLockerId;
  String? _selectedLockerName;
  List<Map<String, dynamic>> _lockerStatus = [];

  bool get _isInstanceMode =>
      widget.from == FromPage.instance || widget.from == FromPage.visitor;

  bool get _showMiniMap =>
      widget.from == FromPage.instance ||
      widget.from == FromPage.visitor ||
      widget.from == FromPage.normal ||
      widget.from == FromPage.forgetPassword;

  String? get _effectiveLockerId =>
      _isInstanceMode ? _selectedLockerId : widget.selectedLocker;

  String? get _effectiveLockerName =>
      _isInstanceMode ? _selectedLockerName : widget.lockerName;

  List<Map<String, dynamic>> get _effectiveLockerData =>
      widget.lockerData.isNotEmpty ? widget.lockerData : _lockerStatus;

  String get _systemMode => DeviceConfigService.systemMode;

  @override
  void initState() {
    super.initState();
    if (_isInstanceMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadLocker();
      });
    }
  }

  Future<void> _loadLocker() async {
    setState(() => _isLoadingLocker = true);

    final result = await _lockerService.fetchLockerUnits();
    if (!mounted) return;

    if (result['success'] != true) {
      setState(() => _isLoadingLocker = false);
      context.showErrorSnackBar(
          '${AppLocalizations.of(context)!.errorOccur}: ${result['error']}');
      return;
    }

    final List<Map<String, dynamic>> units =
        List<Map<String, dynamic>>.from(result['data']);

    final selected = _lockerService.selectRandomLocker(
      units: units,
      from: widget.from,
      systemMode: _systemMode,
      size: widget.size,
    );

    if (!mounted) return;

    if (selected == null) {
      setState(() => _isLoadingLocker = false);
      Navigator.pop(context);
      context.showWarningSnackBar(
          AppLocalizations.of(context)!.noAvailableLocker);
      return;
    }

    setState(() {
      _lockerStatus = units;
      _selectedLockerId = selected['id'].toString();
      _selectedLockerName = selected['name'];
      _isLoadingLocker = false;
    });
  }

  void _onNumberPress(String number) {
    if (phoneNumber.length < maxLength) {
      HapticFeedback.selectionClick();
      setState(() {
        phoneNumber += number;
      });
    }
  }

  void _onBackspace() {
    if (phoneNumber.isNotEmpty) {
      HapticFeedback.selectionClick();
      setState(() {
        phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
      });
    }
  }

  Future<void> _onConfirm() async {
    if (phoneNumber.length != maxLength) return;

    setState(() => _isLoading = true);
    try {
      if (widget.from == FromPage.forgetPassword) {
        final result = await _apiService.handleForgotPassword(
          phoneNumber,
          false,
          _effectiveLockerId,
        );
        if (!mounted) return;
        setState(() => _isLoading = false);
        if (result['success']) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPPage(
                from: FromPage.forgetPassword,
                lockerName: _effectiveLockerName,
                lockerId: _effectiveLockerId,
                lockerData: _effectiveLockerData,
              ),
            ),
          );
        } else {
          context.showErrorSnackBar(
            AppLocalizations.of(context)!.wrongPhone,
          );
          setState(() => phoneNumber = '');
        }
      } else {
        if (_effectiveLockerId == null) {
          setState(() => _isLoading = false);
          if (mounted) {
            context.showErrorSnackBar(AppLocalizations.of(context)!.noLocker);
          }
          return;
        }
        final result = await _apiService.sendOTP(
          phoneNumber,
          phoneNumber.contains('@'),
          _effectiveLockerId!,
          widget.from == FromPage.visitor,
        );
        if (!mounted) return;
        setState(() => _isLoading = false);
        if (result['success']) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPPage(
                telOrEmail: phoneNumber.toString(),
                from: widget.from,
                lockerId: _effectiveLockerId,
                lockerName: _effectiveLockerName,
                userId: result['data']['userId'],
                refCode: result['data']['refercode'],
                lockerData: _effectiveLockerData,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          final msg = result['statusCode'] == 403
              ? AppLocalizations.of(context)!.notAuthorizedEmployee
              : '${AppLocalizations.of(context)!.errorOccur}: ${result['error']}';
          context.showErrorSnackBar(msg);
          setState(() => phoneNumber = '');
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      context.showErrorSnackBar(
          '${AppLocalizations.of(context)!.errorOccur}: $e');
    }
  }

  bool get _isComplete => phoneNumber.length == maxLength;

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final appState = MyApp.of(context);
    final l = AppLocalizations.of(context)!;

    final phonePanel = Container(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l.phoneInstruct,
            textAlign: TextAlign.center,
            style: AppText.headingLargeR(context),
          ),
          const SizedBox(height: AppSpacing.xxl),
          PhoneDisplay(phoneNumber: phoneNumber),
          const SizedBox(height: 20),
          PhoneNumpad(
            phoneNumber: phoneNumber,
            onNumberPress: _onNumberPress,
            onBackspace: _onBackspace,
            isLoading: _isLoading,
          ),
          PhoneConfirmButton(
            isLoading: _isLoading,
            isComplete: _isComplete,
            onConfirm: _onConfirm,
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: _showMiniMap
                        ? Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 480),
                                  child: LockerMiniMap(
                                    lockerData: _effectiveLockerData,
                                    selectedLockerId: _effectiveLockerId,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.xxxl),
                                phonePanel,
                              ],
                            ),
                          )
                        : Center(child: phonePanel),
                  ),
                ),
              ],
            ),
            if (_isLoading || _isLoadingLocker)
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
      ),
    );
  }
}
