import 'package:flutter/material.dart';
import 'package:untitled/screens/Deposite%20Type/deposit_type_page.dart';
import 'package:untitled/screens/common/chose_size_page.dart';
import 'package:untitled/widgets/grid/HoverMenuCard.dart';
import '../input_type_page/input_type_page.dart';

class UserTypePage extends StatefulWidget {
  const UserTypePage({super.key});
  @override
  State<UserTypePage> createState() => _UserTypePage();
}

class _UserTypePage extends State<UserTypePage> {
  static const String systemMode = String.fromEnvironment('TYPE', defaultValue: 'B2C');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildHeader(),
                    const SizedBox(height: 60),

                    // Center content
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'เลือกประเภทของผู้ใช้',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              children: [
                                Expanded(
                                  child: HoverMenuCard(
                                    titleTh: 'พนักงาน',
                                    icon: Icons.home_work,
                                    color: Colors.blue,
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DepositTypePage(),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: HoverMenuCard(
                                    titleTh: 'ผู้เยี่ยมชม',
                                    icon: Icons.person,
                                    color: Colors.blue,
                                    onPressed: () => systemMode == 'B2C'
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChoseSizePage(
                                                    from: FromPage.visitor,
                                                  ),
                                            ),
                                          )
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  InputTypePage(
                                                    from: FromPage.visitor,
                                                  ),
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 60),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'SECURE ACCESS',
                                  style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 2,
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
      child: Row(
        children: [
          // Back button
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'SMART LOCKER',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
