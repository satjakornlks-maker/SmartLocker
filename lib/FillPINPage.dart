import 'package:flutter/material.dart';
import 'package:untitled/ForgotPasswordPage.dart';
import 'package:untitled/OvertimePage.dart';
import 'package:untitled/componants/BuildConfirmButton.dart';
import 'componants/BuildFromField.dart';
import 'services/api_service.dart';

class FillPinPage extends StatefulWidget {
  final String lockerId;
  final String lockerName;
  const FillPinPage({super.key, required this.lockerId, required this.lockerName});
  @override
  State<FillPinPage> createState() => _FillPinPage();
}

class _FillPinPage extends State<FillPinPage> {
  bool _isLoading = false;
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _PINController = TextEditingController();
  double fontsize = 32;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('หน้าใส่ PIN'), backgroundColor: Colors.blue),
      body: body(),
    );
  }

  Widget body() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.all(40),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  selectLockerDisplay(),
                  SizedBox(height: 20),
                  fillPinZone(),
                  confirmButton(),
                  SizedBox(height: 20),
                  forgotPasswordButton(),
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
    );
  }

  Widget confirmButton() {
    return BuildConfirmButton(
      alignment: AlignmentGeometry.center,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _handlePINSubmit();
        }
      },
      fontSize: fontsize,
      label: 'ยืนยัน',
    );
  }

  Widget forgotPasswordButton() {
    return BuildConfirmButton(
      alignment: AlignmentGeometry.center,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
        );
      },
      fontSize: fontsize,
      label: 'ลืมรหัสผ่าน',
    );
  }

  Widget fillPinZone() {
    return BuildFormField(
      label: 'PIN(OTP)',
      keyboardType: TextInputType.number,
      controller: _PINController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอก PIN';
        }
        return null;
      },
    );
  }

  Widget selectLockerDisplay() {
    return Text(
      'ตู้ที่เลือก ${widget.lockerName}',
      style: TextStyle(fontSize: fontsize, color: Colors.green),
    );
  }

  Future<void> _handlePINSubmit() async {
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.handleFillPIN(
        _PINController.text,
        widget.lockerId,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ยืนยัน PIN สำเร็จ')));
        if (result['data'] != null && result['data']['overtime'] != null) {

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OverTimePage(
                day: result['data']['overtime']['days'].toString(),
                hour: result['data']['overtime']['hours'].toString(),
                minute: result['data']['overtime']['minutes'].toString(),
                second: result['data']['overtime']['seconds'].toString(),
              ),
            ),
          );
          _PINController.clear();
        }else{
          Navigator.of(context).popUntil((route) => route.isFirst);
          _PINController.clear();
        }
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
      ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด frontEnd: $e')));
    }
  }

  @override
  void dispose() {
    _PINController.dispose();
    super.dispose();
  }
}
