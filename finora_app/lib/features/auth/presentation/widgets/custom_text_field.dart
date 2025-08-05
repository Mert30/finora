import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextEditingController controller;
  final IconData icon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.obscureText,
    required this.controller,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: Colors.blue.shade700,
      style: TextStyle(
        color: Colors.blue.shade900,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.blue.shade700,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
          borderRadius: BorderRadius.circular(25),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade200, width: 1.5),
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
