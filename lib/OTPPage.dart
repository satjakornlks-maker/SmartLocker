import 'package:flutter/material.dart';
import 'package:untitled/ChoseTimePage.dart';
import 'package:untitled/componants/BuildConfirmButton.dart';
import 'package:untitled/componants/BuildFromField.dart';
import 'package:untitled/validators/validator.dart';
import 'services/api_service.dart';

class OTPPage extends StatefulWidget {
  final String lockerId;
  const OTPPage({super.key, required this.lockerId});
  @override
  State<OTPPage> createState() => _OTPPage();
}

class _OTPPage extends State<OTPPage> {
  final ApiService _apiService = ApiService();
  bool _isloading = false;
  final _OTPController = TextEditingController();
  final _TelOrEMailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double fontsize = 32;
  String? refCode ;
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
                    Text(
                      'ตู้ที่เลือก ${widget.lockerId}',
                      style: TextStyle(
                        fontSize: fontsize,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 20),
                    BuildFormField(
                      label: 'เบอร์โทรศัพท์หรืออีเมล',
                      controller: _TelOrEMailController,
                      validator: (value)=>Validators.validateEmailOrPhone(value),
                    ),
                    sendOTPButton(),
                    BuildFormField(
                      label: 'OTP',
                      controller: _OTPController,
                      validator: Validators.validateOTP,
                    ),
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
        if (_isloading)
          Container(
            color: Colors.black54,
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
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
    setState(() => _isloading = true);
    String cleanValue = _TelOrEMailController.text.replaceAll(' ', '');
    try {
      final result = await _apiService.sendOTP(
        cleanValue,
        cleanValue.contains('@'),
        widget.lockerId
      );
      if (!mounted) return;
      setState(() => _isloading = false);
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
      setState(() => _isloading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    }
  }

  Future<void> _handleSubmitOTP() async {
    setState(() => _isloading = true);
    String cleanValue = _TelOrEMailController.text.replaceAll(' ', '');
    try {
      final result = await _apiService.handleSubmitOTP(
        cleanValue,
        _OTPController.text,
        cleanValue.contains('@'),
      );
      if (!mounted) return;
      setState(() => _isloading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ยืนยัน OTP สำเร็จ')));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChoseTimePage(
              lockerId: widget.lockerId,
              TelOrEmail: _TelOrEMailController.text,
              OTP: _OTPController.text,
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
      setState(() => _isloading = false);
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
