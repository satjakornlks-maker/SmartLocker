import 'package:flutter/material.dart';

class OverTimePage extends StatelessWidget{
  final String day;
  final String hour;
  final String minute;
  final String second;

  const OverTimePage({super.key, required this.second, required this.day, required this.hour, required this.minute});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าแจ้งล่วงเวลา'),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: .center,
        mainAxisAlignment: .center,

        children: [
          SizedBox(height: 50,),
          Container(
              alignment: .center,
              child: Text('ท่านได้ทำการปลดล็อกเกินเวลาจองมาแล้ว $day วัน $hour ชั่วโมง $minute นาที $second วินาที',textAlign: TextAlign.center,style: TextStyle(color: Colors.red,fontSize: 30),))
          ,SizedBox(height: 30,),
          ElevatedButton(
            onPressed: () {
              // Close the app
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text('ย้อนกลับ'),
          ),
        ],
      )
      );
  }
  
}