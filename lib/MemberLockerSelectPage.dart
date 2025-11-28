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
  List<Map<String, dynamic>> lockerStatus = [];

  bool _showGrid = false;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      //call API to get locker
      _loadLocker();
      Future.delayed(const Duration(microseconds: 50),(){

        if(mounted) setState(() => _showGrid = true);
      });
    });
  }

  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _loadLocker() async {
    setState(() => _isLoading = true);

    try {
      final result = await _apiService.getLocker();

      if (!mounted) return;

      if (result['success']) {
        setState(() {
          if (result['data'] is List) {
            lockerStatus = List<Map<String, dynamic>>.from(result['data']);
          } else {
            lockerStatus = [result['data'] as Map<String, dynamic>];
          }
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: ${result['error']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      print('Error loading lockers: $e');
    }
  }
  double fontsize = 32;
  String? selectedLocker;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าปลดล็อคตู้ล็อคเกอร์'),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _showGrid
          ? body()
          : const SizedBox.shrink(),
    );
  }

  Widget body(){
    return Stack(
      children: [
        SingleChildScrollView(
          child: Center(
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
                lockerZone(),
                ?selectedBox(),
                SizedBox(height: 50),
                confirmButton(),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget confirmButton(){
    return BuildConfirmButton(
      alignment: AlignmentGeometry.center,
      onPressed: () {
        _handleUnlockMember();
      },
      fontsize: fontsize,
      lable: 'จอง',
    );
  }

  Widget? selectedBox() {
    if (selectedLocker == null || selectedLocker!.isEmpty) return null;

    try {
      final locker = lockerStatus.firstWhere(
            (l) => l['id'] == int.parse(selectedLocker!),
        orElse: () => {},
      );

      if (locker.isEmpty) return null;

      String displayName = locker['name'] ?? '';
      // print(displayName);
      return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'เลือกตู้: $displayName',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      );
    } catch (e) {
      print('Error parsing selectedLocker: $e');
      return null;
    }
  }

  Widget lockerZone(){
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate max width to force 3 columns
        final double maxWidth = (constraints.maxWidth - 100 * 2 - 10 * 2) / 3;
        return GridView.extent(
          maxCrossAxisExtent: maxWidth, // ✅ Dynamic based on screen width
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          padding: const EdgeInsets.all(100),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          cacheExtent: 0,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: true,
          children: lockerStatus.map((entry) {
            return BuildLockerBox(
              selectedLocker: selectedLocker,
              lockerStatus: entry,
              onTap: _onLockerTap,
            );
          }).toList(),
        );
      },
    );
  }

  void _onLockerTap(String lockerId, bool isAvailable) {
    if (isAvailable) {
      setState(() => selectedLocker = lockerId);
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
          print(result);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('เกิดข้อผิดพลาด ข้อมูลที่ส่งไปไม่ตรงกับ backend : ${result['error']}'),
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
