import 'package:flutter/material.dart';
import 'package:untitled/OTPPage.dart';
import 'componants/BuildLegend.dart';
import 'componants/BuildLockerBox.dart';

class EmergencyUnlockPage extends StatefulWidget {
  @override
  State<EmergencyUnlockPage> createState() => _EmergencyUnlockPage();
}

class _EmergencyUnlockPage extends State<EmergencyUnlockPage> {
  String? selectedLocker;
  final Map<String, bool> lockerStatus = {
    'A1': true,
    'A2': true,
    'A3': false,
    'A4': true,
    'A5': true,
    'A6': true,
    'A7': true,
    'A8': true,
    'A9': false,
  };
  double fontsize = 32;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าจองตู้ล็อคเกอร์'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .center,
              children: [
                SizedBox(height: 100),
                Text('เลือกตู้ล็อคเกอร์', style: TextStyle(fontSize: fontsize)),
                SizedBox(height: 50),

                BuildLegend(),
                SizedBox(height: 30),

                Container(
                  child: GridView.builder(
                    padding: EdgeInsets.all(100),

                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    shrinkWrap: true,
                    itemCount: lockerStatus.length,
                    itemBuilder: (context, index) {
                      String lockerId = 'A${index + 1}';
                      return BuildLockerBox(
                        lockerId: lockerId,
                        selectedLocker: selectedLocker,
                        lockerStatus: lockerStatus,
                        onTap: _onLockerTap,
                      );
                    },
                  ),
                ),
                SizedBox(height: 30),

                if (selectedLocker != null)
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'เลือกตู้: $selectedLocker',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                SizedBox(height: 50),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: TextButton(
                        onPressed: () {

                        },
                        child: Text(
                          'เปิด',
                          style: TextStyle(fontSize: fontsize),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: TextButton(
                        onPressed: () {

                        },
                        child: Text(
                          'ปิด',
                          style: TextStyle(fontSize: fontsize),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLockerTap(String lockerId, bool isAvailable) {
    if (isAvailable) {
      setState(() => selectedLocker = lockerId);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ตู้ $lockerId ไม่ว่าง')));
    }
  }

}
