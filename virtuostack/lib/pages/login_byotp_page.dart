import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtuostack/Widget/button_widget.dart';
import 'package:virtuostack/Widget/input_form_field.dart';
import 'package:virtuostack/Widget/phone_number_input.dart';
import 'package:virtuostack/pages/otp_retrieval_page.dart';

enum MobileVerificationState { SHOW_MOBILE_STATE, SHOW_OTP_STATE }

class LoginByOTP extends StatefulWidget {
  const LoginByOTP({Key? key}) : super(key: key);

  @override
  State<LoginByOTP> createState() => _LoginByOTPState();
}

class _LoginByOTPState extends State<LoginByOTP> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_STATE;

  final TextEditingController _userPhoneNumber = TextEditingController();
  final GlobalKey<FormState> _inputformKey = GlobalKey();

  final FirebaseAuth _auth = FirebaseAuth
      .instance; //this will provide instance So tht we can use it for authentication
  late String verificationId;
  bool showLoading = false;

  Future mobileverification() async {
    final bool isValid = _inputformKey.currentState!.validate();
    if (isValid) {
      setState(() {
        showLoading = true;
      });
      await _auth.verifyPhoneNumber(
          phoneNumber: _userPhoneNumber.text,
          verificationCompleted: (phoneAuthCredential) async {
            setState(() {
              showLoading = false;
            });
          },
          verificationFailed: (verificationFailed) async {
            setState(() {
              showLoading = false;
            });

            // ignore: deprecated_member_use
            _scaffoldKey.currentState!.showSnackBar(
                SnackBar(content: Text(verificationFailed.message.toString())));
          },
          //it is called when the user recieved code from the firebase
          codeSent: (verificationId, resendingToken) async {
            setState(() {
              showLoading = false;
              currentState = MobileVerificationState.SHOW_OTP_STATE;
              this.verificationId = verificationId;
            });
          },
          codeAutoRetrievalTimeout: (verificationId) async {});
    }
  }

  void _saveForm() {
    final bool isValid = _inputformKey.currentState!.validate();
    if (isValid) {
      // Navigator.pushNamed(context, '/otp_retreival_page');

      // And do something here
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: showLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : currentState == MobileVerificationState.SHOW_MOBILE_STATE
              ? mobile_form_widget()
              : OtpPage(currentState, showLoading, verificationId),
    );
  }

  Container mobile_form_widget() {
    return Container(
      color: Colors.purple.shade50,
      child: Center(
        child: inputCentre(),
      ),
    );
  }

  Widget inputCentre() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Continue With Phone",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 40,
              ),
              PhoneInputFormField(
                  TextInputType.phone,
                  _userPhoneNumber,
                  _inputformKey,
                  Icons.phone,
                  "Input",
                  "Add +91 and then 10 digit phone Number"),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Button("CONTINUE", mobileverification)
      ],
    );
  }
}
