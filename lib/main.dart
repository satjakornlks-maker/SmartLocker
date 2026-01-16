import 'package:flutter/material.dart';
import 'dart:async';

// Screens - Locker
import 'screens/locker/locker_selection_page.dart';

// Screens - Common
import 'screens/common/otp_page.dart';

// Screens - Auth
import 'screens/auth/reset_password_page.dart';

// Screens - Admin
import 'screens/admin/emergency_unlock_page.dart';
import 'screens/admin/approve_periodic_user_page.dart';

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
        '/booking': (context) => const LockerSelectionPage(mode: LockerSelectionMode.booking),
        '/unlock': (context) => const LockerSelectionPage(mode: LockerSelectionMode.unlock),
        '/member-locker-select': (context) => const LockerSelectionPage(mode: LockerSelectionMode.memberSelect),
        '/reset-password': (context) => const ResetPasswordPage(),
        '/emergency-unlock': (context) => const EmergencyUnlockPage(),
        '/instance-use': (context) => const OTPPage(mode: OTPPageMode.quickRegistration),
        '/periodic-approve': (context) => const ApprovePeriodicUserPage(),
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
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                margin: MediaQuery.of(context).size.width > 600
                    ? const EdgeInsets.fromLTRB(300, 0, 300, 0)  // Tablet: add margin
                    : EdgeInsets.zero,
                child: Column(

                  children: [
                    // Header Section
                    _buildHeader(),

                    // Menu Buttons - Row with 2 cards
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (_) {
                              _emergencyTimer = Timer(
                                const Duration(seconds: 5),
                                    () => Navigator.pushNamed(context, '/periodic-approve'),
                              );
                            },
                            onTapUp: (_) => _emergencyTimer?.cancel(),
                            onTapCancel: () => _emergencyTimer?.cancel(),
                            child: _buildSmallMenuCard(
                              'ลงทะเบียนด่วน',
                              'Quick Registration',
                              Icons.flash_on_rounded,
                              Colors.orange,
                                  () => Navigator.pushNamed(context, '/instance-use'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (_) {
                              _emergencyTimer = Timer(
                                const Duration(seconds: 5),
                                    () => Navigator.pushNamed(context, '/emergency-unlock'),
                              );
                            },
                            onTapUp: (_) => _emergencyTimer?.cancel(),
                            onTapCancel: () => _emergencyTimer?.cancel(),
                            child: _buildSmallMenuCard(
                              'ลงทะเบียน',
                              'Registration',
                              Icons.app_registration_rounded,
                              Colors.blue,
                              _handleBooking,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildSmallMenuCard(
                            'ปลดล็อค',
                            'Unlock Locker',
                            Icons.lock_open_rounded,
                            Colors.green,
                                () => Navigator.pushNamed(context, '/unlock'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSmallMenuCard(
                            'สมัครสมาชิก',
                            'Member Registration',
                            Icons.card_membership_rounded,
                            Colors.purple,
                                () => Navigator.pushNamed(context, '/member-locker-select'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    _buildMenuCard(
                      'เปลี่ยนรหัสผ่าน',
                      'Reset Password',
                      Icons.password_rounded,
                      Colors.red,
                          () => Navigator.pushNamed(context, '/reset-password'),
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    // Get screen width to determine device type
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    // Adjust sizes based on device
    final logoSize = isTablet ? 150.0 : 100.0;
    final fontSize = isTablet ? 26.0 : 20.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image(
          image: AssetImage('assets/images/Logo.png'),
          width: logoSize,
          height: logoSize,
        ),
        Text(
          'Smart Locker',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  // Small cards for the row (2 cards side by side)
  Widget _buildSmallMenuCard(
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
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      icon,
                      size: 36,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    titleTh,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    titleEn,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Full-width cards
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
    Navigator.pushNamed(context, '/booking');
  }

  @override
  void dispose() {
    _emergencyTimer?.cancel();
    super.dispose();
  }
}