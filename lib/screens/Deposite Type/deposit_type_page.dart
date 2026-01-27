import 'package:flutter/material.dart';
import 'package:untitled/screens/input_type_page/input_type_page.dart';
import 'package:untitled/screens/locker/locker_selection_page.dart';
import 'package:untitled/widgets/grid/HoverMenuCard.dart';

class DepositTypePage extends StatefulWidget {
  const DepositTypePage({super.key});

  @override
  State<DepositTypePage> createState() => _DepositTypePageState();
}

class _DepositTypePageState extends State<DepositTypePage> {
  String? selectedType; // Track selected type: 'login' or 'member'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                // Header with back button
                _buildHeader(),

                const SizedBox(height: 40),

                // Center content
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        // Title
                        const Text(
                          'กรุณาเลือกวิธีการเข้าใช้งาน',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Two cards row
                        Row(
                          children: [
                            Expanded(
                              child: _buildSelectionCard(
                                title: 'เลือกตู้',
                                icon: Icons.login_rounded,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LockerSelectionPage(
                                          mode: LockerSelectionMode.booking,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _buildSelectionCard(
                                title: 'จองด่วน',
                                icon: Icons.flash_on_rounded,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InputTypePage(
                                      from: FromPage.instance,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // Quick registration button
                        _buildQuickRegistrationButton(),
                        const SizedBox(height: 60),
                        // Secure access text
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
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Back button
        Container(
          margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
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
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap, // Add onTap callback parameter
  }) {
    return GestureDetector(
      onTap: onTap, // Use the callback directly
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Builder(
          builder: (context) {
            final isHovered = ValueNotifier<bool>(false);

            return ValueListenableBuilder<bool>(
              valueListenable: isHovered,
              builder: (context, hovered, child) {
                return MouseRegion(
                  onEnter: (_) => isHovered.value = true,
                  onExit: (_) => isHovered.value = false,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(100),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: hovered
                            ? Colors.yellow.shade700
                            : Colors.grey.shade300,
                        width: hovered ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: hovered ? 0.1 : 0.05,
                          ),
                          blurRadius: hovered ? 15 : 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: hovered
                                ? Colors.yellow.shade100
                                : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            size: 40,
                            color: hovered
                                ? Colors.yellow.shade700
                                : Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Title
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: hovered
                                ? Colors.yellow.shade700
                                : Colors.black87,
                          ),
                          child: Text(title),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuickRegistrationButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade700.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LockerSelectionPage(mode: LockerSelectionMode.memberSelect),
            ),
          ),
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_rounded,
                      color: Colors.black87,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ลงทะเบียนพนักงาน (ใช้งานประจำ)',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
