import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/core/services/firebase_service.dart';
import '/core/models/firebase_models.dart';

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({super.key});

  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _showIncomeCategories = true;
  bool _isLoading = true;
  
  // Firebase kategorileri
  List<FirebaseCategoryModel> _incomeCategories = [];
  List<FirebaseCategoryModel> _expenseCategories = [];
  Map<String, int> _categoryTransactionCounts = {};
  Map<String, double> _categoryTotalAmounts = {};

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    
    _loadCategoryData();
  }
  
  Future<void> _loadCategoryData() async {
    try {
      debugPrint('🔄 Loading category data from Firebase...');
      final userId = FirebaseAuth.instance.currentUser?.uid;
      
      if (userId != null) {
        // Load all categories
        debugPrint('📂 Loading all categories...');
        final allCategories = await CategoryService.getCategories(userId);
        debugPrint('✅ Loaded ${allCategories.length} categories');
        
        // Load all transactions to calculate counts and totals
        debugPrint('💰 Loading transactions for calculations...');
        final allTransactions = await TransactionService.getTransactions(userId);
        debugPrint('✅ Loaded ${allTransactions.length} transactions');
        
        // Calculate transaction counts and totals per category
        final categoryTransactionCounts = <String, int>{};
        final categoryTotalAmounts = <String, double>{};
        
        for (final transaction in allTransactions) {
          final categoryName = transaction.category;
          categoryTransactionCounts[categoryName] = 
              (categoryTransactionCounts[categoryName] ?? 0) + 1;
          categoryTotalAmounts[categoryName] = 
              (categoryTotalAmounts[categoryName] ?? 0) + transaction.amount;
        }
        
        // Separate income and expense categories
        final incomeCategories = <FirebaseCategoryModel>[];
        final expenseCategories = <FirebaseCategoryModel>[];
        
        for (final category in allCategories) {
          if (category.type == 'income') {
            incomeCategories.add(category);
          } else {
            expenseCategories.add(category);
          }
        }
        
        setState(() {
          _incomeCategories = incomeCategories;
          _expenseCategories = expenseCategories;
          _categoryTransactionCounts = categoryTransactionCounts;
          _categoryTotalAmounts = categoryTotalAmounts;
          _isLoading = false;
        });
        
        debugPrint('🎉 Category data loaded successfully!');
        debugPrint('💰 Income categories: ${_incomeCategories.length}');
        debugPrint('💸 Expense categories: ${_expenseCategories.length}');
      } else {
        debugPrint('❌ No user ID found');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('💥 Error loading category data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  List<FirebaseCategoryModel> get _currentCategories =>
      _showIncomeCategories ? _incomeCategories : _expenseCategories;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              _buildCustomAppBar(),
              
              // Category Toggle
              SliverToBoxAdapter(
                child: _buildCategoryToggle(),
              ),
              
              // Summary Section
              SliverToBoxAdapter(
                child: _buildSummarySection(),
              ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              
              // Categories List
              _buildCategoriesList(),
              
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
      floatingActionButton: SlideTransition(
        position: _slideAnimation,
        child: _buildAddCategoryButton(),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return SliverAppBar(
      backgroundColor: const Color(0xFFF8FAFC),
      elevation: 0,
      pinned: false,
      expandedHeight: 120,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667EEA).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.category_outlined,
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
                          'Kategori Yönetimi',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF1F2937),
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gelir ve gider kategorilerinizi yönetin',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF6B7280),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.more_vert,
                      color: Color(0xFF6B7280),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryToggle() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
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
                'Gelir Kategorileri',
                Icons.trending_up,
                const Color(0xFF10B981),
                _showIncomeCategories,
                () {
                  setState(() {
                    _showIncomeCategories = true;
                  });
                },
              ),
            ),
            Expanded(
              child: _buildToggleButton(
                'Gider Kategorileri',
                Icons.trending_down,
                const Color(0xFFEF4444),
                !_showIncomeCategories,
                () {
                  setState(() {
                    _showIncomeCategories = false;
                  });
                },
              ),
            ),
          ],
        ),
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
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                color: isSelected ? Colors.white : color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    final categories = _currentCategories;
    
    // Calculate totals from our Firebase data
    int totalTransactions = 0;
    double totalAmount = 0.0;
    
    for (final category in categories) {
      totalTransactions += _categoryTransactionCounts[category.name] ?? 0;
      totalAmount += _categoryTotalAmounts[category.name] ?? 0.0;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Toplam İşlem',
              value: totalTransactions.toString(),
              icon: Icons.receipt_long_outlined,
              color: const Color(0xFF6366F1),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              title: _showIncomeCategories ? 'Toplam Gelir' : 'Toplam Gider',
              value: '₺${totalAmount.toStringAsFixed(2)}',
              icon: _showIncomeCategories ? Icons.trending_up : Icons.trending_down,
              color: _showIncomeCategories ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: GoogleFonts.inter(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    debugPrint('🎨 Building categories list. Loading: $_isLoading');
    debugPrint('📊 Income categories: ${_incomeCategories.length}, Expense categories: ${_expenseCategories.length}');
    debugPrint('🔄 Show income: $_showIncomeCategories');
    
    if (_isLoading) {
      debugPrint('⏳ Showing loading indicator');
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
          ),
        ),
      );
    }
    
    final categories = _currentCategories;
    debugPrint('📋 Current categories count: ${categories.length}');
    debugPrint('📋 Categories type: ${categories.runtimeType}');
    
    if (categories.isEmpty) {
      debugPrint('📭 Showing empty state');
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.category_outlined,
                size: 64,
                color: const Color(0xFF9CA3AF),
              ),
              const SizedBox(height: 16),
              Text(
                _showIncomeCategories ? 'Henüz gelir kategorisi yok' : 'Henüz gider kategorisi yok',
                style: GoogleFonts.inter(
                  color: const Color(0xFF6B7280),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Transaction ekleyerek kategoriler oluşturun',
                style: GoogleFonts.inter(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    debugPrint('📋 Showing ${categories.length} categories');
    return SliverPadding(
      padding: const EdgeInsets.all(24.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${categories.length} kategori bulundu',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF6B7280),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryCard(categories[index]),
                ],
              );
            }
            
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: _buildCategoryCard(categories[index]),
            );
          },
          childCount: categories.length,
        ),
      ),
    );
  }

  Widget _buildCategoryCard(FirebaseCategoryModel category) {
    final transactionCount = _categoryTransactionCounts[category.name] ?? 0;
    final totalAmount = _categoryTotalAmounts[category.name] ?? 0.0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              category.icon,
              color: category.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1F2937),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$transactionCount işlem',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF6B7280),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₺${totalAmount.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  color: category.type == 'income' 
                      ? const Color(0xFF10B981) 
                      : const Color(0xFFEF4444),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: category.type == 'income'
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  category.type == 'income' ? 'Gelir' : 'Gider',
                  style: GoogleFonts.inter(
                    color: category.type == 'income'
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddCategoryButton() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: _showIncomeCategories
                ? [const Color(0xFF10B981), const Color(0xFF059669)]
                : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
          ),
          boxShadow: [
            BoxShadow(
              color: (_showIncomeCategories 
                  ? const Color(0xFF10B981) 
                  : const Color(0xFFEF4444)).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: () => _showAddCategoryDialog(),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Kategori Ekle',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Yeni Kategori Ekle',
          style: GoogleFonts.inter(
            color: const Color(0xFF1F2937),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Kategori Adı',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6366F1)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'İptal',
              style: GoogleFonts.inter(
                color: const Color(0xFF6B7280),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                try {
                  final userId = FirebaseAuth.instance.currentUser?.uid;
                  if (userId != null) {
                    final newCategory = FirebaseCategoryModel(
                      id: '', // Will be set by Firestore
                      userId: userId,
                      name: nameController.text.trim(),
                      iconName: 'category',
                      colorHex: _showIncomeCategories ? '#10B981' : '#EF4444',
                      type: _showIncomeCategories ? 'income' : 'expense',
                      transactionCount: 0,
                      totalAmount: 0.0,
                      isDefault: false,
                      isActive: true,
                      sortOrder: _currentCategories.length + 1,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );
                    
                    await CategoryService.createCategory(newCategory);
                    
                    Navigator.pop(context);
                    _loadCategoryData(); // Refresh data
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Kategori başarıyla eklendi! ✅',
                          style: GoogleFonts.inter(color: Colors.white),
                        ),
                        backgroundColor: const Color(0xFF10B981),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Hata oluştu: $e',
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                      backgroundColor: const Color(0xFFEF4444),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Ekle',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker(Color initialColor, Function(Color) onColorSelected) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            'Renk Seçin',
            style: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildColorOption(Colors.red, initialColor, onColorSelected),
              _buildColorOption(Colors.orange, initialColor, onColorSelected),
              _buildColorOption(Colors.yellow, initialColor, onColorSelected),
              _buildColorOption(Colors.green, initialColor, onColorSelected),
              _buildColorOption(Colors.blue, initialColor, onColorSelected),
              _buildColorOption(Colors.purple, initialColor, onColorSelected),
              _buildColorOption(Colors.brown, initialColor, onColorSelected),
              _buildColorOption(Colors.grey, initialColor, onColorSelected),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color, Color initialColor, Function(Color) onColorSelected) {
    return GestureDetector(
      onTap: () => onColorSelected(color),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color == initialColor ? Colors.black : Colors.transparent),
        ),
      ),
    );
  }

  Widget _buildIconPicker(FontAwesomeIcons icon, Function(FontAwesomeIcons) onIconSelected) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            'İkon Seçin',
            style: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildIconOption(FontAwesomeIcons.solidFolder, icon, onIconSelected),
              _buildIconOption(FontAwesomeIcons.solidChartBar, icon, onIconSelected),
              _buildIconOption(FontAwesomeIcons.solidCreditCard, icon, onIconSelected),
              _buildIconOption(FontAwesomeIcons.solidHandHoldingDollar, icon, onIconSelected),
              _buildIconOption(FontAwesomeIcons.solidGift, icon, onIconSelected),
              _buildIconOption(FontAwesomeIcons.solidShoppingBag, icon, onIconSelected),
              _buildIconOption(FontAwesomeIcons.solidBars, icon, onIconSelected),
              _buildIconOption(FontAwesomeIcons.solidCog, icon, onIconSelected),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconOption(FontAwesomeIcons icon, FontAwesomeIcons initialIcon, Function(FontAwesomeIcons) onIconSelected) {
    return GestureDetector(
      onTap: () => onIconSelected(icon),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: icon == initialIcon ? Colors.black : Colors.transparent),
        ),
        child: Icon(
          icon,
          color: Colors.black,
          size: 20,
        ),
      ),
    );
  }

  void _showEditCategoryDialog(FirebaseCategoryModel category) {
    final nameController = TextEditingController(text: category.name);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Kategori Düzenle',
          style: GoogleFonts.inter(
            color: const Color(0xFF1F2937),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Kategori Adı',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: category.color),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'İptal',
              style: GoogleFonts.inter(
                color: const Color(0xFF6B7280),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                try {
                  // Update category in Firebase
                  final updatedCategory = FirebaseCategoryModel(
                    id: category.id,
                    userId: category.userId,
                    name: nameController.text.trim(),
                    iconName: category.iconName,
                    colorHex: category.colorHex,
                    type: category.type,
                    transactionCount: category.transactionCount,
                    totalAmount: category.totalAmount,
                    monthlyBudget: category.monthlyBudget,
                    currentSpent: category.currentSpent,
                    currency: category.currency,
                    isDefault: category.isDefault,
                    isActive: category.isActive,
                    parentCategoryId: category.parentCategoryId,
                    sortOrder: category.sortOrder,
                    createdAt: category.createdAt,
                    updatedAt: DateTime.now(),
                  );
                  
                  await CategoryService.updateCategory(updatedCategory);
                  
                  Navigator.pop(context);
                  _loadCategoryData(); // Refresh data
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Kategori başarıyla güncellendi! ✅',
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                      backgroundColor: const Color(0xFF10B981),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Hata oluştu: $e',
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                      backgroundColor: const Color(0xFFEF4444),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: category.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Güncelle',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteCategoryDialog(FirebaseCategoryModel category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Kategori Sil',
          style: GoogleFonts.inter(
            color: const Color(0xFF1F2937),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          '${category.name} kategorisini silmek istediğinizden emin misiniz?\n\nBu kategoriyle ilgili ${_categoryTransactionCounts[category.name] ?? 0} işlem etkilenecektir.',
          style: GoogleFonts.inter(
            color: const Color(0xFF6B7280),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'İptal',
              style: GoogleFonts.inter(
                color: const Color(0xFF6B7280),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await CategoryService.deleteCategory(category.userId, category.id);
                
                Navigator.pop(context);
                _loadCategoryData(); // Refresh data
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${category.name} kategorisi silindi! 🗑️',
                      style: GoogleFonts.inter(color: Colors.white),
                    ),
                    backgroundColor: const Color(0xFFEF4444),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Hata oluştu: $e',
                      style: GoogleFonts.inter(color: Colors.white),
                    ),
                    backgroundColor: const Color(0xFFEF4444),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Sil',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}