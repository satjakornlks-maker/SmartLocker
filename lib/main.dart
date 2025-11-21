import 'package:flutter/material.dart';
import 'package:untitled/BookingPage.dart';
import 'package:untitled/RegisterPage.dart';
import 'package:untitled/ResetPasswordPage.dart';
import 'OTPPage.dart';
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
  Widget build(BuildContext context) {
    double fontsize = 32;
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
              SizedBox(height: 100),
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookingPage()),
                    );
                  },
                  child: Text(
                    'ลงทะเบียน',
                    style: TextStyle(fontSize: fontsize),
                  ),
                ),
              ),
              SizedBox(),
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UnlockPage()),
                    );
                  },
                  child: Text('ปลดล็อค', style: TextStyle(fontSize: fontsize)),
                ),
              ),
              SizedBox(),
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text(
                    'สมัครสมาชิก(จองใช้ประจำ)',
                    style: TextStyle(fontSize: fontsize),
                  ),
                ),
              ),
              SizedBox(),
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPasswordPage(),
                      ),
                    );
                  },
                  child: Text(
                    'เปลี่ยนรหัสผ่านสำหรับผู้ใช้ประจำ',
                    style: TextStyle(fontSize: fontsize),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
