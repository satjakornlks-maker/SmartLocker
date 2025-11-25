import 'package:flutter/material.dart';
import 'package:untitled/ForgotPasswordPage.dart';
import 'package:untitled/componants/BuildConfirmButton.dart';
import 'componants/BuildFromField.dart';
import 'services/api_service.dart';

class FillPinPage extends StatefulWidget {
  final String? lockerId;
  const FillPinPage({super.key, this.lockerId});
  @override
  State<FillPinPage> createState() => _FillPinPage();
}

class _FillPinPage extends State<FillPinPage> {
  bool _isLoading = false;
  ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _PINContorller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double fontsize = 32;
    return Scaffold(
      appBar: AppBar(title: Text('หน้าใส่ PIN'), backgroundColor: Colors.blue),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.all(40),
                child: Column(
                  children: [
                    SizedBox(height: 50),

                    Container(
                      child: Text(
                        'ตู้ที่เลือก ${widget.lockerId!}',
                        style: TextStyle(
                          fontSize: fontsize,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    BuildFormField(
                      label: 'PIN(OTP)',
                      controller: _PINContorller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอก PIN';
                        }
                        return null;
                      },
                    ),
                    BuildConfirmButton(
                      alignment: AlignmentGeometry.center,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _handlePINSubmit();
                        }
                      },
                      fontsize: fontsize,
                      lable: 'ยืนยัน',
                    ),
                    SizedBox(height: 20),
                    BuildConfirmButton(
                      alignment: AlignmentGeometry.center,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
                        );
                      },
                      fontsize: fontsize,
                      lable: 'ลืมรหัสผ่าน',
                    ),
                  ],
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
      ),
    );
  }

  Future<void> _handlePINSubmit() async {
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.handleFillPIN(_PINContorller.text);
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ยืนยัน PIN สำเร็จ')));
        Navigator.of(context).popUntil((route) => route.isFirst);
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
    _PINContorller.dispose();
    super.dispose();
  }
}
