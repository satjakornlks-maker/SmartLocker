import 'package:flutter/material.dart';
import 'package:untitled/ApprovePeriodicUserPage.dart';
import 'package:untitled/BookingPage.dart';
import 'package:untitled/EmergencyUnlockPage.dart';
import 'package:untitled/InstanceUse.dart';
import 'package:untitled/MemberLockerSelectPage.dart';
import 'package:untitled/ResetPasswordPage.dart';
import 'UnlockPage.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
        '/booking': (context) => const BookingPage(),
        '/unlock': (context) => const UnlockPage(),
        '/reset-password': (context) => const ResetPasswordPage(),
        '/emergency-unlock': (context) => const EmergencyUnlockPage(),
        '/instance-use': (context) => const InstanceUse(),
        '/periodic-approve': (context) => const ApprovePeriodicUserPage(),
        '/member-locker-select-page': (context) => const MemberLockerSelectPage()
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade400,
              Colors.deepPurple.shade700,
              Colors.indigo.shade800,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  // Header Section
                  _buildHeader(),
                  const SizedBox(height: 40),
                  // Menu Buttons
                  GestureDetector(
                    onTapDown: (_) {
                      _emergencyTimer = Timer(
                        const Duration(seconds: 5),
                            () => Navigator.pushNamed(context, '/periodic-approve'),
                      );
                    },
                    onTapUp: (_) => _emergencyTimer?.cancel(),
                    onTapCancel: () => _emergencyTimer?.cancel(),
                    child: _buildMenuCard(
                      'ลงทะเบียนด่วน',
                      'Quick Registration',
                      Icons.flash_on_rounded,
                      Colors.orange,
                          () => Navigator.pushNamed(context, '/instance-use'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTapDown: (_) {
                      _emergencyTimer = Timer(
                        const Duration(seconds: 5),
                            () => Navigator.pushNamed(context, '/emergency-unlock'),
                      );
                    },
                    onTapUp: (_) => _emergencyTimer?.cancel(),
                    onTapCancel: () => _emergencyTimer?.cancel(),
                    child: _buildMenuCard(
                      'ลงทะเบียน',
                      'Registration',
                      Icons.app_registration_rounded,
                      Colors.blue,
                      _handleBooking,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMenuCard(
                    'ปลดล็อค',
                    'Unlock Locker',
                    Icons.lock_open_rounded,
                    Colors.green,
                        () => Navigator.pushNamed(context, '/unlock'),
                  ),
                  const SizedBox(height: 16),
                  _buildMenuCard(
                    'สมัครสมาชิก',
                    'Member Registration ',
                    Icons.card_membership_rounded,
                    Colors.purple,
                        () => Navigator.pushNamed(context, '/member-locker-select-page'),
                  ),
                  const SizedBox(height: 16),
                  _buildMenuCard(
                    'เปลี่ยนรหัสผ่าน',
                    'Reset Password ',
                    Icons.password_rounded,
                    Colors.red,
                        () => Navigator.pushNamed(context, '/reset-password'),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Image(
          image:AssetImage('assets/images/Logo.png'),
          width: 400.0,
          height: 200.0,
        ),
        const Text(
          'Smart Locker',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard(
      String titleTh,
      String titleEn,
      IconData icon,
      Color color,
      VoidCallback onPressed,
      ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white.withValues(alpha: 0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      icon,
                      size: 40,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titleTh,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          titleEn,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleBooking() async {
    await Future.delayed(Duration.zero);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BookingPage()),
    );
  }

  @override
  void dispose() {
    _emergencyTimer?.cancel();
    super.dispose();
  }
}