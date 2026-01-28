import 'package:flutter/material.dart';
import 'package:untitled/screens/input_type_page/input_type_page.dart';
import 'package:untitled/screens/locker/locker_selection_page.dart';

import '../../widgets/grid/HoverMenuCard.dart';

class ChoseSizePage extends StatefulWidget {
  final LockerSelectionMode? mode;
  final FromPage? from;
  const ChoseSizePage({super.key, this.mode, this.from});

  @override
  State<ChoseSizePage> createState() => _ChoseSizePage();
}

class _ChoseSizePage extends State<ChoseSizePage> {
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
                              'เลือกขนาดของล็อคเกอร์',
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
                                    titleTh: 'S',
                                    icon: Icons.home_work,
                                    color: Colors.blue,
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            widget.mode != null
                                            ? LockerSelectionPage(
                                                mode: widget.mode!,
                                                size: 'small',
                                              )
                                            : InputTypePage(
                                                from: widget.from!,
                                                size: 'small',
                                              ),
                                      ),
                                    ),
                                    haveIcon: false,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: HoverMenuCard(
                                    titleTh: 'M',
                                    icon: Icons.person,
                                    color: Colors.blue,
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            widget.mode != null
                                            ? LockerSelectionPage(
                                                mode: widget.mode!,
                                                size: 'medium',
                                              )
                                            : InputTypePage(
                                                from: widget.from!,
                                                size: 'medium',
                                              ),
                                      ),
                                    ),
                                    haveIcon: false,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: HoverMenuCard(
                                    titleTh: 'L',
                                    icon: Icons.person,
                                    color: Colors.blue,
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            widget.mode != null
                                            ? LockerSelectionPage(
                                                mode: widget.mode!,
                                                size: 'large',
                                              )
                                            : InputTypePage(
                                                from: widget.from!,
                                                size: 'large',
                                              ),
                                      ),
                                    ),
                                    haveIcon: false,
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
