import 'package:flutter/material.dart';
import 'package:untitled/MemberLockerSelectPage.dart';
import 'package:untitled/componants/BuildConfirmButton.dart';
import 'package:untitled/validators/validator.dart';
import 'NoticePage.dart';
import 'componants/BuildFromField.dart';
import 'services/api_service.dart';

class RegisterPage extends StatefulWidget {
  final String selectedLocker;
  const RegisterPage({super.key, required this.selectedLocker});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  double fontsize = 32;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _telController = TextEditingController();
  final _emailController = TextEditingController();
  final _reasonController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าสมัครสมาชิก'),
        backgroundColor: Colors.blue,
      ),
      body: body()
    );
  }

  Widget body(){
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(40),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  nameField(),
                  telField(),
                  emailField(),
                  reasonField(),
                  confirmButton()
                ],
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
    );
  }

  Widget confirmButton(){
    return BuildConfirmButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _handleUnlockMember();

        }
      },
      fontSize: fontsize,
      label: 'ยืนยัน',
      alignment: AlignmentDirectional.center,
    );
  }

  Widget nameField() {
    return BuildFormField(
      label: "ชื่อ-สกุล",
      controller: _nameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกชื่อ';
        }
        return null;
      },
    );
  }

  Widget telField(){
    return BuildFormField(
      label: 'เบอร์โทร',
      controller: _telController,
      keyboardType: TextInputType.number,
      validator: Validators.validateTel,
    );
  }

  Widget emailField(){
    return BuildFormField(
      label: 'Email',
      controller: _emailController,
      validator: Validators.validateEmail,
    );
  }

  Widget reasonField(){
    return BuildFormField(
      label: 'เหตุผล',
      controller: _reasonController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกเหตุผล';
        }
        return null;
      },
    );
  }

  Future<void> _handleUnlockMember() async {

      setState(() => _isLoading = true);
      try {
        final result = await _apiService.regisAccount(
          _nameController.text,
          _telController.text,
          _emailController.text,
          _reasonController.text,
          widget.selectedLocker!,
        );
        if (!mounted) return;
        setState(() => _isLoading = false);
        if (result['success']) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('สมัครสมาชิกเสร็จสิ้น')));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoticePage()),
          );
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('เกิดข้อผิดพลาด ข้อมูลที่ส่งไปไม่ตรงกับ backend : ${result['error']}'),
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
