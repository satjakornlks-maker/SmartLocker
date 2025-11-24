import 'package:flutter/material.dart';
import 'componants/BuildLegend.dart';
import 'componants/BuildLockerBox.dart';
import 'services/api_service.dart';

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
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าจองตู้ล็อคเกอร์'),
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
                    Text('เลือกตู้ล็อคเกอร์', style: TextStyle(fontSize: fontsize)),
                    SizedBox(height: 50),

                    BuildLegend(),
                    SizedBox(height: 30),

                    Container(
                      child: GridView.builder(
                        padding: EdgeInsets.all(100),
                        physics: NeverScrollableScrollPhysics(),
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
                                _isLoading ? null : _handleOrder("open");
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
                              _isLoading ? null : _handleOrder('close');
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
          if(_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }

  void _onLockerTap(String lockerId, bool isAvailable) {
      setState(() => selectedLocker = lockerId);

  }

  Future<void> _handleOrder(String order) async{

    if(selectedLocker == null){
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('โปรดเลือกตู้ล็อคเกอร์')));
    return;
    }
    setState(() => _isLoading = true);

    try{
      final result = await _apiService.handleEmergency(selectedLocker!,order);

      setState(() => _isLoading = false);

      if(result['success']){
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ประตูล็อคเกอร์เปิด')));

      }else{
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด : ${result['error']}'),
        backgroundColor: Colors.red,));
      }
    }catch(e){
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด : $e'),
      backgroundColor: Colors.red,));
    }
  }
}
