import 'package:flutter/material.dart';
import 'componants/BuildFromField.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  @override
  final _formKey = GlobalKey<FormState>();
  final _TelOrEmailController = TextEditingController();
  final _OTPController = TextEditingController();
  Widget build(BuildContext context) {
    double fontsize = 32;
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าลืมรหัสผ่าน'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกเบอร์หรืออีเมลที่ลงทะเบียน';
                      }
                      return null;
                    },
                  ),

                  BuildFormField(
                    label: 'OPT',
                    controller: _OTPController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอก OTP';
                      }
                      return null;
                    },
                  ),

                  Container(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        }
                      },
                      child: Text(
                        'ยืนยัน',
                        style: TextStyle(fontSize: fontsize),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _TelOrEmailController.dispose();
    _OTPController.dispose();
    super.dispose();
  }
}
