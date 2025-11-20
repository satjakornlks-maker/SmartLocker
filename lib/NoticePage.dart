import 'package:flutter/material.dart';
class NoticePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    double fontsize = 32;
    return
        Scaffold(
          appBar: AppBar(
            title: Text('หน้าแจ้งเตือน'),
            backgroundColor: Colors.blue,
          ),
          body: 
          Center(
            child: 
            Container(
              child: 
              Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: Text('ลงทะเบียนสำเร็จ',style: TextStyle(fontSize: fontsize),),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Text('เมื่อ admin อนุมัติจะแจ้งผลการลงทะเบียน และ รหัสผ่าน ผ่านทาง email หรือ เบอร์โทร',textAlign: TextAlign.center,style: TextStyle(fontSize: 32),),
                  ),
                  Container(
                    child: Text('',style: TextStyle(fontSize: fontsize),),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: TextButton(onPressed: (){
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }, child: Text('ยืนยัน',style: TextStyle(fontSize: fontsize),)),
                  )
                ],
              ),
            ),
          ),
        );
  }
}