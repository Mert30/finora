import 'package:finora_app/features/budgets/presentation/budget_goals_page.dart';
import 'package:finora_app/features/categories/presentation/category_management_page.dart';
import 'package:finora_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:finora_app/features/transactions/presentation/pages/history_page.dart';
import 'package:finora_app/features/profile/presentation/pages/profile_page.dart';
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
    HistoryPage(transactions: []),
    BudgetGoalsPage(),
    CategoryManagementPage(),
    // ProfilePage removed - accessible via Settings
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
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          color: isSelected ? color : const Color(0xFF1F2937),
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