import 'package:flutter/material.dart';
class ForgotPasswordPage extends StatelessWidget {
  @override 
  Widget build(BuildContext context){
    double fontsize = 32;
    return Scaffold(
      appBar: AppBar(title: Text('หน้าลืมรหัสผ่าน'),
      backgroundColor: Colors.blue,),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(60),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                alignment: AlignmentDirectional.topStart,
                child: 
                Text('เบอร์โทร หรือ อีเมล ที่ใช้ในการลงทะเบียน',textAlign: TextAlign.center,style: TextStyle(fontSize: fontsize),),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: TextField(decoration: InputDecoration(enabledBorder: OutlineInputBorder()),),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: AlignmentDirectional.bottomEnd,
                child: TextButton(onPressed: (){}, child: Text('รับ OTP',style: TextStyle(fontSize: fontsize),))
              ),
              SizedBox(height: 20,),
              Container(
                alignment: AlignmentDirectional.topStart,
                child: Text('OTP',style: TextStyle(fontSize: fontsize),),
              ),
              SizedBox(height: 20,),
              Container(
                child: TextField(decoration: InputDecoration(enabledBorder: OutlineInputBorder()),),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: AlignmentDirectional.bottomEnd,
                
                child: TextButton(onPressed: (){
                  Navigator.of(context).popUntil((route)=>route.isFirst);
                }, child: Text('ยืนยัน',style: TextStyle(fontSize: fontsize),)),
              )
            ],
          ),
        ),
      ),
    );
  }
}