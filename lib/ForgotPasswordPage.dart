import 'package:flutter/material.dart';
import 'package:untitled/componants/BuildConfirmButton.dart';
import 'package:untitled/validators/validator.dart';
import 'componants/BuildFromField.dart';
import 'services/api_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String? lockerId;
  const ForgotPasswordPage({super.key, this.lockerId});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _TelOrEmailController = TextEditingController();
  final _OTPController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  double fontsize = 32;
  String? refcode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าลืมรหัสผ่าน'),
        backgroundColor: Colors.blue,
      ),
      body: body(),
    );
  }

  Widget body(){
    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                margin: EdgeInsets.all(60),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    telOrEmailField(),
                    sendOTPButton(),
                    OTPfield(),
                    confirmButton(),
                    const SizedBox(height: 20,),
                    ?refCodeZone(),
                    const SizedBox(height: 20,)
                  ],
                ),
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
    );
  }

  Widget confirmButton(){
    return BuildConfirmButton(
        label:'ยืนยัน',
        onPressed: (){
          if (_formKey.currentState!.validate()) {
            _handleSubmitOTP();
          }
        }, fontSize: fontsize);
  }

  Widget sendOTPButton(){
    return BuildConfirmButton(onPressed: (){
      String? validatorError = Validators.validateEmailOrPhone(
        _TelOrEmailController.text,
      );
      if (validatorError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validatorError)),
        );
        return;
      } else {
        _handleSendOTPForgotPassword();
      }},
        fontSize: fontsize,
        label: 'ส่ง OTP');
  }

  Widget? refCodeZone(){
    if(refcode != null) {
      return Container(
        alignment: .center,
        child: Text(
          'refer code : $refcode!', style: TextStyle(fontSize: fontsize, color: Colors.blue),),
      );
    }
    return null;
  }

  Widget OTPfield(){
    return BuildFormField(
        label: 'OPT',
        controller: _OTPController,
        keyboardType: TextInputType.number,
        validator: Validators.validateOTP
    );
  }

  Widget telOrEmailField(){
    return BuildFormField(
        label: 'เบอร์โทรหรืออีเมลที่ลงทะเบียน',
        controller: _TelOrEmailController,
        validator: Validators.validateEmailOrPhone
    );
  }

  Future<void> _handleSendOTPForgotPassword() async {
    setState(() => _isLoading = true);
    String cleanValue = _TelOrEmailController.text.replaceAll(' ', '');
    try {
      final result = await _apiService.handleForgotPassword(
        cleanValue,
        cleanValue.contains('@'),
        widget.lockerId

      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ส่ง OTP สำเร็จ')));
        refcode = result['data']['refercode'];
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด : ${result['error']}')),
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
  }

  Future<void> _handleSubmitOTP() async {
    setState(() => _isLoading = true);
    String cleanValue = _TelOrEmailController.text.replaceAll(' ', '');
    try {
      final result = await _apiService.handleSubmitOTP(
        cleanValue,
        _OTPController.text,
        cleanValue.contains('@'),
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ยืนยัน OTP สำเร็จ')));
        Navigator.of(
          context,
        ).pop(context);
        // _OTPController.clear();
        // _TelOrEmailController.clear();

      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด : ${result['error']}')),
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
  }

  @override
  void dispose() {
    _TelOrEmailController.dispose();
    _OTPController.dispose();
    super.dispose();
  }
}
