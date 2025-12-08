import 'package:flutter/material.dart';

class WaitUserToCloseLockerPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('หน้ารอปิดล็อคเกอร์'),
      backgroundColor: Colors.blue,
      automaticallyImplyLeading: false,),
      body: body(),
    );
  }

  Widget body(){
    return Center(
      child: Text('กรุณาปิดล็อคเกอร์หลังจากท่านฝากของเสร็จเเล้ว'),
    );
  }
}