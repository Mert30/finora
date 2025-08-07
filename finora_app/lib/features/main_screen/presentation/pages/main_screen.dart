import 'package:finora_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:finora_app/features/transactions/presentation/pages/history_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../transactions/presentation/pages/add_transaction_page.dart';

// Premium Analytics sayfası
class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String selectedPeriod = 'Bu Ay';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              // App Bar
              _buildAppBar(),

              // Content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Period Selector
                    _buildPeriodSelector(),

                    const SizedBox(height: 24),

                    // Overview Cards
                    _buildOverviewCards(),

                    const SizedBox(height: 24),

                    // Spending Chart
                    _buildSpendingChart(),

                    const SizedBox(height: 24),

                    // Category Breakdown
                    _buildCategoryBreakdown(),

                    const SizedBox(height: 24),

                    // Monthly Comparison
                    _buildMonthlyComparison(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 80,
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
                  'Finansal Analiz 📊',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Harcama alışkanlıklarınızı inceleyin',
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

  Widget _buildPeriodSelector() {
    final periods = ['Bu Hafta', 'Bu Ay', 'Son 3 Ay', 'Bu Yıl'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
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
        children: periods.map((period) {
          final isSelected = period == selectedPeriod;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedPeriod = period;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF3B82F6)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildOverviewCard(
              title: 'Toplam Gelir',
              amount: '₺7,200',
              change: '+8.2%',
              icon: FontAwesomeIcons.arrowTrendUp,
              color: const Color(0xFF10B981),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildOverviewCard(
              title: 'Toplam Gider',
              amount: '₺4,850',
              change: '-3.1%',
              icon: FontAwesomeIcons.arrowTrendDown,
              color: const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard({
    required String title,
    required String amount,
    required String change,
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
                child: FaIcon(icon, color: color, size: 16),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  change,
                  style: GoogleFonts.inter(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
            amount,
            style: GoogleFonts.inter(
              color: const Color(0xFF1E293B),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
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
            'Haftalık Harcama Trendi',
            style: GoogleFonts.inter(
              color: const Color(0xFF1E293B),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildChartBar('Pzt', 0.6, const Color(0xFF3B82F6)),
                _buildChartBar('Sal', 0.8, const Color(0xFF8B5CF6)),
                _buildChartBar('Çar', 0.4, const Color(0xFF10B981)),
                _buildChartBar('Per', 0.9, const Color(0xFFF59E0B)),
                _buildChartBar('Cum', 0.7, const Color(0xFFEF4444)),
                _buildChartBar('Cmt', 0.3, const Color(0xFF06B6D4)),
                _buildChartBar('Paz', 0.5, const Color(0xFFEC4899)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(String day, double percentage, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 32,
          height: 150 * percentage,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: GoogleFonts.inter(
            color: const Color(0xFF64748B),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBreakdown() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
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
            'Kategori Dağılımı',
            style: GoogleFonts.inter(
              color: const Color(0xFF1E293B),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          _buildCategoryItem(
            'Yemek & İçecek',
            '₺1,240',
            0.35,
            const Color(0xFFEF4444),
          ),
          const SizedBox(height: 12),
          _buildCategoryItem('Ulaşım', '₺850', 0.25, const Color(0xFF3B82F6)),
          const SizedBox(height: 12),
          _buildCategoryItem(
            'Alışveriş',
            '₺650',
            0.20,
            const Color(0xFF10B981),
          ),
          const SizedBox(height: 12),
          _buildCategoryItem('Eğlence', '₺420', 0.15, const Color(0xFF8B5CF6)),
          const SizedBox(height: 12),
          _buildCategoryItem('Diğer', '₺180', 0.05, const Color(0xFF64748B)),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    String category,
    String amount,
    double percentage,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                category,
                style: GoogleFonts.inter(
                  color: const Color(0xFF1E293B),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              amount,
              style: GoogleFonts.inter(
                color: const Color(0xFF1E293B),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: const Color(0xFFE2E8F0),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          borderRadius: BorderRadius.circular(4),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildMonthlyComparison() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
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
            'Aylık Karşılaştırma',
            style: GoogleFonts.inter(
              color: const Color(0xFF1E293B),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          _buildComparisonItem(
            'Bu Ay',
            '₺4,850',
            '+12%',
            const Color(0xFF10B981),
          ),
          const SizedBox(height: 16),
          _buildComparisonItem(
            'Geçen Ay',
            '₺4,320',
            '-5%',
            const Color(0xFFEF4444),
          ),
          const SizedBox(height: 16),
          _buildComparisonItem(
            '2 Ay Önce',
            '₺4,580',
            '+8%',
            const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonItem(
    String period,
    String amount,
    String change,
    Color changeColor,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            period,
            style: GoogleFonts.inter(
              color: const Color(0xFF64748B),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          amount,
          style: GoogleFonts.inter(
            color: const Color(0xFF1E293B),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: changeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            change,
            style: GoogleFonts.inter(
              color: changeColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    AddTransactionPage(),
    HistoryPage(transactions: []),
    AnalyticsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF3B82F6),
        unselectedItemColor: const Color(0xFF64748B),
        backgroundColor: Colors.white,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Ekle',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Geçmiş',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Analiz',
          ),
        ],
      ),
    );
  }
}
