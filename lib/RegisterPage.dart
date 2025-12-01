import 'package:flutter/material.dart';
import 'package:untitled/MemberLockerSelectPage.dart';
import 'package:untitled/componants/BuildConfirmButton.dart';
import 'package:untitled/validators/validator.dart';
import 'componants/BuildFromField.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
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
      ],
    );
  }

  Widget confirmButton(){
    return BuildConfirmButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemberLockerSelectPage(
                reason: _reasonController.text,
                email: _emailController.text,
                tel: _telController.text,
                name: _nameController.text,
              ),
            ),
          );
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
}
