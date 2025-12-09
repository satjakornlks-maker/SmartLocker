import 'package:flutter/material.dart';
import 'services/api_service.dart';
class WaitUserToCloseLockerPage extends StatefulWidget{
  final String lockerId;
  const WaitUserToCloseLockerPage({super.key, required this.lockerId});

  @override
  State<WaitUserToCloseLockerPage> createState()=> _WaitUserToCloseLockerPage();
}

class _WaitUserToCloseLockerPage extends State<WaitUserToCloseLockerPage>{
  final ApiService _apiService = ApiService();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('หน้ารอปิดล็อคเกอร์'),
      backgroundColor: Colors.blue,
      automaticallyImplyLeading: false,),
      body: body(),
    );
  }

  Widget body(){
    return Center(
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
                Text("กรุณาปิดล็อคเกอร์เมื่อฝากของเสร็จเเล้ว",style: TextStyle(fontSize: 32),),
                SizedBox(height: 20,),
                TextButton(onPressed: _handleCheckStatus, child: Text("ยืนยัน"))
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      )
    );
  }

  Future<void> _handleCheckStatus() async {
    setState(() => isLoading = true);
    try {
      final result = await _apiService.handleCheckLockerStatus(
          widget.lockerId
      );
      if (!mounted) return;
      setState(() => isLoading = false);
      if (result['success'] && result['data']['lockStatus'] == 'Locked') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ดำเนินการเสร็จสิ้น')));
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if(result['success'] && result['data']['lockStatus'] == 'Unlocked'){
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ล็อคเกอร์ยังปิดไม่สนิท')));
      }
      else{
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด : ${result['error']}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    }
  }
}