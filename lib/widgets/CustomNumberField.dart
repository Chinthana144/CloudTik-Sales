import 'package:flutter/material.dart';

class CustomNumberField extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscureText;
  final TextEditingController controller;

  const CustomNumberField({
    Key? key,
    required this.label,
    required this.hint,
    this.obscureText = false,
    required this.controller,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.teal),
        ),
      ),
    );
  }
}//class