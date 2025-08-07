import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Transaction {
  final String id;
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final bool isIncome;
  final IconData icon;
  final Color color;
  final String? description;

  Transaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.isIncome,
    required this.icon,
    required this.color,
    this.description,
  });
}

class HistoryPage extends StatefulWidget {
  final List<Transaction> transactions;

  const HistoryPage({super.key, required this.transactions});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String _selectedFilter = 'Tümü';
  String _selectedSort = 'Tarih';

  // Demo data
  final List<Transaction> _demoTransactions = [
    Transaction(
      id: '1',
      title: 'Market Alışverişi',
      category: 'Yemek & İçecek',
      amount: 124.50,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      isIncome: false,
      icon: Icons.restaurant_outlined,
      color: const Color(0xFFEF4444),
      description: 'Migros - haftalık alışveriş',
    ),
    Transaction(
      id: '2',
      title: 'Maaş Ödemesi',
      category: 'Maaş',
      amount: 3000.00,
      date: DateTime.now().subtract(const Duration(days: 1)),
      isIncome: true,
      icon: Icons.work_outline,
      color: const Color(0xFF10B981),
      description: 'ABC Şirketi',
    ),
    Transaction(
      id: '3',
      title: 'Netflix Abonelik',
      category: 'Eğlence',
      amount: 63.99,
      date: DateTime.now().subtract(const Duration(days: 2)),
      isIncome: false,
      icon: Icons.movie_outlined,
      color: const Color(0xFFEC4899),
    ),
    Transaction(
      id: '4',
      title: 'Uber Ulaşım',
      category: 'Ulaşım',
      amount: 35.00,
      date: DateTime.now().subtract(const Duration(days: 3)),
      isIncome: false,
      icon: Icons.directions_car_outlined,
      color: const Color(0xFF3B82F6),
    ),
    Transaction(
      id: '5',
      title: 'Freelance Proje',
      category: 'Freelance',
      amount: 850.00,
      date: DateTime.now().subtract(const Duration(days: 4)),
      isIncome: true,
      icon: Icons.computer_outlined,
      color: const Color(0xFF8B5CF6),
    ),
    Transaction(
      id: '6',
      title: 'Kahve & Atıştırmalık',
      category: 'Yemek & İçecek',
      amount: 42.50,
      date: DateTime.now().subtract(const Duration(days: 5)),
      isIncome: false,
      icon: Icons.restaurant_outlined,
      color: const Color(0xFFEF4444),
    ),
    Transaction(
      id: '7',
      title: 'Online Kurs',
      category: 'Eğitim',
      amount: 199.00,
      date: DateTime.now().subtract(const Duration(days: 6)),
      isIncome: false,
      icon: Icons.school_outlined,
      color: const Color(0xFF06B6D4),
    ),
    Transaction(
      id: '8',
      title: 'Yatırım Getirisi',
      category: 'Yatırım',
      amount: 450.00,
      date: DateTime.now().subtract(const Duration(days: 7)),
      isIncome: true,
      icon: Icons.trending_up_outlined,
      color: const Color(0xFF10B981),
    ),
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
    super.dispose();
  }

  List<Transaction> get _filteredTransactions {
    List<Transaction> filtered = List.from(_demoTransactions);

    // Filter
    if (_selectedFilter == 'Gelir') {
      filtered = filtered.where((t) => t.isIncome).toList();
    } else if (_selectedFilter == 'Gider') {
      filtered = filtered.where((t) => !t.isIncome).toList();
    }

    // Sort
    if (_selectedSort == 'Tarih') {
      filtered.sort((a, b) => b.date.compareTo(a.date));
    } else if (_selectedSort == 'Tutar') {
      filtered.sort((a, b) => b.amount.compareTo(a.amount));
    } else if (_selectedSort == 'Kategori') {
      filtered.sort((a, b) => a.category.compareTo(b.category));
    }

    return filtered;
  }

  double get _totalIncome {
    return _demoTransactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get _totalExpense {
    return _demoTransactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
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

              // Summary Cards
              SliverToBoxAdapter(child: _buildSummarySection()),

              // Filter & Sort
              SliverToBoxAdapter(child: _buildFilterSortSection()),

              // Transactions List
              _buildTransactionsList(),
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
                  'İşlem Geçmişi 📋',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tüm gelir ve giderlerinizi takip edin',
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

  Widget _buildSummarySection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Toplam Gelir',
              amount: _totalIncome,
              icon: Icons.trending_up,
              color: const Color(0xFF10B981),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              title: 'Toplam Gider',
              amount: _totalExpense,
              icon: Icons.trending_down,
              color: const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const Spacer(),
              Text(
                '${_demoTransactions.where((t) => t.isIncome == (color == const Color(0xFF10B981))).length}',
                style: GoogleFonts.inter(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF64748B),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '₺${amount.toStringAsFixed(2)}',
            style: GoogleFonts.inter(
              color: const Color(0xFF1E293B),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSortSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(child: _buildFilterDropdown()),
          const SizedBox(width: 16),
          Expanded(child: _buildSortDropdown()),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFilter,
          isExpanded: true,
          icon: const Icon(Icons.filter_list, size: 20),
          style: GoogleFonts.inter(
            color: const Color(0xFF1E293B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          items: ['Tümü', 'Gelir', 'Gider'].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedFilter = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSort,
          isExpanded: true,
          icon: const Icon(Icons.sort, size: 20),
          style: GoogleFonts.inter(
            color: const Color(0xFF1E293B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          items: ['Tarih', 'Tutar', 'Kategori'].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedSort = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    final filteredTransactions = _filteredTransactions;

    if (filteredTransactions.isEmpty) {
      return SliverFillRemaining(child: _buildEmptyState());
    }

    return SliverPadding(
      padding: const EdgeInsets.all(24.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  '${filteredTransactions.length} işlem bulundu',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF64748B),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTransactionCard(filteredTransactions[index]),
              ],
            );
          }

          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _buildTransactionCard(filteredTransactions[index]),
          );
        }, childCount: filteredTransactions.length),
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
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
              color: transaction.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(transaction.icon, color: transaction.color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      transaction.category,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Text(' • '),
                    Text(
                      _formatDate(transaction.date),
                      style: GoogleFonts.inter(
                        color: const Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                if (transaction.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    transaction.description!,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.isIncome ? '+' : '-'}₺${transaction.amount.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  color: transaction.isIncome
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: transaction.isIncome
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  transaction.isIncome ? 'Gelir' : 'Gider',
                  style: GoogleFonts.inter(
                    color: transaction.isIncome
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                    fontSize: 11,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Color(0xFF3B82F6),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Henüz işlem yok',
            style: GoogleFonts.inter(
              color: const Color(0xFF1E293B),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'İlk işleminizi ekleyerek başlayın',
            style: GoogleFonts.inter(
              color: const Color(0xFF64748B),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Bugün';
    } else if (difference.inDays == 1) {
      return 'Dün';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
