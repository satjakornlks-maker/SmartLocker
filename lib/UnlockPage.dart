import 'package:flutter/material.dart';

class UnlockPage extends StatelessWidget{
  const UnlockPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าปลดล็อคตู้ล็อคเกอร์'),
        backgroundColor: Colors.blue,

      ),
      body: Center(

        child:
        Container(

          child:
          Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .center,
            children: [
              SizedBox(
                height: 100,
              ),
              Text('เลือกตู้ล็อคเกอร์',style: TextStyle(fontSize: 32)),
              SizedBox(
                height: 50,
              ),
              Container(

                child:
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(10.0),
                      child: Text('A1',style: TextStyle(color: Colors.white,fontSize: 32),),
                      color: Colors.green,
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(10.0),
                      child: Text('A2',style: TextStyle(color: Colors.white,fontSize: 32),),
                      color: Colors.green,
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(10.0),
                      child: Text('A3',style: TextStyle(color: Colors.white,fontSize: 32),),
                      color: Colors.green,
                    )
                  ],
                ),
              ),
              Container(
                child:
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(10.0),
                      child: Text('A4',style: TextStyle(color: Colors.white,fontSize: 32),),
                      color: Colors.green,
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(10.0),
                      child: Text('A5',style: TextStyle(color: Colors.white,fontSize: 32),),
                      color: Colors.green,
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(10.0),
                      child: Text('A6',style: TextStyle(color: Colors.white,fontSize: 32),),
                      color: Colors.green,
                    )
                  ],
                ),
              ),
              Container(
                child:
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(10.0),
                      child: Text('A7',style: TextStyle(color: Colors.white,fontSize: 32),),
                      color: Colors.green,
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(10.0),
                      child: Text('A8',style: TextStyle(color: Colors.white,fontSize: 32),),
                      color: Colors.green,
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(10.0),
                      child: Text('A9',style: TextStyle(color: Colors.white,fontSize: 32),),
                      color: Colors.green,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              Container(
                child:
                TextButton(onPressed: (){
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }, child: Text('ปลดล็อค',style: TextStyle(fontSize: 32),)),
              )
            ],

          ),
        ),
      ),
    );

  }
}