import 'package:finora_app/features/budgets/presentation/budget_goals_page.dart';
import 'package:finora_app/features/categories/presentation/category_management_page.dart';
import 'package:finora_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:finora_app/features/markets/presentation/live_markets_page.dart';
import 'package:finora_app/features/transactions/presentation/pages/history_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../transactions/presentation/pages/add_transaction_page.dart';

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
    HistoryPage(),
    BudgetGoalsPage(),
    CategoryManagementPage(),
    // ProfilePage removed - accessible via Settings
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSuperDrawer(),
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
        ],
      ),
    );
  }

  // 🚀 SUPER PREMIUM DRAWER
  Widget _buildSuperDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFFF8FAFC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 🎨 PREMIUM HEADER
            _buildDrawerHeader(),

            // 📱 MAIN CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // 🤖 AI ÖZELLİKLERİ
                    _buildSectionHeader(
                      'AI Özellikleri',
                      Icons.smart_toy_outlined,
                    ),
                    _buildAIFeatures(),

                    const SizedBox(height: 24),

                    // 🛠️ ARAÇLAR & YÖNETİM
                    _buildSectionHeader(
                      'Araçlar & Yönetim',
                      Icons.build_outlined,
                    ),
                    _buildToolsAndUtilities(),

                    const SizedBox(height: 24),

                    // ⚡ HIZLI ERİŞİM
                    _buildSectionHeader(
                      'Hızlı Erişim',
                      Icons.flash_on_outlined,
                    ),
                    _buildQuickActions(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // 🚀 FOOTER
            _buildDrawerFooter(),
          ],
        ),
      ),
    );
  }

  // 🎨 HEADER WIDGET
  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(topRight: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FINŌRA',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Yapay Zeka Destekli Finans',
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'v1.0 Beta',
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
        ],
      ),
    );
  }

  // 📋 SECTION HEADER
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF667EEA), size: 16),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF374151),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // 🏠 MAIN NAVIGATION
  Widget _buildMainNavigation() {
    return Column(
      children: [
        _buildDrawerTile(
          icon: Icons.dashboard_outlined,
          title: 'Dashboard',
          subtitle: 'Finansal özet ve AI içgörüleri',
          color: const Color(0xFF3B82F6),
          isSelected: _currentIndex == 0,
          onTap: () {
            Navigator.pop(context);
            setState(() => _currentIndex = 0);
          },
        ),
        _buildDrawerTile(
          icon: Icons.add_circle_outline,
          title: 'İşlem Ekle',
          subtitle: 'Yeni gelir/gider kaydı',
          color: const Color(0xFF10B981),
          isSelected: _currentIndex == 1,
          onTap: () {
            Navigator.pop(context);
            setState(() => _currentIndex = 1);
          },
        ),
        _buildDrawerTile(
          icon: Icons.history_outlined,
          title: 'İşlem Geçmişi',
          subtitle: 'Detaylı analiz ve filtreler',
          color: const Color(0xFFF59E0B),
          isSelected: _currentIndex == 2,
          onTap: () {
            Navigator.pop(context);
            setState(() => _currentIndex = 2);
          },
        ),
        _buildDrawerTile(
          icon: Icons.flag_outlined,
          title: 'Bütçe Hedefleri',
          subtitle: 'Hedef belirleme ve takip',
          color: const Color(0xFF8B5CF6),
          isSelected: _currentIndex == 3,
          onTap: () {
            Navigator.pop(context);
            setState(() => _currentIndex = 3);
          },
        ),
        _buildDrawerTile(
          icon: Icons.category_outlined,
          title: 'Kategori Yönetimi',
          subtitle: 'Özel kategoriler oluştur',
          color: const Color(0xFFEC4899),
          isSelected: _currentIndex == 4,
          onTap: () {
            Navigator.pop(context);
            setState(() => _currentIndex = 4);
          },
        ),
      ],
    );
  }

  // 🤖 AI FEATURES
  Widget _buildAIFeatures() {
    return Column(
      children: [
        _buildDrawerTile(
          icon: Icons.analytics_outlined,
          title: 'AI Analiz',
          subtitle: 'Gelişmiş finansal analiz',
          color: const Color(0xFF6366F1),
          showBadge: true,
          badgeText: 'AI',
          onTap: () {
            Navigator.pop(context);
            _showAIAnalysis();
          },
        ),
        _buildDrawerTile(
          icon: Icons.health_and_safety_outlined,
          title: 'Finansal Sağlık Skoru',
          subtitle: 'AI destekli sağlık analizi',
          color: const Color(0xFF059669),
          showBadge: true,
          badgeText: 'SMART',
          onTap: () {
            Navigator.pop(context);
            _showHealthScoreDetails();
          },
        ),
        _buildDrawerTile(
          icon: Icons.psychology_outlined,
          title: 'Akıllı İçgörüler',
          subtitle: 'Kişiselleştirilmiş öneriler',
          color: const Color(0xFF7C3AED),
          showBadge: true,
          badgeText: 'NEW',
          onTap: () {
            Navigator.pop(context);
            _showIntelligentInsights();
          },
        ),
        _buildDrawerTile(
          icon: Icons.notifications_active_outlined,
          title: 'Akıllı Bildirimler',
          subtitle: 'Öngörülü uyarı sistemi',
          color: const Color(0xFFDC2626),
          showBadge: true,
          badgeText: 'LIVE',
          onTap: () {
            Navigator.pop(context);
            _showSmartNotifications();
          },
        ),
      ],
    );
  }

  // 🛠️ TOOLS & UTILITIES
  Widget _buildToolsAndUtilities() {
    return Column(
      children: [
        _buildDrawerTile(
          icon: Icons.trending_up_outlined,
          title: 'Tahmin Analizi',
          subtitle: 'Gelecek harcama tahmini',
          color: const Color(0xFF059669),
          onTap: () {
            Navigator.pop(context);
            _showPredictiveAnalysis();
          },
        ),
        _buildDrawerTile(
          icon: Icons.pattern_outlined,
          title: 'Harcama Deseni',
          subtitle: 'Alışkanlık analizi',
          color: const Color(0xFFEA580C),
          onTap: () {
            Navigator.pop(context);
            _showSpendingPatterns();
          },
        ),
        _buildDrawerTile(
          icon: Icons.trending_up_outlined,
          title: 'Canlı Piyasalar',
          subtitle: 'Borsa, döviz ve altın takibi',
          color: const Color(0xFF059669),
          showBadge: true,
          badgeText: 'LIVE',
          onTap: () {
            Navigator.pop(context);
            _showLiveMarkets();
          },
        ),
      ],
    );
  }

  // ⚡ QUICK ACTIONS
  Widget _buildQuickActions() {
    return Column(
      children: [
        _buildDrawerTile(
          icon: Icons.qr_code_scanner_outlined,
          title: 'QR Öde',
          subtitle: 'Hızlı QR kod ödemesi',
          color: const Color(0xFF0891B2),
          showBadge: true,
          badgeText: 'FAST',
          onTap: () {
            Navigator.pop(context);
            _showQRScanner();
          },
        ),
        _buildDrawerTile(
          icon: Icons.mic_outlined,
          title: 'Sesli İşlem',
          subtitle: 'Ses komutu ile kayıt',
          color: const Color(0xFFB91C1C),
          showBadge: true,
          badgeText: 'VOICE',
          onTap: () {
            Navigator.pop(context);
            _showVoiceInput();
          },
        ),
        _buildDrawerTile(
          icon: Icons.flash_on_outlined,
          title: 'Hızlı İşlem',
          subtitle: 'Tek dokunuşla kayıt',
          color: const Color(0xFFD97706),
          onTap: () {
            Navigator.pop(context);
            _showQuickTransaction();
          },
        ),
        _buildDrawerTile(
          icon: Icons.share_outlined,
          title: 'Rapor Paylaş',
          subtitle: 'Finansal rapor gönder',
          color: const Color(0xFF6B21A8),
          onTap: () {
            Navigator.pop(context);
            _showReportShare();
          },
        ),
      ],
    );
  }

  // 🎨 PREMIUM DRAWER TILE
  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isSelected = false,
    bool showBadge = false,
    String badgeText = '',
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.15) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? color.withOpacity(0.3)
                    : const Color(0xFFE5E7EB),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                if (!isSelected)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                if (isSelected)
                  BoxShadow(
                    color: color.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? color : color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : color,
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
                          Expanded(
                            child: Text(
                              title,
                              style: GoogleFonts.inter(
                                color: isSelected
                                    ? color
                                    : const Color(0xFF1F2937),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (showBadge) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                badgeText,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
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
                const SizedBox(width: 8),
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

  // 🚀 FOOTER
  Widget _buildDrawerFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  const Color(0xFFE5E7EB),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.rocket_launch_outlined,
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
                      'FINŌRA v1.0',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF1F2937),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Geleceğin finans uygulaması',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF6B7280),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'BETA',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF10B981),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🎯 PLACEHOLDER FUNCTIONS
  void _showAIAnalysis() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🤖 AI Analiz özelliği çok yakında!'),
        backgroundColor: const Color(0xFF6366F1),
      ),
    );
  }

  void _showHealthScoreDetails() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('💚 Finansal Sağlık Skoru detayları yükleniyor...'),
        backgroundColor: const Color(0xFF059669),
      ),
    );
  }

  void _showIntelligentInsights() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🧠 Akıllı İçgörüler hazırlanıyor...'),
        backgroundColor: const Color(0xFF7C3AED),
      ),
    );
  }

  void _showSmartNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔔 Akıllı Bildirimler sistemi aktifleştiriliyor...'),
        backgroundColor: const Color(0xFFDC2626),
      ),
    );
  }

  void _showPredictiveAnalysis() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📊 Tahmin Analizi hesaplanıyor...'),
        backgroundColor: const Color(0xFF059669),
      ),
    );
  }

  void _showSpendingPatterns() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📈 Harcama Desenleri analiz ediliyor...'),
        backgroundColor: const Color(0xFFEA580C),
      ),
    );
  }

  void _showSecurityCenter() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔒 Güvenlik Merkezi açılıyor...'),
        backgroundColor: const Color(0xFF7F1D1D),
      ),
    );
  }

  void _showBackupSync() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('☁️ Yedekleme ve Senkronizasyon başlatılıyor...'),
        backgroundColor: const Color(0xFF374151),
      ),
    );
  }

  void _showQRScanner() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📱 QR Kod tarayıcısı açılıyor...'),
        backgroundColor: const Color(0xFF0891B2),
      ),
    );
  }

  void _showVoiceInput() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎤 Sesli İşlem sistemi hazırlanıyor...'),
        backgroundColor: const Color(0xFFB91C1C),
      ),
    );
  }

  void _showQuickTransaction() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('⚡ Hızlı İşlem modu aktifleştiriliyor...'),
        backgroundColor: const Color(0xFFD97706),
      ),
    );
  }

  void _showReportShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📤 Rapor paylaşım seçenekleri hazırlanıyor...'),
        backgroundColor: const Color(0xFF6B21A8),
      ),
    );
  }

  void _showLiveMarkets() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LiveMarketsPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}
