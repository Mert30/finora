import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/core/models/firebase_models.dart';
import '/core/services/firebase_service.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Form controllers
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  // Selected values
  String? _selectedBank;
  String _selectedCardType = 'Banka Kartı';
  Color _selectedColor = const Color(0xFF6366F1);

  // Card colors
  final List<Color> _cardColors = [
    const Color(0xFF6366F1), // Purple
    const Color(0xFF3B82F6), // Blue
    const Color(0xFF10B981), // Green
    const Color(0xFFEF4444), // Red
    const Color(0xFFF59E0B), // Orange
    const Color(0xFF8B5CF6), // Violet
    const Color(0xFF06B6D4), // Cyan
    const Color(0xFFEC4899), // Pink
  ];

  // Turkish banks
  final List<String> _banks = [
    'Akbank',
    'Garanti BBVA',
    'İş Bankası',
    'Yapı Kredi Bankası',
    'Vakıflar Bankası',
    'Halkbank',
    'Ziraat Bankası',
    'Denizbank',
    'QNB Finansbank',
    'ING Bank',
    'TEB',
    'HSBC',
    'Fibabanka',
    'Odeabank',
    'Anadolubank',
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvcController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  String _maskCardNumber(String cardNumber) {
    // Remove spaces and format with spaces
    final cleanNumber = cardNumber.replaceAll(' ', '');
    if (cleanNumber.length <= 4) return cleanNumber;

    final masked =
        '**** **** **** ${cleanNumber.substring(cleanNumber.length - 4)}';
    return masked;
  }

  Future<void> _saveCard() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBank == null) {
      _showSnackBar('Lütfen banka seçiniz', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('Kullanıcı oturum açmamış');

      final cardId = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cards')
          .doc()
          .id;

      final newCard = FirebaseCard(
        id: cardId,
        userId: userId,
        bankName: _selectedBank!,
        cardNumber: _maskCardNumber(_cardNumberController.text.trim()),
        cardHolderName: _cardHolderController.text.trim().toUpperCase(),
        expiryDate: _expiryDateController.text.trim(),
        balance: double.tryParse(_balanceController.text.trim()) ?? 0.0,
        currency: 'TRY',
        colorHex: '#${_selectedColor.value.toRadixString(16).substring(2)}',
        cardType: _selectedCardType,
        isDefault: false,
        isActive: true,
        lastUsed: DateTime.now(),
        monthlyLimit: 50000.0,
        dailyLimit: 5000.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await CardService.createCard(newCard);

      _showSnackBar('Kart başarıyla eklendi! 🎉', Colors.green);

      // Wait for snackbar to show then navigate back
      await Future.delayed(const Duration(seconds: 1));
      if (mounted)
        Navigator.pop(context, true); // Return true to indicate success
    } catch (e) {
      _showSnackBar('Kart eklenirken hata oluştu: $e', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildCustomAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardPreview(),
                        const SizedBox(height: 32),
                        _buildSectionHeader('Kart Bilgileri'),
                        const SizedBox(height: 16),
                        _buildBankSelector(),
                        const SizedBox(height: 20),
                        _buildCardNumberField(),
                        const SizedBox(height: 20),
                        _buildCardHolderField(),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: _buildExpiryDateField()),
                            const SizedBox(width: 16),
                            Expanded(child: _buildCVCField()),
                          ],
                        ),
                        const SizedBox(height: 32),
                        _buildSectionHeader('Kart Özellikleri'),
                        const SizedBox(height: 16),
                        _buildCardTypeSelector(),
                        const SizedBox(height: 20),
                        _buildBalanceField(),
                        const SizedBox(height: 20),
                        _buildColorSelector(),
                        const SizedBox(height: 40),
                        _buildSaveButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yeni Kart Ekle',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Güvenli ve hızlı kart ekleme',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.security, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  'GÜVENLİ',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardPreview() {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_selectedColor, _selectedColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _selectedColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedBank ?? 'Banka Seçiniz',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _selectedCardType == 'Banka Kartı'
                        ? 'Banka Kartı'
                        : 'Kredi Kartı',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _cardNumberController.text.isEmpty
                  ? '**** **** **** ****'
                  : _formatCardNumberForDisplay(_cardNumberController.text),
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KART SAHİBİ',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _cardHolderController.text.isEmpty
                          ? 'AD SOYAD'
                          : _cardHolderController.text.toUpperCase(),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'SON KULLANMA',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _expiryDateController.text.isEmpty
                          ? 'MM/YY'
                          : _expiryDateController.text,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatCardNumberForDisplay(String input) {
    final cleanInput = input.replaceAll(' ', '');
    final formatted = StringBuffer();

    for (int i = 0; i < cleanInput.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted.write(' ');
      }
      formatted.write(cleanInput[i]);
    }

    return formatted.toString();
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildBankSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Banka',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedBank,
              hint: Row(
                children: [
                  const Icon(
                    Icons.account_balance,
                    color: Color(0xFF6B7280),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Bankayı seçiniz',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF6B7280)),
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1F2937),
              ),
              items: _banks
                  .map(
                    (bank) => DropdownMenuItem(
                      value: bank,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.account_balance,
                            color: Color(0xFF6366F1),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(bank),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBank = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kart Numarası',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _cardNumberController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            _CardNumberFormatter(),
          ],
          onChanged: (value) => setState(() {}), // Update preview
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: '1234 5678 9012 3456',
            hintStyle: GoogleFonts.inter(
              color: const Color(0xFF9CA3AF),
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: const Icon(Icons.credit_card, color: Color(0xFF6B7280)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Kart numarası gerekli';
            }
            final cleanValue = value.replaceAll(' ', '');
            if (cleanValue.length != 16) {
              return 'Kart numarası 16 haneli olmalıdır';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCardHolderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kart Sahibi',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _cardHolderController,
          textCapitalization: TextCapitalization.characters,
          onChanged: (value) => setState(() {}), // Update preview
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'AHMET YILMAZ',
            hintStyle: GoogleFonts.inter(
              color: const Color(0xFF9CA3AF),
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: const Icon(Icons.person, color: Color(0xFF6B7280)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Kart sahibi adı gerekli';
            }
            if (value.length < 3) {
              return 'En az 3 karakter olmalıdır';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildExpiryDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Son Kullanma',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _expiryDateController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
            _ExpiryDateFormatter(),
          ],
          onChanged: (value) => setState(() {}), // Update preview
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'MM/YY',
            hintStyle: GoogleFonts.inter(
              color: const Color(0xFF9CA3AF),
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: const Icon(Icons.date_range, color: Color(0xFF6B7280)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Son kullanma tarihi gerekli';
            }
            if (value.length != 5) {
              return 'MM/YY formatında olmalıdır';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCVCField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CVC',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _cvcController,
          keyboardType: TextInputType.number,
          obscureText: true,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: '123',
            hintStyle: GoogleFonts.inter(
              color: const Color(0xFF9CA3AF),
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: const Icon(Icons.lock, color: Color(0xFF6B7280)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'CVC gerekli';
            }
            if (value.length != 3) {
              return '3 haneli olmalıdır';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCardTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kart Tipi',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedCardType = 'Banka Kartı'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedCardType == 'debit'
                        ? const Color(0xFF6366F1).withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedCardType == 'Banka Kartı'
                          ? const Color(0xFF6366F1)
                          : const Color(0xFFE5E7EB),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: _selectedCardType == 'Banka Kartı'
                            ? const Color(0xFF6366F1)
                            : const Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Banka Kartı',
                        style: GoogleFonts.inter(
                          color: _selectedCardType == 'Banka Kartı'
                              ? const Color(0xFF6366F1)
                              : const Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedCardType = 'Kredi Kartı'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedCardType == 'Kredi Kartı'
                        ? const Color(0xFF6366F1).withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedCardType == 'Kredi Kartı'
                          ? const Color(0xFF6366F1)
                          : const Color(0xFFE5E7EB),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.credit_card,
                        color: _selectedCardType == 'Kredi Kartı'
                            ? const Color(0xFF6366F1)
                            : const Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Kredi Kartı',
                        style: GoogleFonts.inter(
                          color: _selectedCardType == 'Kredi Kartı'
                              ? const Color(0xFF6366F1)
                              : const Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBalanceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mevcut Bakiye',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _balanceController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: '0,00',
            hintStyle: GoogleFonts.inter(
              color: const Color(0xFF9CA3AF),
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: const Icon(
              Icons.account_balance_wallet,
              color: Color(0xFF6B7280),
            ),
            suffixText: '₺',
            suffixStyle: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Bakiye bilgisi gerekli';
            }
            if (double.tryParse(value) == null) {
              return 'Geçerli bir rakam giriniz';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kart Rengi',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _cardColors
              .map(
                (color) => GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedColor == color
                            ? const Color(0xFF1F2937)
                            : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _selectedColor == color
                        ? const Icon(Icons.check, color: Colors.white, size: 24)
                        : null,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveCard,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.save, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Kartı Kaydet',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Custom formatters
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll(' ', '');
    final formatted = StringBuffer();

    for (int i = 0; i < newText.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted.write(' ');
      }
      formatted.write(newText[i]);
    }

    return newValue.copyWith(
      text: formatted.toString(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll('/', '');
    final formatted = StringBuffer();

    for (int i = 0; i < newText.length; i++) {
      if (i == 2) {
        formatted.write('/');
      }
      formatted.write(newText[i]);
    }

    return newValue.copyWith(
      text: formatted.toString(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
