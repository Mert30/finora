import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final String label;
  final List<String> categories;
  final String? value;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown({
    super.key,
    required this.label,
    required this.categories,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.deepPurple.shade50,
        prefixIcon: Icon(Icons.category, color: Colors.deepPurple.shade400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      items: categories
          .map(
            (c) => DropdownMenuItem(
              value: c,
              child: Text(
                c,
                style: TextStyle(
                  color: Colors.deepPurple.shade900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? 'Lütfen kategori seçiniz' : null,
      iconEnabledColor: Colors.deepPurple.shade600,
    );
  }
}
