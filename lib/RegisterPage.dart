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
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  SizedBox(height: 50),

                  BuildFormField(
                    label: "ชื่อ-สกุล",
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกชื่อ';
                      }
                      return null;
                    },
                  ),

                  BuildFormField(
                    label: 'เบอร์โทร',
                    controller: _telController,
                    validator: Validators.validateTel,
                  ),

                  BuildFormField(
                    label: 'Email',
                    controller: _emailController,
                    validator: Validators.validateEmail,
                  ),

                  BuildFormField(
                    label: 'เหตุผล',
                    controller: _reasonController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกเหตุผล';
                      }
                      return null;
                    },
                  ),

                  BuildConfirmButton(
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
                    fontsize: fontsize,
                    lable: 'ยืนยัน',
                    alignment: AlignmentDirectional.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
