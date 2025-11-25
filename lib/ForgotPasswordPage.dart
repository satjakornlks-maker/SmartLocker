import 'package:flutter/material.dart';
import 'package:untitled/componants/BuildConfirmButton.dart';
import 'package:untitled/validators/validator.dart';
import 'componants/BuildFromField.dart';
import 'services/api_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _TelOrEmailController = TextEditingController();
  final _OTPController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    double fontsize = 32;
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าลืมรหัสผ่าน'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(60),
                  child: Column(
                    children: [
                      SizedBox(height: 50),

                      BuildFormField(
                        label: 'เบอร์โทรหรืออีเมลที่ลงทะเบียน',
                        controller: _TelOrEmailController,
                        validator: Validators.validateEmailOrPhone
                      ),

                      BuildConfirmButton(onPressed: (){
                        String? validatorError = Validators.validateEmailOrPhone(
                          _TelOrEmailController.text,
                      );
                      if (validatorError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(validatorError)),
                        );
                        return;
                      } else {
                        _handleSendOTP();
                      }},
                          fontsize: fontsize,
                          lable: 'ส่ง OTP'),

                      BuildFormField(
                        label: 'OPT',
                        controller: _OTPController,
                        validator: Validators.validateOTP
                      ),

                      BuildConfirmButton(
                          lable:'ยืนยัน',
                          onPressed: (){
                        if (_formKey.currentState!.validate()) {
                          _handleSubmitOTP();
                        }
                      }, fontsize: fontsize),

                    ],
                  ),
                ),
              ),
            ),
          ),
          if(_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }

  Future<void> _handleSendOTP() async {
    setState(() => _isLoading = true);
    String cleanValue = _TelOrEmailController.text.replaceAll(' ', '');
    try {
      final result = await _apiService.sendOTP(
        cleanValue,
        cleanValue.contains('@'),
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ส่ง OTP สำเร็จ')));
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
    String cleanValue = _TelOrEmailController.text.replaceAll(' ', '');
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
        Navigator.of(
          context,
        ).popUntil((route) => route.isFirst);
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
    _TelOrEmailController.dispose();
    _OTPController.dispose();
    super.dispose();
  }
}
