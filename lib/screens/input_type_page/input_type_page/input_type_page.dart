import 'package:flutter/material.dart';
import 'dart:math';
import 'package:untitled/screens/input_type_page/email_input_page/email_input_page.dart';
import 'package:untitled/screens/input_type_page/phone_input_page/phone_input_page.dart';
import 'package:untitled/widgets/grid/HoverMenuCard.dart';
import 'package:untitled/widgets/header/header.dart';
import 'package:untitled/widgets/snackbar/snackbar.dart';
import '../../../l10n/app_localizations.dart';
import '../../../main.dart';
import '../../../services/api_service.dart';

enum FromPage {
  instance,
  normal,
  unlock,
  forgetPassword,
  resetPassword,
  visitor,
  resetPassword2,
}

class InputTypePage extends StatefulWidget {
  final FromPage from;
  final String? selectedLocker;
  final String? lockerName;
  final String? size;
  final List<Map<String, dynamic>> lockerData;

  const InputTypePage({
    super.key,
    required this.from,
    this.selectedLocker,
    this.lockerName,
    this.size,
    this.lockerData = const [],
  });

  @override
  State<InputTypePage> createState() => _InputTypePageState();
}

class _InputTypePageState extends State<InputTypePage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  static const String systemMode = String.fromEnvironment('TYPE', defaultValue: 'B2C');

  // For instance mode (random locker selection)
  String? _selectedLockerId;
  String? _selectedLockerName;
  List<Map<String, dynamic>> _lockerStatus = [];

  // Get the actual locker ID and name based on mode
  String? get _lockerId =>
      widget.from == FromPage.instance || widget.from == FromPage.visitor
      ? _selectedLockerId
      : widget.selectedLocker;

  String? get _lockerName =>
      widget.from == FromPage.instance || widget.from == FromPage.visitor
      ? _selectedLockerName
      : widget.lockerName;

  List<Map<String, dynamic>> get _effectiveLockerData =>
      widget.lockerData.isNotEmpty ? widget.lockerData : _lockerStatus;

  @override
  void initState() {
    print('input page locker value : ${widget.lockerData}');
    // print(_lockerName);
    super.initState();
    if (widget.from == FromPage.instance || widget.from == FromPage.visitor) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadLocker();
      });
    }
  }

  Future<void> _loadLocker() async {
    setState(() => _isLoading = true);

    try {
      final result = await _apiService.getLocker();
      if (!mounted) return;

      if (result['success'] == true) {
        final data = result['data'];

        List<Map<String, dynamic>> units = [];

        if (data is List && data.isNotEmpty) {
          final first = data.first;
          if (first is Map<String, dynamic>) {
            final lockerUnit = first['lockerUnit'];
            if (lockerUnit is List) {
              units = lockerUnit
                  .map((e) => Map<String, dynamic>.from(e))
                  .toList();
            }
          }
        } else if (data is Map<String, dynamic>) {
          final lockerUnit = data['lockerUnit'];
          if (lockerUnit is List) {
            units = lockerUnit
                .map((e) => Map<String, dynamic>.from(e))
                .toList();
          }
        }

        setState(() {
          _lockerStatus = units;
          _isLoading = false;
          _selectRandomAvailableLocker();
        });
      } else {
        setState(() => _isLoading = false);
        context.showErrorSnackBar('${AppLocalizations.of(context)!.errorOccur}: ${result['error']}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      context.showErrorSnackBar(AppLocalizations.of(context)!.errorOccur);
    }
  }

  void _selectRandomAvailableLocker() {
    // Filter available lockers (status: false, enable: false, booktype: 1 for quick registration)
    final availableLockers = _lockerStatus.where((locker) {
      // Base conditions
      bool baseCondition = locker['status'] == false &&
          locker['enable'] == false && locker['locker_status']=="close";

      // Book type based on FromPage
      int bookType;
      if (widget.from == FromPage.instance) {
        bookType = 1;
      } else if (widget.from == FromPage.visitor) {
        bookType = 5;
      } else {
        bookType = 1; // Default fallback
      }

      bool bookTypeCondition = locker['locker_booktype'] == bookType;

      // Size condition - only check if B2C mode AND size is provided
      bool sizeCondition;
      if (systemMode == 'B2C' && widget.size != null) {
        sizeCondition = locker['lockerSize'] == widget.size;
      } else {
        sizeCondition = true; // Skip size filter if not B2C or no size
      }

      return baseCondition && bookTypeCondition && sizeCondition;
    }).toList();

    if (availableLockers.isEmpty) {
      Navigator.pop(context);
      context.showWarningSnackBar(AppLocalizations.of(context)!.noAvailableLocker);
      return;
    }

    Random random = Random();
    Map<String, dynamic> randomLocker =
        availableLockers[random.nextInt(availableLockers.length)];

    setState(() {
      _selectedLockerId = randomLocker['id'].toString();
      _selectedLockerName = randomLocker['name'];
    });

    // print(
    //   'Random locker selected: $_selectedLockerName (ID: $_selectedLockerId)',
    // );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final appState = MyApp.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Header(currentLocale: currentLocale, onLanguageSwitch: (){appState?.toggleLocale();}),
                    const SizedBox(height: 60),

                    // Center content
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.choseInput,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              children: [
                                Expanded(
                                  child: HoverMenuCard(
                                    titleTh: Text(AppLocalizations.of(context)!.phone),
                                    icon: Icons.phone_android,
                                    color: Colors.blue,
                                    onPressed:
                                        _lockerId != null && _lockerName != null
                                        ? () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PhoneInputPage(
                                                    selectedLocker: _lockerId!,
                                                    lockerName: _lockerName!,
                                                    from: widget.from,
                                                    lockerData: _effectiveLockerData,
                                                  ),
                                            ),
                                          )
                                        : () => print(
                                            "$_lockerId,$_lockerName!,$widget.from,$widget.lockerName",
                                          ),
                                  ),
                                ),

                                const SizedBox(width: 20),
                                Expanded(
                                  child: HoverMenuCard(
                                    titleTh: Text(AppLocalizations.of(context)!.email),
                                    icon: Icons.email,
                                    color: Colors.blue,
                                    onPressed:
                                        _lockerId != null && _lockerName != null
                                        ? () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EmailInputPage(
                                                    selectedLocker: _lockerId!,
                                                    lockerName: _lockerName!,
                                                    from: widget.from,
                                                    lockerData: _effectiveLockerData,
                                                  ),
                                            ),
                                          )
                                        : () => context.showWarningSnackBar(
                                            AppLocalizations.of(context)!.loading,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 60),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'SECURE ACCESS',
                                  style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 2,
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Loading overlay
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
