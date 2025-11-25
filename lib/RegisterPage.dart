import 'package:flutter/material.dart';
import 'package:untitled/MemberLockerSelectPage.dart';
import 'componants/BuildFromField.dart';
import 'services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  ApiService _apiService = ApiService();
  bool _isloading = false;
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกเบอร์โทร';
                      }
                      return null;
                    },
                  ),

                  BuildFormField(
                    label: 'Email',
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกอีเมล';
                      }
                      return null;
                    },
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

                  Container(
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context)=>MemberLockerSelectPage(
                                    reason: _reasonController.text,
                                    email: _emailController.text,
                                    tel: _telController.text,
                                    name: _nameController.text,
                                  )));
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
          if (_isloading)
            Container(
              color: Colors.black54,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }


}
