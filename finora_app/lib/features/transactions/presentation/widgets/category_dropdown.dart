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
    return Card(
      elevation: 6,
      shadowColor: Colors.deepPurple.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.deepPurple.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            filled: true,
            fillColor: Colors.deepPurple.shade50,
            prefixIcon: Icon(Icons.category, color: Colors.deepPurple.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
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
          icon: Icon(Icons.arrow_drop_down_circle_outlined),
          iconSize: 26,
          dropdownColor: Colors.white,
          iconEnabledColor: Colors.deepPurple.shade600,
        ),
      ),
    );
  }
}
