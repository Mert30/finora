import 'package:flutter/material.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/amount_input_field.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/description_input_field.dart';
import '../widgets/primary_button.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedCategory;
  final List<String> _categories = [
    'Gıda',
    'Ulaşım',
    'Sağlık',
    'Eğlence',
    'Fatura',
    'Diğer',
  ];

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  bool _isSaving = false;

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _saveTransaction() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lütfen tarih seçiniz')));
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // Kaydetme simülasyonu (API veya Firebase burada yapılacak)
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İşlem başarıyla kaydedildi!')),
      );

      _formKey.currentState!.reset();
      _selectedDate = null;
      _selectedCategory = null;
      _amountController.clear();
      _descriptionController.clear();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.indigo.shade700;
    final backgroundColor = Colors.grey.shade100;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Yeni İşlem Ekle'),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 8,
        shadowColor: primaryColor.withOpacity(0.7),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.1),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: primaryColor.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                CategoryDropdown(
                  label: 'Kategori',
                  categories: _categories,
                  value: _selectedCategory,
                  onChanged: (val) => setState(() => _selectedCategory = val),
                ),
                const SizedBox(height: 24),
                AmountInputField(controller: _amountController),
                const SizedBox(height: 24),
                DatePickerField(
                  label: 'Tarih',
                  selectedDate: _selectedDate,
                  onDateSelected: _onDateSelected,
                ),
                const SizedBox(height: 24),
                DescriptionInputField(controller: _descriptionController),
                const SizedBox(height: 36),
                _isSaving
                    ? CircularProgressIndicator(color: primaryColor)
                    : PrimaryButton(
                        label: 'Kaydet',
                        onPressed: _saveTransaction,
                        color: Colors.white,
                        shadowColor: primaryColor.withOpacity(0.8),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
