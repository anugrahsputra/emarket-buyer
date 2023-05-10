import 'package:flutter/material.dart';

class Fields extends StatelessWidget {
  const Fields(
      {super.key,
      required this.controller,
      required this.keyboardType,
      required this.hintText,
      required this.prefixIcon,
      this.obscureText = false});

  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final Icon prefixIcon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: const Color(0xff212529),
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            style: BorderStyle.none,
            width: 0,
          ),
        ),
        filled: true,
      ),
    );
  }
}
