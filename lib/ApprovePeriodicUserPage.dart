import 'package:flutter/material.dart';
import 'services/api_service.dart';

class ApprovePeriodicUserPage extends StatefulWidget{
  const ApprovePeriodicUserPage({super.key});
  @override
  State<ApprovePeriodicUserPage> createState() => _ApprovePeriodicUserPage();

}

class _ApprovePeriodicUserPage extends State<ApprovePeriodicUserPage>{
  bool _isLoading = false;
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> user = [];

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      //call API to get locker
      _loadUser();
    });
  }
  Future<void> _loadUser() async {
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.getPendingUser();
      if (!mounted) return;
      if (result['success']) {
        setState(() {
          if (result['data'] is List) {
            user = List<Map<String, dynamic>>.from(result['data']);
          } else {
            user = [result['data'] as Map<String, dynamic>];
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
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าอนุมัติการลงทะเบียนใช้ประจำ'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Main content
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : user.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'ไม่มีคำขออนุมัติ',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: _loadUser,
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: user.length,
                itemBuilder: (context, index) {
                  final userData = user[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          '${userData['name']?[0] ?? 'U'}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        '${userData['name'] ?? ''} ${userData['lastname'] ?? ''}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text('📞 ${userData['phone_number'] ?? 'ไม่ระบุ'}'),
                          Text('📧 ${userData['email'] ?? 'ไม่ระบุ'}'),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow('ID', '${userData['id']}'),
                              _buildInfoRow('Locker Unit', '${userData['locker_unit_id'] ?? 'ไม่ระบุ'}'),
                              _buildInfoRow('เหตุผล', userData['reason'] ?? 'ไม่ระบุ'),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => _approveUser(
                                        userData['id'],
                                        userData['name'],
                                        userData['lastname'],
                                        userData['locker_unit_id'],
                                        userData['email'],
                                        userData['phone_number']),
                                    icon: Icon(Icons.check),
                                    label: Text('อนุมัติ'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () => _rejectUser(userData['id'],userData['email'],userData['locker_unit_id'],userData['phone_number'],userData['name'],
                                      userData['lastname'],),
                                    icon: Icon(Icons.close),
                                    label: Text('ไม่อนุมัติ'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _approveUser(int userId,String name,String lastName,int lockerId,String email,String tel){
    bool isRejecting = false;
    showDialog(context: context, builder: (context)=>StatefulBuilder(
      builder:(context, setState) =>  PopScope(
        canPop: !isRejecting,
        child: AlertDialog(
          title: Text('ยืนยันการอนุมัติ'),
          content: isRejecting? Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('กำลังดำเนินการ...'),
            ],
          ) : Text('คุณต้องการปฏิเสธคำขอนี้ใช่หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ยกเลิก'),
            ),
            ElevatedButton(onPressed: isRejecting
                ? null
                :()async{
              setState(()=> isRejecting = true);
              try {
                final result = await _apiService.handleAcceptRequest(name, lastName, lockerId.toString(), email, tel);
                if (!mounted) return;
                if(result['success'])
                {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('อนุมัติแล้ว'),backgroundColor: Colors.green,
                  ));
                  Navigator.pop(context);
                  _loadUser();
                }else {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('เกิดข้อผิดพลาด : ${result['error']}')),
                  );
                }
              }catch(e){
                if (!mounted) return;
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
              }
            },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text('อนุมัติ'))
          ],
        ),
      ),
    ));
  }

  void _rejectUser(int userId,String email,int lockerId,String tel,String name, String last_name){
    bool isRejecting = false;
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context)=>StatefulBuilder(
          builder: (context, setState) => PopScope(
            canPop: !isRejecting,
            child: AlertDialog(
                  title: Text('ยืนยันการไม่อนุมัติ'),
                  content: isRejecting? Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text('กำลังดำเนินการ...'),
                    ],
                  ) : Text('คุณต้องการปฏิเสธคำขอนี้ใช่หรือไม่?'),
                  actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('ยกเลิก'),
            ),
            ElevatedButton(onPressed: isRejecting
                ? null
                :()async{
              setState(()=> isRejecting = true);
              //API func
              try {
              final result = await _apiService.handleRejectRequest(lockerId.toString(), email,tel,name,last_name);
              if (!mounted) return;
              if(result['success'])
              {
                if (!mounted) return;
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ไม่อนุมัติแล้ว'),backgroundColor: Colors.red,
                ));
                Navigator.pop(context);
                _loadUser();
              }else {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('เกิดข้อผิดพลาด : ${result['error']}')),
                );
              }
              }catch(e){
                if (!mounted) return;
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
              }
            },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('ไม่อนุมัติ'))
                  ],
                ),
          ),
        ));
  }

}