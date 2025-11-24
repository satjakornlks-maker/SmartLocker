import 'package:flutter/material.dart';
import 'package:untitled/BookingPage.dart';
import 'package:untitled/EmergencyUnlockPage.dart';
import 'package:untitled/RegisterPage.dart';
import 'package:untitled/ResetPasswordPage.dart';
import 'UnlockPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flow Prototype'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override

  double fontsize = 32;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: .start,
            children: [
              SizedBox(height: 50),
              _buildMenuButton('ลงทะเบียน', _handleBooking),
              SizedBox(),
              _buildMenuButton('ปลดล็อค', (){
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UnlockPage()),
              );}),
              SizedBox(),
              _buildMenuButton('สมัครสมาชิก(จองใช้ประจำ)', (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              }),
              SizedBox(),
              _buildMenuButton('เปลี่ยนรหัสผ่านสำหรับผู้ใช้ประจำ', (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResetPasswordPage(),
                  ),
                );
              }),
              SizedBox(),
              _buildMenuButton('หน้าปลดล็อคฉุกเฉิน', (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmergencyUnlockPage(),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, VoidCallback onPressed){
    return Container(
      padding: EdgeInsets.all(20),
      child: TextButton(onPressed: onPressed,
          child: Text(text,style: TextStyle(fontSize: fontsize),
          textAlign: TextAlign.center,)),
    );
  }

  Future<void> _handleBooking() async {
    await Future.delayed(Duration.zero);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookingPage()),
    );
  }
}
