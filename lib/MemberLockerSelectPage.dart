import 'package:flutter/material.dart';
import 'package:untitled/NoticePage.dart';
import 'package:untitled/componants/BuildConfirmButton.dart';
import 'componants/BuildLegend.dart';
import 'componants/BuildLockerBox.dart';
import 'services/api_service.dart';

class MemberLockerSelectPage extends StatefulWidget {
  final String name;
  final String tel;
  final String email;
  final String reason;

  const MemberLockerSelectPage({
    super.key,
    required this.name,
    required this.tel,
    required this.email,
    required this.reason,
  });

  @override
  State<MemberLockerSelectPage> createState() => _MemberLockerSelectPage();
}

class _MemberLockerSelectPage extends State<MemberLockerSelectPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    double fontsize = 32;
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าปลดล็อคตู้ล็อคเกอร์'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .center,
                  children: [
                    SizedBox(height: 100),
                    Text(
                      'เลือกตู้ล็อคเกอร์',
                      style: TextStyle(fontSize: fontsize),
                    ),
                    SizedBox(height: 50),

                    BuildLegend(),
                    SizedBox(height: 30),

                    Container(
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
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

                    BuildConfirmButton(
                      alignment: AlignmentGeometry.center,
                      onPressed: () {
                        _handleUnlockMember();
                      },
                      fontsize: fontsize,
                      lable: 'จอง',
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  void _onLockerTap(String lockerId, bool isAvailable) {
    if (isAvailable) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          onVisible: () {
            setState(() => selectedLocker = lockerId);
          },
          content: Text('เลือกตู้ $lockerId '),
          //   action: SnackBarAction(label: 'ยกเลิก', onPressed: (){
          //   setState(()=>selectedLocker = null);
          // }),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ตู้ $lockerId ไม่ว่าง'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _handleUnlockMember() async {
    if (selectedLocker != null) {
      setState(() => _isLoading = true);
      try {
        final result = await _apiService.regisAccount(
          widget.name,
          widget.tel,
          widget.email,
          widget.reason,
          selectedLocker!,
        );
        if (!mounted) return;
        setState(() => _isLoading = false);
        if (result['success']) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('สมัครสมาชิกเสร็จสิ้น')));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoticePage()),
          );
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('เกิดข้อผิดพลาด : ${result['error']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('โปรดเลือกตู้ล็อคเกอร์'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
