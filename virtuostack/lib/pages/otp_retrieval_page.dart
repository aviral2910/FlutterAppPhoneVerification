import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtuostack/Widget/button_widget.dart';
import 'package:virtuostack/Widget/otpinput_widget.dart';
import 'package:virtuostack/pages/login_byotp_page.dart';

class OtpPage extends StatefulWidget {
  OtpPage(this.currentState, this.showLoading, this.verificationId, {Key? key})
      : super(key: key);
  String verificationId;
  bool showLoading;
  MobileVerificationState currentState;
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  // 4 text editing controllers that associate with the 4 input fields
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();

  // This is the entered code
  // It will be displayed in a Text widget
  String? _otp;
  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      widget.showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        widget.showLoading = false;
      });
      if (authCredential.user != null) {
        Navigator.pushNamed(context, '/home_page');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        widget.showLoading = false;
      });
    }
  }

  void _saveForm() {
    setState(() {
      _otp = _fieldOne.text +
          _fieldTwo.text +
          _fieldThree.text +
          _fieldFour.text +
          _fieldFive.text +
          _fieldSix.text;

      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId, smsCode: _otp.toString());
      signInWithPhoneAuthCredential(phoneAuthCredential);
      widget.currentState = MobileVerificationState.SHOW_MOBILE_STATE;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Verify your phone',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 40,
            ),
            // Implement 4 input fields
            const Text('Enter Code',
                style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.purple)),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OtpInput(_fieldOne, true),
                OtpInput(_fieldTwo, false),
                OtpInput(_fieldThree, false),
                OtpInput(_fieldFour, false),
                OtpInput(_fieldFive, false),
                OtpInput(_fieldSix, false)
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Button("VERIFY", _saveForm),
            ),
            const SizedBox(
              height: 30,
            ),
            // Display the entered OTP code
            // Text(
            //   _otp ?? 'Please enter OTP',
            //   style: const TextStyle(fontSize: 30),
            // )
          ],
        ),
      ),
    );
  }
}
