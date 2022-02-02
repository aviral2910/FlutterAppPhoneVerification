import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final void Function() function;
  final String btntext;

  const Button(this.btntext, this.function, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.purple.shade700),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17.0),
            ))),
        onPressed: function,
        child: Text(btntext,
            style: const TextStyle(
              color: Colors.white,
            )));
  }
}
