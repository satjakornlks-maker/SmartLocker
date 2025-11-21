import 'package:flutter/material.dart';
import 'package:untitled/ChoseTimePage.dart';
import 'package:untitled/componants/BuildFromField.dart';
import 'BookingPage.dart';

class OTPPage extends StatefulWidget{
  State<OTPPage> createState()=> _OTPPage();
}


class _OTPPage extends State<OTPPage> {
  @override
  final _OTPController = TextEditingController();
  final _TelOrEMailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    double fontsize=32;
    return Scaffold(
      appBar: AppBar(
        title: Text("หน้าลงทะเบียน"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              // color: Colors.red,
              padding: EdgeInsetsGeometry.all(50.0),

              child:Container(
                child: Column(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .center,
                  children: [

                    BuildFormField(
                        label: 'เบอร์โทรศัพท์หรืออีเมล',
                        controller: _TelOrEMailController,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'กรุณากรอก เบอร์โทรศัพท์หรืออีเมล';
                          }
                          return null;
                        }),

                    BuildFormField(
                        label: 'OTP',
                        controller: _OTPController,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'กรุณากรอก OTP';
                          }
                          return null;
                        }),


                    Container(
                      // color: Colors.orange,
                      alignment: AlignmentDirectional.bottomEnd,
                      child: TextButton(onPressed: (){
                        if(_formKey.currentState!.validate()){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChoseTimePage()));
                        }
                      }, child: Text("ยืนยัน",style: TextStyle(fontSize: fontsize),))
                    ),

                  ],
                ),
              )


            ),
          ),
        ),
      ),
    );

  }
  @override
  void dispose(){
    _OTPController.dispose();
    _TelOrEMailController.dispose();
    super.dispose();
  }
}
