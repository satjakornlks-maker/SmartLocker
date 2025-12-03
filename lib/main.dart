import 'package:flutter/material.dart';
import 'package:untitled/ApprovePeriodicUserPage.dart';
import 'package:untitled/BookingPage.dart';
import 'package:untitled/EmergencyUnlockPage.dart';
import 'package:untitled/InstanceUse.dart';
import 'package:untitled/RegisterPage.dart';
import 'package:untitled/ResetPasswordPage.dart';
import 'UnlockPage.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Flow Prototype'),
        '/booking': (context) => const BookingPage(),
        '/unlock': (context) => const UnlockPage(),
        '/register': (context) => const RegisterPage(),
        '/reset-password': (context) => const ResetPasswordPage(),
        '/emergency-unlock': (context) => const EmergencyUnlockPage(),
        '/instance-use': (context) => const InstanceUse(),
        '/periodic-approve':(context) => const ApprovePeriodicUserPage(),
      },
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

  double fontsize = 32;
  Timer? _emergencyTimer;
  @override

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
              GestureDetector(
                  onTapDown: (_){
                    _emergencyTimer = Timer(Duration(seconds: 5), (){Navigator.pushNamed(context, '/periodic-approve');});
                  },
                  onTapUp: (_)=> _emergencyTimer?.cancel(),
                  onTapCancel: ()=> _emergencyTimer?.cancel(),
                  child: _buildMenuButton('ลงทะเบียนด่วน', (){Navigator.pushNamed(context, '/instance-use');})),
              SizedBox(),
              GestureDetector(
                 onTapDown: (_){
                   _emergencyTimer = Timer(Duration(seconds: 5), (){Navigator.pushNamed(context, '/emergency-unlock');});
                 },
                  onTapUp: (_)=> _emergencyTimer?.cancel(),
                  onTapCancel: ()=> _emergencyTimer?.cancel(),
                  child: _buildMenuButton('ลงทะเบียน', _handleBooking)),
              SizedBox(),
              _buildMenuButton('ปลดล็อค', (){
                Navigator.pushNamed(context, '/unlock'
              );}),
              SizedBox(),
              _buildMenuButton('สมัครสมาชิก(จองใช้ประจำ)', (){
                Navigator.pushNamed(context, '/register');
              }),
              SizedBox(),
              _buildMenuButton('เปลี่ยนรหัสผ่านสำหรับผู้ใช้ประจำ', (){
                Navigator.pushNamed(context, '/reset-password');
              }),
              // SizedBox(),
              // _buildMenuButton('หน้าปลดล็อคฉุกเฉิน', (){
              //   Navigator.pushNamed(context, '/emergency-unlock');
              // })
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
