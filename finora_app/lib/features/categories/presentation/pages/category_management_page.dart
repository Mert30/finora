import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_theme.dart';

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final bool isIncome;
  final int transactionCount;
  final double totalAmount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.isIncome,
    required this.transactionCount,
    required this.totalAmount,
  });
}

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({super.key});

  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _showIncomeCategories = true;

  // Demo data
  final List<CategoryModel> _incomeCategories = [
    CategoryModel(
      id: '1',
      name: 'Maaş',
      icon: Icons.work_outline,
      color: const Color(0xFF10B981),
      isIncome: true,
      transactionCount: 12,
      totalAmount: 36000.0,
    ),
    CategoryModel(
      id: '2',
      name: 'Freelance',
      icon: Icons.computer_outlined,
      color: const Color(0xFF3B82F6),
      isIncome: true,
      transactionCount: 8,
      totalAmount: 6800.0,
    ),
    CategoryModel(
      id: '3',
      name: 'Yatırım Getirisi',
      icon: Icons.trending_up_outlined,
      color: const Color(0xFF8B5CF6),
      isIncome: true,
      transactionCount: 4,
      totalAmount: 1800.0,
    ),
    CategoryModel(
      id: '4',
      name: 'Kira Geliri',
      icon: Icons.home_outlined,
      color: const Color(0xFF06B6D4),
      isIncome: true,
      transactionCount: 12,
      totalAmount: 18000.0,
    ),
  ];

  final List<CategoryModel> _expenseCategories = [
    CategoryModel(
      id: '5',
      name: 'Yemek & İçecek',
      icon: Icons.restaurant_outlined,
      color: const Color(0xFFEF4444),
      isIncome: false,
      transactionCount: 45,
      totalAmount: 2250.0,
    ),
    CategoryModel(
      id: '6',
      name: 'Ulaşım',
      icon: Icons.directions_car_outlined,
      color: const Color(0xFF3B82F6),
      isIncome: false,
      transactionCount: 28,
      totalAmount: 980.0,
    ),
    CategoryModel(
      id: '7',
      name: 'Alışveriş',
      icon: Icons.shopping_bag_outlined,
      color: const Color(0xFF8B5CF6),
      isIncome: false,
      transactionCount: 15,
      totalAmount: 1800.0,
    ),
    CategoryModel(
      id: '8',
      name: 'Eğlence',
      icon: Icons.movie_outlined,
      color: const Color(0xFFEC4899),
      isIncome: false,
      transactionCount: 12,
      totalAmount: 750.0,
    ),
    CategoryModel(
      id: '9',
      name: 'Faturalar',
      icon: Icons.receipt_outlined,
      color: const Color(0xFFF59E0B),
      isIncome: false,
      transactionCount: 18,
      totalAmount: 1950.0,
    ),
    CategoryModel(
      id: '10',
      name: 'Sağlık',
      icon: Icons.local_hospital_outlined,
      color: const Color(0xFF10B981),
      isIncome: false,
      transactionCount: 6,
      totalAmount: 450.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  List<CategoryModel> get _currentCategories {
    return _showIncomeCategories ? _incomeCategories : _expenseCategories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getBackground(),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
                          slivers: [
                // Custom App Bar
                _buildCustomAppBar(),
                
                // Category Type Toggle
                SliverToBoxAdapter(
                  child: _buildCategoryToggle(),
                ),
                
                // Summary Cards
                SliverToBoxAdapter(
                  child: _buildSummarySection(),
                ),
                
                // Categories List
                _buildCategoriesList(),
                
                // Add Category Button
                SliverToBoxAdapter(
                  child: _buildAddCategoryButton(),
                ),
              ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.getBackground(),
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.lightBackground, Color(0xFFE2E8F0)],
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
                  'Kategoriler 📂',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.getTextPrimary(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kategorilerinizi düzenleyin ve yönetin',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.getTextSecondary(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryToggle(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppTheme.getSurface(isDark),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
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
                isDark,
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
                isDark,
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
    bool isDark,
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

  Widget _buildSummarySection(bool isDark) {
    final categories = _currentCategories;
    final totalTransactions = categories.fold(0, (sum, cat) => sum + cat.transactionCount);
    final totalAmount = categories.fold(0.0, (sum, cat) => sum + cat.totalAmount);
    final averagePerCategory = categories.isNotEmpty ? totalAmount / categories.length : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Toplam İşlem',
              value: totalTransactions.toString(),
              icon: Icons.receipt_long_outlined,
              color: const Color(0xFF3B82F6),
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              title: 'Toplam Tutar',
              value: '₺${totalAmount.toStringAsFixed(0)}',
              icon: Icons.attach_money_outlined,
              color: _showIncomeCategories 
                  ? const Color(0xFF10B981) 
                  : const Color(0xFFEF4444),
              isDark: isDark,
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
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.getSurface(isDark),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
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
              color: AppTheme.getTextSecondary(isDark),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList(bool isDark) {
    final categories = _currentCategories;
    
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
                      color: AppTheme.getTextSecondary(isDark),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryCard(categories[index], isDark),
                ],
              );
            }
            
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _buildCategoryCard(categories[index], isDark),
            );
          },
          childCount: categories.length,
        ),
      ),
    );
  }

  Widget _buildCategoryCard(CategoryModel category, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.getSurface(isDark),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
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
                    color: AppTheme.getTextPrimary(isDark),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${category.transactionCount} işlem',
                      style: GoogleFonts.inter(
                        color: AppTheme.getTextSecondary(isDark),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Text(' • '),
                    Text(
                      '₺${category.totalAmount.toStringAsFixed(0)}',
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
          PopupMenuButton<String>(
            color: AppTheme.getSurface(isDark),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            icon: Icon(
              Icons.more_vert,
              color: AppTheme.getTextSecondary(isDark),
            ),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _showEditCategoryDialog(category, isDark);
                  break;
                case 'delete':
                  _showDeleteCategoryDialog(category, isDark);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      color: AppTheme.getTextSecondary(isDark),
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Düzenle',
                      style: GoogleFonts.inter(
                        color: AppTheme.getTextPrimary(isDark),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_outline,
                      color: Color(0xFFEF4444),
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Sil',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFEF4444),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddCategoryButton(bool isDark) {
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
            onTap: () => _showAddCategoryDialog(isDark),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Yeni Kategori Ekle',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
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

  void _showAddCategoryDialog(bool isDark) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Kategori ekleme özelliği yakında! 🎨',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF3B82F6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showEditCategoryDialog(CategoryModel category, bool isDark) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${category.name} düzenleme özelliği yakında! ✏️',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF8B5CF6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showDeleteCategoryDialog(CategoryModel category, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.getSurface(isDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Kategori Sil',
          style: GoogleFonts.inter(
            color: AppTheme.getTextPrimary(isDark),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          '${category.name} kategorisini silmek istediğinizden emin misiniz?\n\nBu kategoriyle ilgili ${category.transactionCount} işlem etkilenecektir.',
          style: GoogleFonts.inter(
            color: AppTheme.getTextSecondary(isDark),
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
                color: AppTheme.getTextSecondary(isDark),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Kategori silme özelliği yakında! 🗑️',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: const Color(0xFFEF4444),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(16),
                ),
              );
            },
            child: Text(
              'Sil',
              style: GoogleFonts.inter(
                color: const Color(0xFFEF4444),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}