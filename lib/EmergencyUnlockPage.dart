import 'package:flutter/material.dart';
import 'package:untitled/componants/BuildConfirmButton.dart';
import 'componants/BuildLegend.dart';
import 'componants/BuildLockerBox.dart';
import 'services/api_service.dart';

class EmergencyUnlockPage extends StatefulWidget {
  const EmergencyUnlockPage({super.key});

  @override
  State<EmergencyUnlockPage> createState() => _EmergencyUnlockPage();
}

class _EmergencyUnlockPage extends State<EmergencyUnlockPage> {
  String? selectedLocker;
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

  static const double fontsize = 32;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("หน้าปลดล็อคฉุกเฉิน"),
        backgroundColor: Colors.blue,
      ),
      body:  _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _showGrid
          ? body()
          : const SizedBox.shrink(),
    );
  }

  Widget body() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .center,
              children: [
                const SizedBox(height: 100),
                const Text(
                  'เลือกตู้ล็อคเกอร์',
                  style: const TextStyle(fontSize: fontsize),
                ),
                const SizedBox(height: 50),
                BuildLegend(),
                const SizedBox(height: 30),
                lockerZone(),
                const SizedBox(height: 30),
                ?selectedBox(),
                const SizedBox(height: 20,),
                commandButton(),
                const SizedBox(height: 40),
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

  Widget commandButton(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BuildConfirmButton(
          onPressed: () {
            _isLoading ? null : _handleOrder();
          },
          fontsize: fontsize,
          lable: 'เปิด',
        ),
        SizedBox(height: 10),
      ],
    );
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
    setState(() => selectedLocker = lockerId);
  }



  Future<void> _handleOrder() async {
    if (selectedLocker == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('โปรดเลือกตู้ล็อคเกอร์')));
      return;
    }
    setState(() => _isLoading = true);

    try {
      final result = await _apiService.handleEmergency(selectedLocker!);
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ประตูล็อคเกอร์เปิด')));
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด : $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
}
