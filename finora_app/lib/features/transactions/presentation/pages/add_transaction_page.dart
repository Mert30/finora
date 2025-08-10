import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/core/services/firebase_service.dart';
import '/core/models/firebase_models.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isIncome = true; // true = gelir, false = gider
  String? _selectedCategory;
  DateTime? _selectedDate;
  bool _isSaving = false;
  bool _isLoading = false; // No need for loading anymore

  // Sabit kategoriler - kullanıcı bunlardan seçer
  final Map<String, List<Map<String, dynamic>>> _categories = {
    'income': [
      {'name': 'Maaş', 'icon': Icons.work_outline, 'color': Color(0xFF10B981)},
      {
        'name': 'Freelance',
        'icon': Icons.computer_outlined,
        'color': Color(0xFF3B82F6),
      },
      {
        'name': 'Yatırım',
        'icon': Icons.trending_up_outlined,
        'color': Color(0xFF8B5CF6),
      },
      {
        'name': 'Kira Geliri',
        'icon': Icons.home_outlined,
        'color': Color(0xFF06B6D4),
      },
      {
        'name': 'Satış',
        'icon': Icons.sell_outlined,
        'color': Color(0xFFF59E0B),
      },
      {'name': 'Diğer', 'icon': Icons.more_horiz, 'color': Color(0xFF64748B)},
    ],
    'expense': [
      {
        'name': 'Yemek & İçecek',
        'icon': Icons.restaurant_outlined,
        'color': Color(0xFFEF4444),
      },
      {
        'name': 'Ulaşım',
        'icon': Icons.directions_car_outlined,
        'color': Color(0xFF3B82F6),
      },
      {
        'name': 'Alışveriş',
        'icon': Icons.shopping_bag_outlined,
        'color': Color(0xFF8B5CF6),
      },
      {
        'name': 'Eğlence',
        'icon': Icons.movie_outlined,
        'color': Color(0xFFEC4899),
      },
      {
        'name': 'Sağlık',
        'icon': Icons.local_hospital_outlined,
        'color': Color(0xFF10B981),
      },
      {
        'name': 'Faturalar',
        'icon': Icons.receipt_outlined,
        'color': Color(0xFFF59E0B),
      },
      {
        'name': 'Eğitim',
        'icon': Icons.school_outlined,
        'color': Color(0xFF06B6D4),
      },
      {
        'name': 'Giyim',
        'icon': Icons.checkroom_outlined,
        'color': Color(0xFFEC4899),
      },
      {'name': 'Diğer', 'icon': Icons.more_horiz, 'color': Color(0xFF64748B)},
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      _showSnackBar('Lütfen kategori seçiniz', isError: true);
      return;
    }
    if (_selectedDate == null) {
      _showSnackBar('Lütfen tarih seçiniz', isError: true);
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      _showSnackBar('Kullanıcı oturumu bulunamadı', isError: true);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Find selected category details
      final currentCategories = _categories[_isIncome ? 'income' : 'expense']!;
      final selectedCategoryModel = currentCategories.firstWhere(
        (cat) => cat['name'] == _selectedCategory,
      );

      // Convert icon to iconName string
      final IconData icon = selectedCategoryModel['icon'];
      String iconName = 'category'; // default
      if (icon == Icons.work_outline)
        iconName = 'work_outlined';
      else if (icon == Icons.computer_outlined)
        iconName = 'laptop_outlined';
      else if (icon == Icons.trending_up_outlined)
        iconName = 'trending_up_outlined';
      else if (icon == Icons.home_outlined)
        iconName = 'home_outlined';
      else if (icon == Icons.sell_outlined)
        iconName = 'sell_outlined';
      else if (icon == Icons.more_horiz)
        iconName = 'more_horiz';
      else if (icon == Icons.restaurant_outlined)
        iconName = 'restaurant_outlined';
      else if (icon == Icons.directions_car_outlined)
        iconName = 'directions_car_outlined';
      else if (icon == Icons.shopping_bag_outlined)
        iconName = 'shopping_bag_outlined';
      else if (icon == Icons.movie_outlined)
        iconName = 'movie_outlined';
      else if (icon == Icons.local_hospital_outlined)
        iconName = 'local_hospital_outlined';
      else if (icon == Icons.receipt_outlined)
        iconName = 'receipt_outlined';
      else if (icon == Icons.school_outlined)
        iconName = 'school_outlined';
      else if (icon == Icons.checkroom_outlined)
        iconName = 'checkroom_outlined';

      // Convert color to hex string
      final Color color = selectedCategoryModel['color'];
      final String colorHex =
          '#${color.value.toRadixString(16).substring(2).toUpperCase()}';

      // Create or get category in Firebase
      String categoryId = '';
      try {
        // Check if category already exists
        debugPrint(
          '🔍 Checking if category exists: ${selectedCategoryModel['name']}',
        );
        final existingCategories = await CategoryService.getCategories(
          userId,
          type: _isIncome ? 'income' : 'expense',
        );

        final existingCategory =
            existingCategories
                .where((cat) => cat.name == selectedCategoryModel['name'])
                .isNotEmpty
            ? existingCategories
                  .where((cat) => cat.name == selectedCategoryModel['name'])
                  .first
            : null;

        if (existingCategory != null) {
          // Category exists, use its ID
          categoryId = existingCategory.id;
          debugPrint(
            '✅ Using existing category: ${existingCategory.name} (${categoryId})',
          );
        } else {
          // Category doesn't exist, create it
          debugPrint(
            '➕ Creating new category: ${selectedCategoryModel['name']}',
          );
          final newCategory = FirebaseCategoryModel(
            id: '', // Will be set by Firestore
            userId: userId,
            name: selectedCategoryModel['name'],
            iconName: iconName,
            colorHex: colorHex,
            type: _isIncome ? 'income' : 'expense',
            transactionCount: 0, // Will be updated automatically
            totalAmount: 0.0, // Will be updated automatically
            isDefault: false,
            isActive: true,
            sortOrder: existingCategories.length + 1,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          categoryId = await CategoryService.createCategory(newCategory);
          debugPrint(
            '✅ Created new category: ${selectedCategoryModel['name']} (${categoryId})',
          );
        }
      } catch (e) {
        debugPrint('💥 Error managing category: $e');
        // Continue with empty categoryId if category creation fails
      }

      // Create FirebaseTransaction object
      final transaction = FirebaseTransaction(
        id: '', // Will be set by Firestore
        userId: userId,
        title: _descriptionController.text.trim().isEmpty
            ? '${_isIncome ? 'Gelir' : 'Gider'} - ${selectedCategoryModel['name']}'
            : _descriptionController.text.trim(),
        category: selectedCategoryModel['name'],
        amount: double.parse(_amountController.text.replaceAll(',', '.')),
        isIncome: _isIncome,
        iconName: iconName,
        colorHex: colorHex,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        date: _selectedDate!,
        categoryId: categoryId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to Firebase
      final transactionId = await TransactionService.createTransaction(
        transaction,
      );

      setState(() {
        _isSaving = false;
      });

      _showSnackBar('İşlem başarıyla kaydedildi! 🎉');
      _resetForm();

      // Navigate back to show updated list
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      debugPrint('Error saving transaction: $e');
      _showSnackBar('İşlem kaydedilirken hata oluştu', isError: true);
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _amountController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedCategory = null;
      _selectedDate = DateTime.now();
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError
            ? const Color(0xFFEF4444)
            : const Color(0xFF10B981),
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
          child: CustomScrollView(
            slivers: [
              // Custom App Bar
              // _buildCustomAppBar(),

              // Content
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          //const SizedBox(height: 24),
                          _buildInfoCard(),
                          const SizedBox(height: 24),
                          // Income/Expense Toggle
                          _buildIncomeExpenseToggle(),

                          const SizedBox(height: 32),

                          // Amount Input
                          _buildAmountInput(),

                          const SizedBox(height: 24),

                          // Category Selection
                          _buildCategorySection(),

                          const SizedBox(height: 24),

                          // Date and Description
                          Row(
                            children: [
                              Expanded(child: _buildDatePicker()),
                              const SizedBox(width: 16),
                              Expanded(child: _buildDescriptionInput()),
                            ],
                          ),

                          const SizedBox(height: 40),

                          // Save Button
                          _buildSaveButton(),

                          const SizedBox(height: 24),
                        ],
                      ),
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

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              FontAwesomeIcons.plus,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yeni İşlem ✨',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gelir veya gider ekleyerek takip edin',
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFFF8FAFC),
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yeni İşlem ✨',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gelir veya gider ekleyerek takip edin',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              'Gelir',
              Icons.trending_up,
              const Color(0xFF10B981),
              _isIncome,
              () {
                setState(() {
                  _isIncome = true;
                  _selectedCategory = null;
                });
              },
            ),
          ),
          Expanded(
            child: _buildToggleButton(
              'Gider',
              Icons.trending_down,
              const Color(0xFFEF4444),
              !_isIncome,
              () {
                setState(() {
                  _isIncome = false;
                  _selectedCategory = null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    String label,
    IconData icon,
    Color color,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                color: isSelected ? Colors.white : color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tutar',
            style: GoogleFonts.inter(
              color: const Color(0xFF1E293B),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: _isIncome
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444),
            ),
            decoration: InputDecoration(
              prefixText: '₺ ',
              prefixStyle: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: _isIncome
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
              ),
              hintText: '0.00',
              hintStyle: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFE2E8F0),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen tutar girin';
              }
              if (double.tryParse(value) == null) {
                return 'Geçerli bir tutar girin';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    final currentCategories = _categories[_isIncome ? 'income' : 'expense']!;
    debugPrint(
      '🎨 Building category section: ${currentCategories.length} categories, isIncome: $_isIncome',
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kategori (${currentCategories.length})',
            style: GoogleFonts.inter(
              color: const Color(0xFF1E293B),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: currentCategories.length,
            itemBuilder: (context, index) {
              final category = currentCategories[index];
              final isSelected = _selectedCategory == category['name'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category['name'];
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? category['color'].withOpacity(0.1)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? category['color']
                          : const Color(0xFFE2E8F0),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        category['icon'],
                        color: isSelected
                            ? category['color']
                            : const Color(0xFF64748B),
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['name'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: isSelected
                              ? category['color']
                              : const Color(0xFF64748B),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tarih',
            style: GoogleFonts.inter(
              color: const Color(0xFF64748B),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                });
              }
            },
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: const Color(0xFF3B82F6),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'Seç',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Açıklama',
            style: GoogleFonts.inter(
              color: const Color(0xFF64748B),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _descriptionController,
            style: GoogleFonts.inter(
              color: const Color(0xFF1E293B),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'İsteğe bağlı',
              hintStyle: GoogleFonts.inter(
                color: const Color(0xFF94A3B8),
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: _isIncome
              ? [const Color(0xFF10B981), const Color(0xFF059669)]
              : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
        ),
        boxShadow: [
          BoxShadow(
            color:
                (_isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444))
                    .withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: _isSaving ? null : _saveTransaction,
          child: Center(
            child: _isSaving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Kaydet',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
