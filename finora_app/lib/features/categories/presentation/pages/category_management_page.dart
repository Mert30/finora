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
      body: CustomScrollView(
        slivers: [
          _buildCustomAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(),
                  const SizedBox(height: 24),
                  _buildToggleButtons(),
                  const SizedBox(height: 24),
                  _buildSummarySection(),
                  const SizedBox(height: 24),
                  _buildCategoriesList(),
                ],
              ),
            ),
          ),
        ],
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
              FontAwesomeIcons.layerGroup,
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
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'İşlem kategorilerinizi düzenleyin ve yönetin',
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

  Widget _buildToggleButtons() {
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
    final totalTransactions = _currentCategories.fold(
      0, 
      (sum, category) => sum + (_categoryTransactionCounts[category.name] ?? 0),
    );
    
    final totalAmount = _currentCategories.fold(
      0.0, 
      (sum, category) => sum + (_categoryTotalAmounts[category.name] ?? 0.0),
    );

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
          Row(
            children: [
              Icon(
                _showIncomeCategories ? Icons.trending_up : Icons.trending_down,
                color: _showIncomeCategories ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${_showIncomeCategories ? 'Gelir' : 'Gider'} Kategorileri Özeti',
                style: GoogleFonts.inter(
                  color: const Color(0xFF1F2937),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Üst satır: Kategori ve İşlem sayısı
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: 'Toplam Kategori',
                  value: '${_currentCategories.length}',
                  icon: FontAwesomeIcons.layerGroup,
                  color: const Color(0xFF6366F1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  title: 'Toplam İşlem',
                  value: '$totalTransactions',
                  icon: FontAwesomeIcons.receipt,
                  color: const Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Alt satır: Toplam tutar (tek başına, geniş)
          _buildSummaryCard(
            title: 'Toplam Tutar',
            value: '₺${totalAmount.toStringAsFixed(0)}',
            icon: FontAwesomeIcons.coins,
            color: _showIncomeCategories ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            isFullWidth: true,
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
    bool isFullWidth = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isFullWidth ? 20 : 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: isFullWidth ? 24 : 18,
          ),
          SizedBox(height: isFullWidth ? 12 : 8),
          Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontSize: isFullWidth ? 14 : 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isFullWidth ? 8 : 4),
          Text(
            value,
            style: GoogleFonts.inter(
              color: color,
              fontSize: isFullWidth ? 24 : 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    debugPrint('🔄 Building categories list...');
    debugPrint('📊 Income categories: ${_incomeCategories.length}, Expense categories: ${_expenseCategories.length}');
    debugPrint('🔄 Show income: $_showIncomeCategories');
    
    if (_isLoading) {
      debugPrint('⏳ Showing loading indicator');
      return Container(
        height: 200,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
          ),
        ),
      );
    }
    
    final categories = _currentCategories;
    debugPrint('📋 Current categories count: ${categories.length}');
    debugPrint('📋 Categories type: ${categories.runtimeType}');
    
    if (_currentCategories.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: _showIncomeCategories 
                    ? const Color(0xFF10B981).withOpacity(0.1)
                    : const Color(0xFFEF4444).withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                _showIncomeCategories 
                    ? FontAwesomeIcons.trendingUp 
                    : FontAwesomeIcons.trendingDown,
                size: 48,
                color: _showIncomeCategories 
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Henüz ${_showIncomeCategories ? 'gelir' : 'gider'} kategorisi yok',
              style: GoogleFonts.inter(
                color: const Color(0xFF1F2937),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'İlk ${_showIncomeCategories ? 'gelir' : 'gider'} işleminizi\neklediğinizde kategoriler otomatik oluşacak',
              style: GoogleFonts.inter(
                color: const Color(0xFF6B7280),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _showIncomeCategories 
                      ? [const Color(0xFF10B981), const Color(0xFF059669)]
                      : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: (_showIncomeCategories 
                        ? const Color(0xFF10B981) 
                        : const Color(0xFFEF4444)).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _showIncomeCategories ? Icons.add_circle : Icons.remove_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_showIncomeCategories ? 'Gelir' : 'Gider'} Ekle',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
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
    
    debugPrint('📋 Showing ${categories.length} categories');
    return Column(
      children: categories.map((category) {
        debugPrint('📋 Building card for: ${category.name}');
        return _buildCategoryCard(category);
      }).toList(),
    );
  }

  Widget _buildCategoryCard(FirebaseCategoryModel category) {
    final transactionCount = _categoryTransactionCounts[category.name] ?? 0;
    final totalAmount = _categoryTotalAmounts[category.name] ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: category.color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Show category details or analytics
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${category.name} kategorisinin detayları yakında! 📊',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              backgroundColor: category.color,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Category Icon
              Container(
                width: 48,
                height: 48,
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
              
              // Category Info
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
                    Row(
                      children: [
                        Text(
                          '$transactionCount işlem',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF6B7280),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B7280),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '₺${totalAmount.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            color: category.color,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Action Buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Edit Button
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => _showEditCategoryDialog(category),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Color(0xFF6366F1),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Delete Button
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => _showDeleteCategoryDialog(category),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Color(0xFFEF4444),
                          size: 18,
                        ),
                      ),
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