import 'package:flutter/material.dart';
import 'dart:math';
import 'package:untitled/ChoseTimePage.dart';
import 'package:untitled/componants/BuildConfirmButton.dart';
import 'package:untitled/componants/BuildFromField.dart';
import 'package:untitled/validators/validator.dart';
import 'services/api_service.dart';

class InstanceUse extends StatefulWidget {
  const InstanceUse({super.key,});
  @override
  State<InstanceUse> createState() => _InstanceUse();
}

class _InstanceUse extends State<InstanceUse> {
  String? selectedLockerId;
  String? selectedLockerName;
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  final _OTPController = TextEditingController();
  final _TelOrEMailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double fontsize = 32;
  String? refCode ;
  List<Map<String, dynamic>> lockerStatus = [];

  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      //call API to get locker
      _loadLocker();
    });
  }

  Future<void> _loadLocker() async {
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.getLocker();
      if (!mounted) return;
      if (result['success']) {
        print(result);
        setState(() {
          if (result['data'] is List) {
            lockerStatus = List<Map<String, dynamic>>.from(result['data']);
          } else {
            lockerStatus = [result['data'] as Map<String, dynamic>];
          }
          _isLoading = false;
          _selectRandomAvailableLocker();
        });
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: ${result['error']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      print('Error loading lockers: $e');
    }
  }

  void _selectRandomAvailableLocker() {
    // Filter available lockers (status = false means available)
    List<Map<String, dynamic>> availableLockers = lockerStatus
        .where((locker) => locker['status'] == false)
        .toList();

    if (availableLockers.isEmpty) {
      // No available lockers
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ไม่มีตู้ว่าง กรุณาลองใหม่อีกครั้ง'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Randomly select one available locker
    Random random = Random();
    Map<String, dynamic> randomLocker = availableLockers[random.nextInt(availableLockers.length)];

    setState(() {
      selectedLockerId = randomLocker['id'].toString();
      selectedLockerName = randomLocker['name'];
    });

    print('✅ Selected random locker: $selectedLockerName (ID: $selectedLockerId)');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("หน้าลงทะเบียน"),
          backgroundColor: Colors.blue,
        ),
        body: body()
    );
  }

  Widget body(){
    return  Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                padding: EdgeInsetsGeometry.all(50.0),
                child: Column(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .center,
                  children: [
                    lockerDisplay(),
                    SizedBox(height: 20),
                    telField(),
                    sendOTPButton(),
                    otpField(),
                    confirmButton(),
                    const SizedBox(height: 20,),
                    ?refcodeZone(),
                    const SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
  Widget telField(){
    return BuildFormField(
      label: 'เบอร์โทรศัพท์หรืออีเมล',
      controller: _TelOrEMailController,
      validator: (value)=>Validators.validateEmailOrPhone(value),
    );
  }

  Widget otpField(){
    return BuildFormField(
      label: 'OTP',
      controller: _OTPController,
      validator: Validators.validateOTP,
    );
  }

  Widget lockerDisplay(){
    return Text(
      'ตู้ที่ได้ ${selectedLockerName}',
      style: TextStyle(
        fontSize: fontsize,
        color: Colors.green,
      ),
    );
  }

  Widget confirmButton(){
    return BuildConfirmButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _handleSubmitOTP();
        }
      },
      fontSize: fontsize,
      label: 'ยืนยัน',
    );
  }

  Widget sendOTPButton(){
    return BuildConfirmButton(
      onPressed: () {
        String? validatorError = Validators.validateEmailOrPhone(
          _TelOrEMailController.text,
        );
        if (validatorError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(validatorError)),
          );
          return;
        } else {
          _handleSendOTP();
        }
      },
      fontSize: fontsize,
      label: 'ส่ง OTP',
    );
  }

  Widget? refcodeZone(){
    if(refCode != null) {
      return Container(
        alignment: .center,
        child: Text(
          "refer code: $refCode!", style: TextStyle(fontSize: fontsize, color: Colors.blue),),
      );
    }
    return null;
  }

  Future<void> _handleSendOTP() async {
    if(selectedLockerId == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('ไม่มีตู้ว่าง')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    String cleanValue = _TelOrEMailController.text.replaceAll(' ', '');
    try {
      final result = await _apiService.sendOTP(
          cleanValue,
          cleanValue.contains('@'),
          selectedLockerId!
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ส่ง OTP สำเร็จ')));
        refCode = result['data']['refercode'] ?? '';
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด : ${result['error']}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    }
  }

  Future<void> _handleSubmitOTP() async {
    setState(() => _isLoading = true);
    String cleanValue = _TelOrEMailController.text.replaceAll(' ', '');
    try {
      final result = await _apiService.handleSubmitOTP(
        cleanValue,
        _OTPController.text,
        cleanValue.contains('@'),
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ยืนยัน OTP สำเร็จ')));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChoseTimePage(
              lockerId: selectedLockerId!,
              TelOrEmail: _TelOrEMailController.text,
              OTP: _OTPController.text,
              lockerName: selectedLockerName!,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด : ${result['error']}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    }
  }

  @override
  void dispose() {
    _OTPController.dispose();
    _TelOrEMailController.dispose();
    super.dispose();
  }
}
