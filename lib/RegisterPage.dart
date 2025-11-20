import 'package:flutter/material.dart';
import 'package:untitled/NoticePage.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  @override
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  Widget build(BuildContext context) {
    double fontsize = 32;
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าสมัครสมาชิก'),
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(40),
          child: Column(
            children: [
              SizedBox(height: 50),
              Container(
                alignment: Alignment.topLeft,
                child: Text('ชื่อ-สกุล', style: TextStyle(fontSize: fontsize)),
              ),
              SizedBox(height: 20),
              Container(
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'กรุณากรอกชื่อ';
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.topLeft,
                child: Text('เบอร์โทร', style: TextStyle(fontSize: fontsize)),
              ),
              SizedBox(height: 20),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.topLeft,
                child: Text('Email', style: TextStyle(fontSize: fontsize)),
              ),
              SizedBox(height: 20),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.topLeft,
                child: Text('เหตุผล', style: TextStyle(fontSize: fontsize)),
              ),
              SizedBox(height: 20),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: TextButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NoticePage()),
                      );
                    }

                  },
                  child: Text('ยืนยัน', style: TextStyle(fontSize: fontsize)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
