import 'package:flutter/material.dart';
import 'package:untitled/ForgotPasswordPage.dart';

class ResetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double fontsize = 32;
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าเปลี่ยนรหัสผ่าน'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(60),
          child: Column(
            children: [
              SizedBox(height: 50),
              Container(
                alignment: AlignmentDirectional.topStart,
                child: Text('PIN เดิม', style: TextStyle(fontSize: fontsize)),
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
                alignment: AlignmentDirectional.topStart,
                child: Text('PIN ใหม่', style: TextStyle(fontSize: fontsize)),
              ),
              SizedBox(height: 20),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'ยืนยัน PIN ใหม่',
                  style: TextStyle(fontSize: fontsize),
                ),
              ),
              SizedBox(height: 20),
              Container(
                alignment: AlignmentDirectional.bottomEnd,
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
    );
  }
}
