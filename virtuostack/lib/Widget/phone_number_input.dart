import 'package:flutter/material.dart';

class PhoneInputFormField extends StatelessWidget {
  final TextEditingController controller;
  final GlobalKey<FormState> inputformKey;
  final IconData? icon;
  final String hinttext;
  final String warningMessage;
  final TextInputType keyboardtype;

  PhoneInputFormField(
    this.keyboardtype,
    this.controller,
    this.inputformKey,
    this.icon,
    this.hinttext,
    this.warningMessage, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: inputformKey,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
        child: SizedBox(
          child: TextFormField(
            // key: _inputkey,
            controller: controller,
            keyboardType: keyboardtype,
            decoration: InputDecoration(
              labelText: hinttext,
              prefixIcon: icon == null ? null : Icon(icon),
              hintText: "Input",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (value) {
              if (value.toString().length < 13) {
                return warningMessage;
              } else if (value.toString().length > 13) {
                return "Phone Number should be of 10 digits";
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
