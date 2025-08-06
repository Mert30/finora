import 'package:flutter/material.dart';

class DescriptionInputField extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.deepPurple.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: TextFormField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: 'Açıklama (opsiyonel)',
            labelStyle: TextStyle(
              color: Colors.deepPurple.shade300,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(
              Icons.edit_note_rounded,
              color: Colors.deepPurple.shade400,
              size: 26,
            ),
            border: InputBorder.none,
          ),
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
      ),
    );
  }
}
