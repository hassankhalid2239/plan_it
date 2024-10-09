import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? sufix;
  final int maxLines;
  final int minLines;

  const CustomInputField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.sufix,
      this.minLines = 1,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        maxLines: maxLines,
        minLines: minLines,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter $hintText!';
          } else {
            return null;
          }
        },
        style:
            TextStyle(color: Colors.black),
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          // filled: true,
          // fillColor: Colors.white,
          suffixIcon: sufix,
          focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Color(0xff6368D9),width: 3)),
          border: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Color(0xffF2F2F2))),
        ),
      ),
    );
  }
}
