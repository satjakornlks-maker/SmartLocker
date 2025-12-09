import 'package:flutter/material.dart';
import 'services/api_service.dart';

class OverTimePage extends StatefulWidget{
  @override
  State<OverTimePage> createState()=> _OverTimePage();
  final String day;
  final String hour;
  final String minute;
  final String second;
  final String lockerId;

  const OverTimePage({super.key, required this.second, required this.day, required this.hour, required this.minute, required this.lockerId});
}

class _OverTimePage extends State<OverTimePage>{
  ApiService _apiService = ApiService();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าแจ้งล่วงเวลา'),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: .center,
              mainAxisAlignment: .center,

              children: [
                SizedBox(height: 50,),
                Container(
                    alignment: .center,
                    child: Text('ท่านได้ทำการปลดล็อกเกินเวลาจองมาแล้ว ${widget.day} วัน ${widget.hour} ชั่วโมง ${widget.minute} นาที ${widget.second} วินาที',textAlign: TextAlign.center,style: TextStyle(color: Colors.red,fontSize: 30),))
                ,SizedBox(height: 30,),
                TextButton(
                  onPressed: () {
                    _handleCheckStatus();
                  },
                  child: Text('ยืนยัน'),
                ),
                if (isLoading)
                  Container(
                    color: Colors.black54,
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
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