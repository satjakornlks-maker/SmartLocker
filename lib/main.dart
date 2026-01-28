import 'package:flutter/material.dart';
import 'package:untitled/screens/Deposite%20Type/user_type_page.dart';
import 'package:untitled/screens/common/chose_size_page.dart';
import 'package:untitled/screens/common/otp_page.dart';
import 'package:untitled/screens/input_type_page/input_type_page.dart';
import 'package:untitled/widgets/grid/HoverMenuCard.dart';
import 'dart:async';
import 'screens/locker/locker_selection_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartLocker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Smart Locker'),
        '/unlock': (context) => const LockerSelectionPage(mode: LockerSelectionMode.unlock),
        '/user-type-page' : (context) => const UserTypePage(),
        '/otp-unlock-page' : (context) => const OTPPage(from: FromPage.unlock),
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
  Timer? _emergencyTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.grey.shade300),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildHeader() {
    // Get screen width to determine device type
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 940;

    // Adjust sizes based on device
    final logoSize = isTablet ? 150.0 : 150.0;
    final fontSize = isTablet ? 26.0 : 20.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image(
          image: AssetImage('assets/images/Logo.png'),
          width: logoSize,
          height: logoSize,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildHeader(),
              Container(
                margin: const EdgeInsets.fromLTRB(
                  100,
                  0,
                  100,
                  0,
                ), // Tablet: add margin

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ยินดีต้อนรับ', style: TextStyle(fontSize: 40)),
                    SizedBox(height: 5),
                    const Text('เลือกรายการที่ท่านต้องการดำเนินการ'),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: HoverMenuCard(
                            titleTh: 'ฝากของ',
                            icon: Icons.download_outlined,
                            color: Colors.orange,
                            onPressed: () => Navigator.pushNamed(context, '/user-type-page'),
                            aspectRatio: 1.4,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: HoverMenuCard(
                            titleTh :'รับของ',
                            icon : Icons.upload_outlined,
                            color : Colors.blue,
                            onPressed : ()=> Navigator.pushNamed(context, '/unlock'),
                            aspectRatio: 1.4,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "©LANNACOM 2026",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const Text(
                          "SECURE ACCESS",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Small cards for the row (2 cards side by side)

  @override
  void dispose() {
    _emergencyTimer?.cancel();
    super.dispose();
  }
}
