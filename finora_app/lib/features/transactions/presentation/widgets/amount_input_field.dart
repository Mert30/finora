import 'package:flutter/material.dart';

class AmountInputField extends StatelessWidget {
  final TextEditingController controller;

  const AmountInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Tutar',
        filled: true,
        fillColor: Colors.deepPurple.shade50,
        prefixIcon: Icon(Icons.attach_money, color: Colors.deepPurple.shade400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) return 'Lütfen tutar giriniz';
        final parsed = double.tryParse(val.replaceAll(',', '.'));
        if (parsed == null || parsed <= 0) return 'Geçerli tutar giriniz';
        return null;
      },
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }
}
