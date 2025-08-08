import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finora_app/features/profile/presentation/pages/profile_page.dart';
import 'package:finora_app/features/transactions/presentation/pages/add_transaction_page.dart';
import 'package:finora_app/features/transactions/presentation/pages/history_page.dart';
import 'package:finora_app/features/budget/presentation/pages/budget_goals_page.dart';
import 'package:finora_app/features/categories/presentation/pages/category_management_page.dart';
import 'package:finora_app/features/settings/presentation/pages/settings_page.dart'; // For NotificationSettings

// Analytics sayfası
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildCustomAppBar(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildComingSoonCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
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
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Analitik',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Yakında kullanıma sunulacak',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
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
                      child: IconButton(
                        icon: const Icon(
                          Icons.info_outline,
                          color: Color(0xFF64748B),
                          size: 24,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Analitik özelliği yakında! 📊',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              backgroundColor: const Color(0xFF3B82F6),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.all(16),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComingSoonCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.analytics_outlined,
            color: Colors.white,
            size: 80,
          ),
          const SizedBox(height: 24),
          Text(
            'Analitik Özelliği',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Detaylı finansal analizler, grafikler ve raporlar yakında burada olacak!',
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// MainScreen - Dashboard'lı navbar sistemi
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
    BudgetGoalsPage(),
    CategoryManagementPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildCustomDrawer(),
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
            icon: Icon(Icons.flag_outlined),
            activeIcon: Icon(Icons.flag),
            label: 'Hedefler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Kategoriler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // 🎨 MAINSCREEN DRAWER
  Widget _buildCustomDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Finora',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'AI Destekli Finans',
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildMainDrawerTile(
                    icon: Icons.home_outlined,
                    title: 'Anasayfa',
                    subtitle: 'Dashboard ve AI içgörüleri',
                    color: const Color(0xFF3B82F6),
                    isSelected: _currentIndex == 0,
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _currentIndex = 0);
                    },
                  ),
                  
                  _buildMainDrawerTile(
                    icon: Icons.add_circle_outline,
                    title: 'İşlem Ekle',
                    subtitle: 'Yeni harcama/gelir kaydı',
                    color: const Color(0xFF10B981),
                    isSelected: _currentIndex == 1,
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _currentIndex = 1);
                    },
                  ),
                  
                  _buildMainDrawerTile(
                    icon: Icons.history_outlined,
                    title: 'Geçmiş',
                    subtitle: 'İşlem geçmişi ve filtreler',
                    color: const Color(0xFFF59E0B),
                    isSelected: _currentIndex == 2,
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _currentIndex = 2);
                    },
                  ),
                  
                  _buildMainDrawerTile(
                    icon: Icons.flag_outlined,
                    title: 'Bütçe Hedefleri',
                    subtitle: 'Finansal hedefler ve takip',
                    color: const Color(0xFF8B5CF6),
                    isSelected: _currentIndex == 3,
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _currentIndex = 3);
                    },
                  ),
                  
                  _buildMainDrawerTile(
                    icon: Icons.category_outlined,
                    title: 'Kategoriler',
                    subtitle: 'Kategori yönetimi',
                    color: const Color(0xFFEC4899),
                    isSelected: _currentIndex == 4,
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _currentIndex = 4);
                    },
                  ),
                  
                  _buildMainDrawerTile(
                    icon: Icons.person_outline,
                    title: 'Profil',
                    subtitle: 'Hesap ayarları ve bilgiler',
                    color: const Color(0xFF64748B),
                    isSelected: _currentIndex == 5,
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _currentIndex = 5);
                    },
                  ),
                ],
              ),
            ),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Divider(color: const Color(0xFFE5E7EB)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF667EEA).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.rocket_launch_outlined,
                          color: Color(0xFF667EEA),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Finora v1.0.0',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF1F2937),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'AI destekli finans uygulaması',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF6B7280),
                                fontSize: 12,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainDrawerTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected 
                  ? color.withOpacity(0.15)
                  : color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected 
                    ? color.withOpacity(0.3)
                    : color.withOpacity(0.1),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          color: isSelected 
                              ? color
                              : const Color(0xFF1F2937),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF6B7280),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isSelected ? Icons.check_circle : Icons.arrow_forward_ios,
                  color: isSelected ? color : color.withOpacity(0.6),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            _buildCustomAppBar(),
            
            // Content
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // Balance Card
                      _buildBalanceCard(),
                      
                      const SizedBox(height: 24),
                      
                      // Quick Actions
                      _buildQuickActions(),
                      
                      const SizedBox(height: 24),
                      
                      // Financial Health Score
                      _buildFinancialHealthScore(),
                      
                      const SizedBox(height: 24),
                      
                      // Intelligent Insights Panel
                      _buildIntelligentInsightsPanel(),
                      
                      const SizedBox(height: 24),
                      
                      // Summary Cards
                      _buildSummaryCards(),
                      
                      const SizedBox(height: 24),
                      
                      // Recent Transactions
                      _buildRecentTransactions(),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
      automaticallyImplyLeading: true,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
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
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFF64748B),
                    size: 24,
                  ),
                  onPressed: () => _showSmartNotifications(),
                ),
                // Notification Badge - Only show if notifications are active
                if (NotificationSettings.hasActiveNotifications)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${NotificationSettings.activeNotificationCount}',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Settings Button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
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
            child: IconButton(
              icon: const Icon(
                Icons.settings_outlined,
                color: Color(0xFF64748B),
                size: 24,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const ProfilePage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(
                        CurveTween(curve: curve),
                      );

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF8FAFC),
                Color(0xFFE2E8F0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Merhaba, Hoş Geldiniz! 👋',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Finansal durumunuza bir göz atalım',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E3A8A),
            Color(0xFF3B82F6),
            Color(0xFF06B6D4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Bu Ay',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Toplam Bakiye',
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '₺12,340',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '.00',
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: Color(0xFF10B981),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+2.5%',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF10B981),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Geçen aya göre',
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildAdvancedQuickActionCard(
              icon: Icons.auto_awesome,
              label: 'AI Analiz',
              subtitle: 'Akıllı Öneriler',
              color: const Color(0xFF3B82F6),
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
              ),
              onTap: () => _showAIAnalysis(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildAdvancedQuickActionCard(
              icon: Icons.qr_code_scanner,
              label: 'QR Öde',
              subtitle: 'Hızlı Ödeme',
              color: const Color(0xFF10B981),
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              ),
              onTap: () => _showQRScanner(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildAdvancedQuickActionCard(
              icon: Icons.mic,
              label: 'Sesli İşlem',
              subtitle: 'Konuşarak Ekle',
              color: const Color(0xFFF59E0B),
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
              ),
              onTap: () => _showVoiceInput(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedQuickActionCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120, // SABİT YÜKSEKLİK - Tüm kartlar aynı boyutta!
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // İçeriği ortala
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10), // Biraz küçülttük
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24, // Icon boyutunu küçülttük
              ),
            ),
            const SizedBox(height: 10), // Boşlukları azalttık
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 13, // Font boyutunu küçülttük
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3), // Daha az boşluk
            Text(
              subtitle,
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.8),
                fontSize: 10, // Subtitle daha küçük
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // 🤖 AI ANALIZ ÖZELLİĞİ
  void _showAIAnalysis() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
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
                        'AI Finansal Analiz',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF1F2937),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Yapay zeka destekli akıllı öneriler',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF6B7280),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // AI Insights
            Expanded(
              child: ListView(
                children: [
                  _buildAIInsightCard(
                    '💡 Tasarruf Önerisi',
                    'Kahve harcamalarınızı %30 azaltarak aylık 450₺ tasarruf edebilirsiniz.',
                    const Color(0xFF10B981),
                  ),
                  const SizedBox(height: 16),
                  _buildAIInsightCard(
                    '📊 Harcama Analizi',
                    'Bu ay market harcamalarınız geçen aya göre %15 arttı. Bütçe planı öneriyoruz.',
                    const Color(0xFFF59E0B),
                  ),
                  const SizedBox(height: 16),
                  _buildAIInsightCard(
                    '🎯 Hedef Tavsiyesi',
                    'Mevcut gelirinize göre 3 ay içinde 2.000₺ tasarruf hedefi belirleyebilirsiniz.',
                    const Color(0xFF3B82F6),
                  ),
                  const SizedBox(height: 16),
                  _buildAIInsightCard(
                    '⚠️ Risk Uyarısı',
                    'Kredi kartı harcamalarınız son 2 aydır artış gösteriyor. Dikkatli olun!',
                    const Color(0xFFEF4444),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIInsightCard(String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF1F2937),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.inter(
              color: const Color(0xFF4B5563),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // 📱 QR SCANNER ÖZELLİĞİ
  void _showQRScanner() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            // QR Scanner UI
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 80,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'QR Kod ile Ödeme',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'QR kodu okutarak hızlı ve güvenli ödeme yapın',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'QR Scanner özelliği yakında! 📱',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: const Color(0xFF10B981),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF10B981),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Kamerayı Aç',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 🎤 SESLİ İŞLEM ÖZELLİĞİ
  void _showVoiceInput() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            // Voice Input UI
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Sesli İşlem Ekle',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '"Market alışverişi için 250 lira harcadım" şeklinde konuşun',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Sesli işlem özelliği yakında! 🎤',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                backgroundColor: const Color(0xFFF59E0B),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.all(16),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFF59E0B),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.mic, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Konuşmaya Başla',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 💊 FINANCIAL HEALTH SCORE WIDGET
  Widget _buildFinancialHealthScore() {
    final healthScore = _calculateHealthScore();
    final scoreColor = _getHealthScoreColor(healthScore);
    final scoreStatus = _getHealthScoreStatus(healthScore);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scoreColor.withOpacity(0.1),
            scoreColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: scoreColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: scoreColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: scoreColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.favorite_outlined,
                  color: scoreColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Finansal Sağlık Skoru',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF1F2937),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      scoreStatus,
                      style: GoogleFonts.inter(
                        color: scoreColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Score Display
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: scoreColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: scoreColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  '$healthScore/100',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Skor Dağılımı',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF6B7280),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${(healthScore / 100 * 100).toInt()}%',
                    style: GoogleFonts.inter(
                      color: scoreColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Animated Progress Bar
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: healthScore / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [scoreColor, scoreColor.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: scoreColor.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Health Factors
          Row(
            children: [
              Expanded(
                child: _buildHealthFactor(
                  'Tasarruf',
                  85,
                  Icons.savings_outlined,
                  const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHealthFactor(
                  'Bütçe',
                  72,
                  Icons.account_balance_wallet_outlined,
                  const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHealthFactor(
                  'Hedefler',
                  90,
                  Icons.flag_outlined,
                  const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Action Button
          InkWell(
            onTap: () => _showDetailedHealthAnalysis(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: scoreColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: scoreColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    color: scoreColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Detaylı Analiz Görüntüle',
                    style: GoogleFonts.inter(
                      color: scoreColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthFactor(String title, int score, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            '$score',
            style: GoogleFonts.inter(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Health Score Calculation
  int _calculateHealthScore() {
    // AI-ready calculation based on user data
    final savingsRate = 85; // % of income saved
    final budgetAdherence = 72; // % of budget followed
    final goalProgress = 90; // % of goals achieved
    final spendingPattern = 78; // healthy spending patterns
    
    // Weighted calculation
    final score = (savingsRate * 0.3 + 
                   budgetAdherence * 0.25 + 
                   goalProgress * 0.25 + 
                   spendingPattern * 0.2).round();
    
    return score.clamp(0, 100);
  }

  Color _getHealthScoreColor(int score) {
    if (score >= 80) return const Color(0xFF10B981); // Excellent - Green
    if (score >= 60) return const Color(0xFF3B82F6); // Good - Blue  
    if (score >= 40) return const Color(0xFFF59E0B); // Fair - Orange
    return const Color(0xFFEF4444); // Poor - Red
  }

  String _getHealthScoreStatus(int score) {
    if (score >= 80) return 'Mükemmel Durum';
    if (score >= 60) return 'İyi Durum';
    if (score >= 40) return 'Orta Durum';
    return 'Gelişim Gerekli';
  }

  void _showDetailedHealthAnalysis() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.favorite,
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
                        'Finansal Sağlık Analizi',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF1F2937),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Detaylı performans raporu',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF6B7280),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Detailed Analysis
            Expanded(
              child: ListView(
                children: [
                  _buildDetailedHealthCard(
                    'Tasarruf Oranı',
                    85,
                    'Son 3 ayda %8 artış',
                    'Hedef: Gelirin %20\'si',
                    const Color(0xFF10B981),
                    Icons.savings_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailedHealthCard(
                    'Bütçe Takibi',
                    72,
                    'Bu ay %15 aşım var',
                    'Hedef: %90 uyum oranı',
                    const Color(0xFF3B82F6),
                    Icons.account_balance_wallet_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailedHealthCard(
                    'Hedef Başarısı',
                    90,
                    '3/3 hedef tamamlandı',
                    'Mükemmel performans',
                    const Color(0xFFF59E0B),
                    Icons.flag_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailedHealthCard(
                    'Harcama Alışkanlıkları',
                    78,
                    'Düzenli ve planlı',
                    'Impulsif alımlar azaldı',
                    const Color(0xFF8B5CF6),
                    Icons.psychology_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedHealthCard(
    String title,
    int score,
    String status,
    String description,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF1F2937),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      status,
                      style: GoogleFonts.inter(
                        color: color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$score',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: GoogleFonts.inter(
              color: const Color(0xFF4B5563),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          // Progress bar
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: score / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
         );
   }

       // 🔔 SMART NOTIFICATIONS SYSTEM
    void _showSmartNotifications() {
      // If no notifications are active, redirect to settings
      if (!NotificationSettings.hasActiveNotifications) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Bildirimler kapalı! Ayarlardan açabilirsiniz. ⚙️',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: const Color(0xFF6B7280),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
        return;
      }
      
      showModalBottomSheet(
       context: context,
       isScrollControlled: true,
       backgroundColor: Colors.transparent,
       builder: (context) => Container(
         height: MediaQuery.of(context).size.height * 0.8,
         padding: const EdgeInsets.all(24),
         decoration: const BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
         ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             // Handle
             Center(
               child: Container(
                 width: 40,
                 height: 4,
                 decoration: BoxDecoration(
                   color: const Color(0xFFE5E7EB),
                   borderRadius: BorderRadius.circular(2),
                 ),
               ),
             ),
             const SizedBox(height: 24),
             
             // Header
             Row(
               children: [
                 Container(
                   padding: const EdgeInsets.all(12),
                   decoration: BoxDecoration(
                     gradient: const LinearGradient(
                       colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                     ),
                     borderRadius: BorderRadius.circular(16),
                   ),
                   child: const Icon(
                     Icons.auto_awesome,
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
                         'Akıllı Bildirimler',
                         style: GoogleFonts.inter(
                           color: const Color(0xFF1F2937),
                           fontSize: 20,
                           fontWeight: FontWeight.w700,
                         ),
                       ),
                       Text(
                         'AI destekli kişisel uyarılar',
                         style: GoogleFonts.inter(
                           color: const Color(0xFF6B7280),
                           fontSize: 14,
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                     ],
                   ),
                 ),
                 // Notification Count
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                   decoration: BoxDecoration(
                     color: const Color(0xFFEF4444),
                     borderRadius: BorderRadius.circular(16),
                   ),
                   child: Text(
                     '3 Yeni',
                     style: GoogleFonts.inter(
                       color: Colors.white,
                       fontSize: 12,
                       fontWeight: FontWeight.w700,
                     ),
                   ),
                 ),
               ],
             ),
             
             const SizedBox(height: 24),
             
                           // Notifications List
              Expanded(
                child: ListView(
                  children: [
                    // Only show budget alerts if enabled
                    if (NotificationSettings.budgetAlerts) ...[
                      _buildSmartNotificationCard(
                        'Bütçe Aşım Uyarısı',
                        'Bu ay market harcamalarınız bütçenizi %15 aştı. Dikkatli olun!',
                        '2 dakika önce',
                        const Color(0xFFEF4444),
                        Icons.warning_outlined,
                        true,
                      ),
                      const SizedBox(height: 12),
                    ],
                    
                    // Only show saving tips if enabled
                    if (NotificationSettings.savingTips) ...[
                      _buildSmartNotificationCard(
                        'Tasarruf Fırsatı',
                        'Kahve harcamalarınızı azaltarak aylık 450₺ tasarruf edebilirsiniz.',
                        '1 saat önce',
                        const Color(0xFF10B981),
                        Icons.lightbulb_outlined,
                        true,
                      ),
                      const SizedBox(height: 12),
                    ],
                    
                    // Only show goal updates if enabled
                    if (NotificationSettings.goalUpdates) ...[
                      _buildSmartNotificationCard(
                        'Hedef Başarısı',
                        'Tebrikler! "Tatil Fonu" hedefinizin %80\'ini tamamladınız.',
                        '3 saat önce',
                        const Color(0xFF3B82F6),
                        Icons.flag_outlined,
                        true,
                      ),
                      const SizedBox(height: 12),
                    ],
                    
                    // Only show bill reminders if enabled
                    if (NotificationSettings.billReminders) ...[
                      _buildSmartNotificationCard(
                        'Fatura Hatırlatması',
                        'Elektrik faturanızın son ödeme tarihi 3 gün sonra.',
                        'Dün',
                        const Color(0xFFF59E0B),
                        Icons.receipt_outlined,
                        false,
                      ),
                      const SizedBox(height: 12),
                    ],
                    
                    // Only show daily summary if enabled
                    if (NotificationSettings.dailySummary) ...[
                      _buildSmartNotificationCard(
                        'Günlük Özet',
                        'Bu ay geliriniz geçen aya göre %12 arttı. Harika!',
                        '2 gün önce',
                        const Color(0xFF8B5CF6),
                        Icons.summarize_outlined,
                        false,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
             
             const SizedBox(height: 16),
             
             // Actions
             Row(
               children: [
                 Expanded(
                   child: ElevatedButton(
                     onPressed: () {
                       Navigator.pop(context);
                       _showNotificationSettings();
                     },
                     style: ElevatedButton.styleFrom(
                       backgroundColor: const Color(0xFFF3F4F6),
                       foregroundColor: const Color(0xFF6B7280),
                       padding: const EdgeInsets.symmetric(vertical: 16),
                       elevation: 0,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(12),
                       ),
                     ),
                     child: Text(
                       'Ayarlar',
                       style: GoogleFonts.inter(
                         fontSize: 16,
                         fontWeight: FontWeight.w600,
                       ),
                     ),
                   ),
                 ),
                 const SizedBox(width: 12),
                 Expanded(
                   child: ElevatedButton(
                     onPressed: () {
                       Navigator.pop(context);
                       _markAllNotificationsAsRead();
                     },
                     style: ElevatedButton.styleFrom(
                       backgroundColor: const Color(0xFF3B82F6),
                       foregroundColor: Colors.white,
                       padding: const EdgeInsets.symmetric(vertical: 16),
                       elevation: 0,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(12),
                       ),
                     ),
                     child: Text(
                       'Tümünü Okundu İşaretle',
                       style: GoogleFonts.inter(
                         fontSize: 16,
                         fontWeight: FontWeight.w600,
                       ),
                     ),
                   ),
                 ),
               ],
             ),
           ],
         ),
       ),
     );
   }

   Widget _buildSmartNotificationCard(
     String title,
     String message,
     String time,
     Color color,
     IconData icon,
     bool isNew,
   ) {
     return Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
         color: isNew ? color.withOpacity(0.1) : const Color(0xFFF9FAFB),
         borderRadius: BorderRadius.circular(16),
         border: Border.all(
           color: isNew ? color.withOpacity(0.3) : const Color(0xFFE5E7EB),
         ),
       ),
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           // Icon
           Container(
             padding: const EdgeInsets.all(10),
             decoration: BoxDecoration(
               color: color,
               borderRadius: BorderRadius.circular(12),
             ),
             child: Icon(
               icon,
               color: Colors.white,
               size: 20,
             ),
           ),
           const SizedBox(width: 16),
           
           // Content
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   children: [
                     Expanded(
                       child: Text(
                         title,
                         style: GoogleFonts.inter(
                           color: const Color(0xFF1F2937),
                           fontSize: 16,
                           fontWeight: FontWeight.w700,
                         ),
                       ),
                     ),
                     if (isNew)
                       Container(
                         width: 8,
                         height: 8,
                         decoration: BoxDecoration(
                           color: color,
                           borderRadius: BorderRadius.circular(4),
                         ),
                       ),
                   ],
                 ),
                 const SizedBox(height: 6),
                 Text(
                   message,
                   style: GoogleFonts.inter(
                     color: const Color(0xFF4B5563),
                     fontSize: 14,
                     fontWeight: FontWeight.w500,
                     height: 1.4,
                   ),
                 ),
                 const SizedBox(height: 8),
                 Text(
                   time,
                   style: GoogleFonts.inter(
                     color: const Color(0xFF9CA3AF),
                     fontSize: 12,
                     fontWeight: FontWeight.w500,
                   ),
                 ),
               ],
             ),
           ),
         ],
       ),
     );
   }

   void _showNotificationSettings() {
     showModalBottomSheet(
       context: context,
       backgroundColor: Colors.transparent,
       builder: (context) => Container(
         padding: const EdgeInsets.all(24),
         decoration: const BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
         ),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             // Handle
             Container(
               width: 40,
               height: 4,
               decoration: BoxDecoration(
                 color: const Color(0xFFE5E7EB),
                 borderRadius: BorderRadius.circular(2),
               ),
             ),
             const SizedBox(height: 24),
             
             // Header
             Text(
               'Bildirim Ayarları',
               style: GoogleFonts.inter(
                 color: const Color(0xFF1F2937),
                 fontSize: 20,
                 fontWeight: FontWeight.w700,
               ),
             ),
             const SizedBox(height: 24),
             
             // Settings
             _buildNotificationSetting('Bütçe Uyarıları', 'Harcama limitlerini aştığınızda', true),
             _buildNotificationSetting('Tasarruf Önerileri', 'AI destekli tasarruf fırsatları', true),
             _buildNotificationSetting('Hedef Güncellemeleri', 'Finansal hedef ilerlemeleri', true),
             _buildNotificationSetting('Fatura Hatırlatmaları', 'Ödeme tarihi yaklaştığında', false),
             _buildNotificationSetting('Günlük Özet', 'Günlük harcama raporu', false),
             
             const SizedBox(height: 24),
             
             ElevatedButton(
               onPressed: () => Navigator.pop(context),
               style: ElevatedButton.styleFrom(
                 backgroundColor: const Color(0xFF3B82F6),
                 foregroundColor: Colors.white,
                 padding: const EdgeInsets.symmetric(vertical: 16),
                 minimumSize: const Size(double.infinity, 0),
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(12),
                 ),
               ),
               child: Text(
                 'Kaydet',
                 style: GoogleFonts.inter(
                   fontSize: 16,
                   fontWeight: FontWeight.w600,
                 ),
               ),
             ),
           ],
         ),
       ),
     );
   }

   Widget _buildNotificationSetting(String title, String description, bool isEnabled) {
     return Padding(
       padding: const EdgeInsets.only(bottom: 16),
       child: Row(
         children: [
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   title,
                   style: GoogleFonts.inter(
                     color: const Color(0xFF1F2937),
                     fontSize: 16,
                     fontWeight: FontWeight.w600,
                   ),
                 ),
                 Text(
                   description,
                   style: GoogleFonts.inter(
                     color: const Color(0xFF6B7280),
                     fontSize: 14,
                     fontWeight: FontWeight.w500,
                   ),
                 ),
               ],
             ),
           ),
           Switch(
             value: isEnabled,
             onChanged: (value) {
               // AI-ready: Track user notification preferences
             },
             activeColor: const Color(0xFF3B82F6),
           ),
         ],
       ),
     );
   }

   void _markAllNotificationsAsRead() {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text(
           'Tüm bildirimler okundu olarak işaretlendi! ✅',
           style: GoogleFonts.inter(
             color: Colors.white,
             fontWeight: FontWeight.w600,
           ),
         ),
         backgroundColor: const Color(0xFF10B981),
         behavior: SnackBarBehavior.floating,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(12),
         ),
         margin: const EdgeInsets.all(16),
       ),
     );
   }

   Widget _buildSummaryCards() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Gelir',
              amount: '₺7,000',
              icon: FontAwesomeIcons.arrowTrendUp,
              color: const Color(0xFF10B981),
              percentage: '+12.5%',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              title: 'Gider',
              amount: '₺4,300',
              icon: FontAwesomeIcons.arrowTrendDown,
              color: const Color(0xFFEF4444),
              percentage: '-5.2%',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
    required String percentage,
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
                child: FaIcon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  percentage,
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

  Widget _buildRecentTransactions() {
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
          Row(
            children: [
              Text(
                'Son İşlemler',
                style: GoogleFonts.inter(
                  color: const Color(0xFF1E293B),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Tümünü Gör',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF3B82F6),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTransactionItem(
            title: 'Market Alışverişi',
            subtitle: 'Migros - Bugün 14:30',
            amount: '-₺120.50',
            icon: Icons.shopping_cart_outlined,
            color: const Color(0xFFEF4444),
          ),
          const SizedBox(height: 16),
          _buildTransactionItem(
            title: 'Maaş Ödemesi',
            subtitle: 'ABC Şirketi - Dün 09:00',
            amount: '+₺3,000.00',
            icon: Icons.work_outline,
            color: const Color(0xFF10B981),
          ),
          const SizedBox(height: 16),
          _buildTransactionItem(
            title: 'Netflix Abonelik',
            subtitle: 'Netflix - 2 gün önce',
            amount: '-₺63.99',
            icon: Icons.tv_outlined,
            color: const Color(0xFFEF4444),
          ),
          const SizedBox(height: 16),
          _buildTransactionItem(
            title: 'Freelance Geliri',
            subtitle: 'Proje Ödemesi - 3 gün önce',
            amount: '+₺850.00',
            icon: Icons.computer_outlined,
            color: const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String subtitle,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: const Color(0xFF1E293B),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  color: const Color(0xFF64748B),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: GoogleFonts.inter(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // 🧠 INTELLIGENT INSIGHTS PANEL
  Widget _buildIntelligentInsightsPanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF667EEA),
            Color(0xFF764BA2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with AI Badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.psychology_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'AI İçgörüleri',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'BETA',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Akıllı finansal analizler ve öneriler',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showDetailedInsights(),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // AI Insights Cards
            Row(
              children: [
                Expanded(
                  child: _buildInsightCard(
                    'Harcama Trendi',
                    '+%23',
                    'Bu ay %23 artış',
                    Icons.trending_up_outlined,
                    Colors.white.withOpacity(0.9),
                    const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInsightCard(
                    'Tasarruf Fırsatı',
                    '₺450',
                    'Kahve harcaması',
                    Icons.lightbulb_outlined,
                    Colors.white.withOpacity(0.9),
                    const Color(0xFFF59E0B),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Smart Recommendation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Akıllı Öneri',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Bu ayın sonuna kadar 750₺ tasarruf edebilirsiniz.',
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.6),
                    size: 14,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showPredictiveAnalysis(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ),
                    child: Text(
                      'Tahmin Analizi',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showSpendingPatterns(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF667EEA),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Harcama Deseni',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color backgroundColor,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
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
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: 18,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.more_vert,
                color: const Color(0xFF6B7280),
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              color: const Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              color: accentColor,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // 🔮 AI INSIGHTS ACTIONS
  void _showDetailedInsights() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.psychology_outlined,
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
                        'Detaylı AI İçgörüleri',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF1F2937),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Finansal verilerinizin derin analizi',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF6B7280),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // AI Insights List
            Expanded(
              child: ListView(
                children: [
                  _buildDetailedInsightCard(
                    'Harcama Pattern Analizi',
                    'Hafta sonları %40 daha fazla harcama yapıyorsunuz. Bu pattern son 3 aydır devam ediyor.',
                    Icons.analytics_outlined,
                    const Color(0xFF3B82F6),
                    '85% Doğruluk',
                  ),
                  const SizedBox(height: 16),
                  _buildDetailedInsightCard(
                    'Gelecek Tahmin',
                    'Mevcut harcama trendine göre bu ay 4,500₺ harcayacaksınız. Bütçenizi %8 aşabilirsiniz.',
                    Icons.trending_up_outlined,
                    const Color(0xFFEF4444),
                    'Yüksek Risk',
                  ),
                  const SizedBox(height: 16),
                  _buildDetailedInsightCard(
                    'Kategori Optimizasyonu',
                    'Market harcamalarınızı %15 azaltarak aylık 340₺ tasarruf edebilirsiniz.',
                    Icons.optimization_outlined,
                    const Color(0xFF10B981),
                    'Tasarruf Fırsatı',
                  ),
                  const SizedBox(height: 16),
                  _buildDetailedInsightCard(
                    'Hedef Performansı',
                    'Mevcut tasarruf hızınızla "Tatil Fonu" hedefinizi 2 ay erken tamamlayabilirsiniz.',
                    Icons.flag_outlined,
                    const Color(0xFF8B5CF6),
                    'Başarı Trendi',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'AI Önerileri kaydedildi! 🤖✨',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: const Color(0xFF667EEA),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'AI Önerilerini Uygula',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedInsightCard(
    String title,
    String description,
    IconData icon,
    Color color,
    String badge,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1F2937),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: GoogleFonts.inter(
              color: const Color(0xFF374151),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showPredictiveAnalysis() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tahmin Analizi yakında geliyor! 🔮',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF667EEA),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSpendingPatterns() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Harcama Deseni analizi yakında! 📊',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF764BA2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // 🎨 CUSTOM DRAWER WITH NEW FEATURES
  Widget _buildCustomDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Finora',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'AI Destekli Finans',
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.8),
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
            ),
            
            // New Features Section
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // NEW FEATURES LABEL
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.fiber_new_outlined,
                            color: Color(0xFF10B981),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Yeni Özellikler',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF1F2937),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'BETA',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // AI INSIGHTS
                  _buildDrawerTile(
                    icon: Icons.psychology_outlined,
                    title: 'AI İçgörüleri',
                    subtitle: 'Akıllı finansal analizler',
                    color: const Color(0xFF667EEA),
                    isNew: true,
                    onTap: () {
                      Navigator.pop(context);
                      _showDetailedInsights();
                    },
                  ),
                  
                  // SMART NOTIFICATIONS  
                  _buildDrawerTile(
                    icon: Icons.notifications_active_outlined,
                    title: 'Akıllı Bildirimler',
                    subtitle: 'AI destekli uyarılar',
                    color: const Color(0xFF8B5CF6),
                    isNew: true,
                    onTap: () {
                      Navigator.pop(context);
                      _showSmartNotifications();
                    },
                  ),
                  
                  // FINANCIAL HEALTH
                  _buildDrawerTile(
                    icon: Icons.favorite_outline,
                    title: 'Finansal Sağlık',
                    subtitle: 'Sağlık skoru ve analiz',
                    color: const Color(0xFFEF4444),
                    isNew: true,
                    onTap: () {
                      Navigator.pop(context);
                      _showDetailedHealthAnalysis();
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  Divider(color: const Color(0xFFE5E7EB)),
                  const SizedBox(height: 16),
                  
                  // AI POWERED ACTIONS LABEL
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Color(0xFF3B82F6),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AI Powered İşlemler',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF1F2937),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // AI ANALYSIS
                  _buildDrawerTile(
                    icon: Icons.analytics_outlined,
                    title: 'AI Analiz',
                    subtitle: 'Derin finansal analiz',
                    color: const Color(0xFF10B981),
                    onTap: () {
                      Navigator.pop(context);
                      _showAIAnalysis();
                    },
                  ),
                  
                  // QR PAY
                  _buildDrawerTile(
                    icon: Icons.qr_code_scanner_outlined,
                    title: 'QR Öde',
                    subtitle: 'Hızlı QR ile ödeme',
                    color: const Color(0xFFF59E0B),
                    onTap: () {
                      Navigator.pop(context);
                      _showQRScanner();
                    },
                  ),
                  
                  // VOICE INPUT
                  _buildDrawerTile(
                    icon: Icons.mic_outlined,
                    title: 'Sesli İşlem',
                    subtitle: 'Sesle harcama kaydı',
                    color: const Color(0xFF8B5CF6),
                    onTap: () {
                      Navigator.pop(context);
                      _showVoiceInput();
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  Divider(color: const Color(0xFFE5E7EB)),
                  const SizedBox(height: 16),
                  
                  // STANDARD FEATURES
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      'Standart Özellikler',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF6B7280),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  _buildDrawerTile(
                    icon: Icons.settings_outlined,
                    title: 'Ayarlar',
                    subtitle: 'Uygulama ayarları',
                    color: const Color(0xFF64748B),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Ayarlar sayfası yakında! ⚙️',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: const Color(0xFF64748B),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    },
                  ),
                  
                  _buildDrawerTile(
                    icon: Icons.help_outline,
                    title: 'Yardım',
                    subtitle: 'Destek ve SSS',
                    color: const Color(0xFF64748B),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Yardım merkezi yakında! 🆘',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: const Color(0xFF64748B),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Divider(color: const Color(0xFFE5E7EB)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF667EEA).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.rocket_launch_outlined,
                          color: Color(0xFF667EEA),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Finora v1.0.0',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF1F2937),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'AI destekli finans uygulaması',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF6B7280),
                                fontSize: 12,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isNew = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1F2937),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (isNew) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'YENİ',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF6B7280),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color.withOpacity(0.6),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
