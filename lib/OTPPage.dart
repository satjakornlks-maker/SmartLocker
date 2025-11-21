import 'package:flutter/material.dart';
import 'BookingPage.dart';

class OPTPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double fontsize=32;
    return Scaffold(
      appBar: AppBar(
        title: Text("หน้าลงทะเบียน"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            // color: Colors.red,
            padding: EdgeInsetsGeometry.all(50.0),
        
            child:Container(
              child: Column(
                mainAxisAlignment: .start,
                crossAxisAlignment: .center,
                children: [
                  Container(
                    // color: Colors.blue,
                    alignment: Alignment.topLeft,
                    child: Text(
                      'เบอร์โทรศัพท์ หรือ Email',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: fontsize),
                    ),
                  ),
                  Container(
                    // color: Colors.orange,
                    child: TextField(
                      decoration: InputDecoration(enabledBorder: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
        
                  Container(
                    // color: Colors.blue,
                    alignment: Alignment.topLeft,
                    child: Text(
                      'OTP',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: fontsize),
                    ),
                  ),
                  Container(
                    // color: Colors.orange,
                    child: TextField(
                    decoration: InputDecoration(enabledBorder: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                  height: 20,
                  ),
                  Container(
                    // color: Colors.orange,
                    alignment: AlignmentDirectional.bottomEnd,
                    child: TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>BookingPage()));
                    }, child: Text("ยืนยัน",style: TextStyle(fontSize: fontsize),))
                  ),
        
                ],
              ),
            )
        
        
          ),
        ),
      ),
    );
  }
}
