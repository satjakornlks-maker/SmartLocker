import 'package:flutter/material.dart';

class ChoseTimePage extends StatelessWidget{
  @override
  Widget build (BuildContext context){
    double fontsize=32;
    return Scaffold(
      appBar: AppBar(
        title:Text('หน้าเลือกเวลาการจอง'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: 
        Container(
          margin: EdgeInsets.all(60),
          child: 
          Column(
            children: [
              SizedBox(
                height: 50,
              ),

              Container(
                child: 
                Text('เลือกเวลาการจอง',style: TextStyle(fontSize: fontsize),),
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.all(10),
                child: DropdownMenu(
                  width: double.infinity,
                    initialSelection: '0',
                    dropdownMenuEntries: List.generate(25, (index) => index.toString())
                .map<DropdownMenuEntry<String>>((String value){
                  return DropdownMenuEntry<String>(value: value, label: value);
                    }).toList(),
                onSelected: (String? newValue){

                },),
              ),
              SizedBox(height: 20,),
              Container(
                child:
                TextButton(onPressed:(){
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