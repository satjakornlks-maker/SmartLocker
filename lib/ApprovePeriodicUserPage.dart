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
  List<Map<String, dynamic>> filteredUser = [];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterStatus = 'all';

  @override
  void initState(){
    super.initState();
      _loadUser();
      _searchController.addListener(_onSearchChaged);
  }

  @override
  void dispose(){
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChaged(){
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _applyFilters();
    });
  }

  void _applyFilters(){
    filteredUser = user.where((userData) {
      // Search filter
      final name = '${userData['name']} ${userData['lastname']}'.toLowerCase();
      final email = (userData['email'] ?? '').toLowerCase();
      final phone = (userData['phone_number'] ?? '').toLowerCase();
      final locker = (userData['locker_unit_id']?.toString() ?? '').toLowerCase();

      final matchesSearch = name.contains(_searchQuery) ||
          email.contains(_searchQuery) ||
          phone.contains(_searchQuery) ||
          locker.contains(_searchQuery);

      // Status filter
      bool matchesStatus = true;
      if (_filterStatus == 'pending') {
        matchesStatus = userData['approve_status'] == null;
      } else if (_filterStatus == 'approved') {
        matchesStatus = userData['approve_status'] == true;
      } else if (_filterStatus == 'rejected') {
        matchesStatus = userData['approve_status'] == false;
      }

      return matchesSearch && matchesStatus;
    }).toList();
  }
  Future<void> _loadUser() async {
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.getPendingUser();
      if (!mounted) return;
      if (result['success']) {
        print(result);
        setState(() {
          if (result['data'] is List) {

            user = List<Map<String, dynamic>>.from(result['data']);
          } else {
            user = [result['data'] as Map<String, dynamic>];
          }
          _applyFilters();
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
        actions: [
          IconButton(onPressed: _showFilterDialog, icon: Icon(Icons.filter_list))
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Padding(padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          child: Align(
            alignment: AlignmentGeometry.centerLeft,
            child: Text('พบ ${filteredUser.length} รายการ',
            style: TextStyle(color: Colors.grey[600],fontSize: 14),),
          ),),
          Expanded(child: body()),
        ],
      )
    );
  }

  Widget _buildSearchBar(){
    return Padding(padding: EdgeInsetsGeometry.all(12),
    child: TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'ค้นหาชื่อ, อีเมล, เบอร์โทร, Locker...',
        prefixIcon: Icon(Icons.search),
        suffixIcon: _searchQuery.isNotEmpty
          ? IconButton(onPressed: (){
            _searchController.clear();
        }, icon: Icon(Icons.clear),
        ):null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(vertical: 12),
    ),),);
  }

  Widget _buildFilterChips(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _buildFilterChip('ทั้งหมด', 'all', user.length),
          SizedBox(width: 8,),
          _buildFilterChip('รออนุมัติ', 'pending', user.where((u)=> u['approve_status'] == null).length),
          SizedBox(width: 8,),
          _buildFilterChip('อนุมัติแล้ว', 'approved', user.where((u)=>u['approve_status']==true).length),
          SizedBox(width: 8,),
          _buildFilterChip('ไม่อนุมัติ', 'rejected', user.where((u)=>u['approve_status']==false).length),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, int count){
    final isSelected = _filterStatus == value;
    return FilterChip(label: Text('$label ($count)'),
        selected: isSelected,
        onSelected: (selected){
          setState(() {
            _filterStatus = value;
            _applyFilters();
          });
        },
    backgroundColor: Colors.grey[200],
    selectedColor: Colors.blue[100],
    checkmarkColor: Colors.blue,
    labelStyle: TextStyle(
      fontWeight: isSelected?FontWeight.bold:FontWeight.normal,
    ),);
  }

  void _showFilterDialog(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('ตัวกรอง'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<String>
              (segments: [
                ButtonSegment(value: 'all', label: Text('ทั้งหมด')),
            ButtonSegment(value: 'pending', label: Text('รออนุมัติ')),
            ButtonSegment(value: 'approved', label: Text('อนุมัติแล้ว')),
            ButtonSegment(value: 'rejected', label: Text('ไม่อนุมัติ')),
          ], selected: {_filterStatus},
        onSelectionChanged: (Set<String> selected){
                setState(() {
                  _filterStatus = selected.first;
                  _applyFilters();
                });
                Navigator.pop(context);
    },),],
                ),
              ),
    );
  }

  Widget body(){
    return Stack(
      children: [
        // Main content
        _isLoading
            ? Center(child: CircularProgressIndicator())
            : filteredUser.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                _searchQuery.isEmpty && _filterStatus == 'all'?
                'ไม่มีคำขออนุมัติ':'ไม่พบผลการค้นหา',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              if(_searchQuery.isNotEmpty || _filterStatus!='all')
                TextButton(
                    onPressed: (){
                      setState(() {
                        _searchController.clear();
                        _filterStatus = 'all';
                        _applyFilters();
                      });
                    }, child: Text('ล้างการค้นหา'))
            ],
          ),
        )
            : RefreshIndicator(
          onRefresh: _loadUser,
          child: _buildListview(),
        ),
      ],
    );
  }

  Widget _buildListview(){
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: filteredUser.length,
      itemBuilder: (context, index) {
        final userData = filteredUser[index];
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
                _buildStatusChip(userData['approve_status']),
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
                              userData['id']),
                          icon: Icon(Icons.check),
                          label: Text('อนุมัติ',style: TextStyle(color: Colors.white),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _rejectUser(userData['id']),
                          icon: Icon(Icons.close),
                          label: Text('ไม่อนุมัติ',style: TextStyle(color: Colors.white),),
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

  Widget _buildStatusChip(dynamic status) {
    String emoji;
    String text;
    Color bgColor;
    Color textColor;

    if (status == null) {
      emoji = '⏳';
      text = 'รอการอนุมัติ';
      bgColor = Colors.amber;
      textColor = Colors.brown[900]!;
    } else if (status == true) {
      emoji = '✅';
      text = 'อนุมัติแล้ว';
      bgColor = Colors.teal;
      textColor = Colors.white;
    } else {
      emoji = '❌';
      text = 'ไม่อนุมัติ';
      bgColor = Colors.pink;
      textColor = Colors.white;
    }

    return Chip(
      label: Text(
        '$emoji $text',
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: bgColor,
      padding: EdgeInsets.symmetric(horizontal: 8),
    );
  }

  void _approveUser(int userId){
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
          ) : Text('คุณต้องการอนุมัติคำขอนี้ใช่หรือไม่?'),
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
                final result = await _apiService.handleAcceptRequest(userId);
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

  void _rejectUser(int userId){
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
              final result = await _apiService.handleRejectRequest(userId);
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