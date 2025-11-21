import 'package:flutter/material.dart';
import 'package:untitled/ForgotPasswordPage.dart';
import 'componants/BuildFromField.dart';

class ResetPasswordPage extends StatefulWidget{
  @override
  State<ResetPasswordPage> createState()=>_ResetPasswordPage();
}


class _ResetPasswordPage extends State<ResetPasswordPage> {
  @override
  final _OldPINController = TextEditingController();
  final _NewPINController = TextEditingController();
  final _EnsurePINController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    double fontsize = 32;
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าเปลี่ยนรหัสผ่าน'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(60),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  SizedBox(height: 50),

                  BuildFormField(label: 'PIN เดิม',
                      controller: _OldPINController,
                      validator: (value){
                    if(value == null || value.isEmpty){
                      return 'กรุณากรอก PIN เดิม';
                    }
                    return null;
                  }),


                  BuildFormField(label: 'PIN ใหม่',
                      controller: _NewPINController,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "กรุณากรอก PIN ใหม่";
                        }
                        return null;
                      }),

                  BuildFormField(
                      label: 'ยืนยัน PIN ใหม่',
                      controller: _EnsurePINController,
                      validator: (value){
                        if(value == null|| value.isEmpty){
                          return 'กรุณายืนยัน PIN ใหม่';
                        }
                        return null;
                      }),


                  Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: Text('ยืนยัน', style: TextStyle(fontSize: fontsize)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordPage()));
                      },
                      child: Text(
                        'ลืมรหัสผ่าน',
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
}
