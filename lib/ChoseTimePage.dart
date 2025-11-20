import 'package:flutter/material.dart';

class ChoseTimePage extends StatelessWidget{
  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:Text('หน้าเลือกเวลาการจอง'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: 
        Container(
          child: 
          Column(
            children: [
              Container(
                child: 
                Text('เลือกเวลาการจอง'),
              )
            ],
          ),
        ),
      ),
    );
  }
}