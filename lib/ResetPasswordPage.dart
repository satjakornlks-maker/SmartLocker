import 'package:flutter/material.dart';
import 'package:untitled/ForgotPasswordPage.dart';
import 'package:untitled/componants/BuildConfirmButton.dart';
import 'componants/BuildFromField.dart';
import 'services/api_service.dart';
import 'validators/validator.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPage();
}

class _ResetPasswordPage extends State<ResetPasswordPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  final _OldPINController = TextEditingController();
  final _NewPINController = TextEditingController();
  final _EnsurePINController = TextEditingController();
  final _TelController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  double fontsize = 32;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าเปลี่ยนรหัสผ่าน'),
        backgroundColor: Colors.blue,
      ),
      body: body()
    );
  }

  Widget body(){
    return Stack(
      children: [
        SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.all(60),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    telField(),
                    oldOTPField(),
                    newOTPField(),
                    ensureOTPField(),
                    confirmButton(),
                    SizedBox(height: 20),
                    forgotPasswordButton(),
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

  Widget confirmButton(){
    return BuildConfirmButton(
      alignment: AlignmentGeometry.center,
      onPressed: () {
        _handleResetPassword();
      },
      fontSize: fontsize,
      label: 'ยืนยัน',
    );
  }

  Widget forgotPasswordButton(){
    return BuildConfirmButton(
      alignment: AlignmentGeometry.center,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotPasswordPage(),
          ),
        );
      },
      fontSize: fontsize,
      label: 'ลืมรหัสผ่าน',
    );
  }

  Widget telField(){
    return BuildFormField(
      label: 'เบอร์โทรศัพท์',
      controller: _TelController,
      keyboardType: TextInputType.number,
      validator: (value) => Validators.validateTel(value),
    );
  }

  Widget oldOTPField(){
    return BuildFormField(
      label: 'PIN เดิม',
      controller: _OldPINController,
      keyboardType: TextInputType.number,
      validator: (value) => Validators.validateOTP(value)
    );
  }

  Widget newOTPField(){
    return BuildFormField(
      label: 'PIN ใหม่',
      controller: _NewPINController,
      keyboardType: TextInputType.number,
      validator: (value) => Validators.validateOTP(value),
    );
  }

  Widget ensureOTPField(){
    return BuildFormField(
      label: 'ยืนยัน PIN ใหม่',
      controller: _EnsurePINController,
      keyboardType: TextInputType.number,
      validator: (value) => Validators.validateOTP(value),
    );
  }

  Future<void> _handleResetPassword() async {
    if (_formkey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final result = await _apiService.handleResetPassword(
          _OldPINController.text,
          _NewPINController.text,
          _TelController.text
        );
        if (!mounted) return;
        setState(() => _isLoading = false);
        if (result['success']) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('เปลี่ยนรหัสผ่านเสร็จสิ้น')));
          Navigator.of(context).popUntil((route) => route.isFirst);
          // _NewPINController.clear();
          // _OldPINController.clear();
          // _TelController.clear();
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('เกิดข้อผิดพลาด : ${result['error']}'),
              backgroundColor: Colors.red,
            ),
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
  }
}
