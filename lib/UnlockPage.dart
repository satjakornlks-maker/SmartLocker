import 'package:flutter/material.dart';
import 'package:untitled/componants/BuildConfirmButton.dart';
import 'FillPINPage.dart';
import 'componants/BuildLegend.dart';
import 'componants/BuildLockerBox.dart';
import 'services/api_service.dart';

class UnlockPage extends StatefulWidget {
  const UnlockPage({super.key});

  @override
  State<UnlockPage> createState() => _UnlockPage();
}

class _UnlockPage extends State<UnlockPage> {
  String? selectedLocker;
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  List<Map<String, dynamic>> lockerStatus = [];

  bool _showGrid = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //call API to get locker
      _loadLocker();
      Future.delayed(const Duration(microseconds: 50), () {
        if (mounted) setState(() => _showGrid = true);
      });
    });
  }

  Future<void> _loadLocker() async {
    setState(() => _isLoading = true);

    try {
      final result = await _apiService.getLocker();

      if (!mounted) return;

      if (result['success']) {
        print(result);
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

  Widget body() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .center,
          children: [
            SizedBox(height: 100),
            Text('เลือกตู้ล็อคเกอร์', style: TextStyle(fontSize: fontsize)),
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
    );
  }

  Widget lockerZone() {
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

  Widget confirmButton() {
    return BuildConfirmButton(
      alignment: AlignmentGeometry.center,
      onPressed: _handleUnlock,
      fontsize: fontsize,
      lable: 'ปลดล็อค',
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

  void _handleUnlock() {
    if (selectedLocker != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FillPinPage(lockerId: selectedLocker!),
        ),
      );
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
