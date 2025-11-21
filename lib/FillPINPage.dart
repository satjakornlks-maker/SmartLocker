import 'package:flutter/material.dart';
import 'package:untitled/ForgotPasswordPage.dart';
import 'componants/BuildFromField.dart';

class FillPinPage extends StatefulWidget{
  @override
  State<FillPinPage> createState() => _FillPinPage();
}

class _FillPinPage extends State<FillPinPage>{
  @override
  final _formKey = GlobalKey<FormState>();
  final _PINContorller = TextEditingController();
  Widget build(BuildContext context){

    double fontsize = 32;
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าใส่ PIN'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.all(40),
            child:
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
        
                BuildFormField(label: 'PIN(OTP)',
                    controller: _PINContorller,
                    validator: (value){
                    if(value == null || value.isEmpty){
                      return 'กรุณากรอก PIN';
                    }
                    return null;
                    }),
        
        
                Container(
                  child: TextButton(onPressed: (){
                    if (_formKey.currentState!.validate()){
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  }, child: Text('ยืนยัน',style: TextStyle(fontSize: fontsize),)),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordPage()));
                  }, child: Text('ลืมรหัสผ่าน',style: TextStyle(fontSize: fontsize),)),
                )
              ],
            ),
          ),
        ),
      ),
    );

  }
  @override
  void dispose(){
    _PINContorller.dispose();
    super.dispose();
  }
}