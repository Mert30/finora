import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:finora_app/features/about/presentation/pages/about_page.dart';
import 'package:finora_app/features/help/presentation/pages/help_center_page.dart';
import 'package:finora_app/features/legal/presentation/pages/terms_of_use_page.dart';
import 'package:finora_app/features/legal/presentation/pages/privacy_policy_page.dart';

class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String memberSince;
  final String profileImageUrl;
  final bool isVerified;
  final String accountType;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.memberSince,
    required this.profileImageUrl,
    required this.isVerified,
    required this.accountType,
  });
}

class ProfileStats {
  final int totalTransactions;
  final double totalIncome;
  final double totalExpense;
  final int activeGoals;
  final int categoriesUsed;

  ProfileStats({
    required this.totalTransactions,
    required this.totalIncome,
    required this.totalExpense,
    required this.activeGoals,
    required this.categoriesUsed,
  });
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Demo data
  final UserProfile _userProfile = UserProfile(
    name: 'Ahmet Yılmaz',
    email: 'ahmet.yilmaz@email.com',
    phone: '+90 555 123 45 67',
    memberSince: '15 Ocak 2024',
    profileImageUrl: '',
    isVerified: true,
    accountType: 'Premium',
  );

  final ProfileStats _stats = ProfileStats(
    totalTransactions: 127,
    totalIncome: 85000,
    totalExpense: 42000,
    activeGoals: 5,
    categoriesUsed: 12,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

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
              
              // Profile Header
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildProfileHeader(),
                ),
              ),
              
              // Stats Section
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildStatsSection(),
                ),
              ),
              
              // Quick Actions
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildQuickActions(),
                ),
              ),
              
              // Account Settings
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildAccountSettings(),
                ),
              ),
              
              // Support & Legal
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildSupportSection(),
                ),
              ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
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
      automaticallyImplyLeading: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF1F2937),
              size: 20,
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () => _showEditProfile(),
              icon: const Icon(
                Icons.edit_outlined,
                color: Color(0xFF1F2937),
                size: 20,
              ),
            ),
          ),
        ),
      ],
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
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profil 👤',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hesap bilgilerinizi yönetin',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Profile Picture & Basic Info
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
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
                  child: Center(
                    child: Text(
                      _userProfile.name.split(' ').map((e) => e[0]).join(),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _userProfile.name,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF1F2937),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (_userProfile.isVerified)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.verified,
                                    color: Color(0xFF10B981),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Doğrulandı',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF10B981),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userProfile.accountType,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF8B5CF6),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Üye: ${_userProfile.memberSince}',
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
            
            // Contact Information
            _buildContactInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      children: [
        _buildContactItem(
          icon: Icons.email_outlined,
          label: 'E-posta',
          value: _userProfile.email,
          color: const Color(0xFF3B82F6),
        ),
        const SizedBox(height: 16),
        _buildContactItem(
          icon: Icons.phone_outlined,
          label: 'Telefon',
          value: _userProfile.phone,
          color: const Color(0xFF10B981),
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
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
                  label,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1F2937),
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

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hesap İstatistikleri',
            style: GoogleFonts.inter(
              color: const Color(0xFF1F2937),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Toplam İşlem',
                  value: _stats.totalTransactions.toString(),
                  icon: Icons.receipt_long_outlined,
                  color: const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: 'Aktif Hedef',
                  value: _stats.activeGoals.toString(),
                  icon: Icons.flag_outlined,
                  color: const Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Toplam Gelir',
                  value: '₺${_stats.totalIncome.toStringAsFixed(0)}',
                  icon: Icons.trending_up_outlined,
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: 'Toplam Gider',
                  value: '₺${_stats.totalExpense.toStringAsFixed(0)}',
                  icon: Icons.trending_down_outlined,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hızlı İşlemler',
            style: GoogleFonts.inter(
              color: const Color(0xFF1F2937),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  title: 'Rapor İndir',
                  subtitle: 'PDF/Excel raporu',
                  icon: Icons.download_outlined,
                  color: const Color(0xFF3B82F6),
                  onTap: () => _showComingSoon('Rapor indirme'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickActionCard(
                  title: 'Yedekle',
                  subtitle: 'Verileri yedekle',
                  icon: Icons.backup_outlined,
                  color: const Color(0xFF10B981),
                  onTap: () => _showComingSoon('Veri yedekleme'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                color: const Color(0xFF1F2937),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                color: const Color(0xFF6B7280),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSettings() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hesap Ayarları',
            style: GoogleFonts.inter(
              color: const Color(0xFF1F2937),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
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
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.security_outlined,
                  title: 'Güvenlik',
                  subtitle: 'Şifre ve 2FA ayarları',
                  color: const Color(0xFF3B82F6),
                  onTap: () => _showComingSoon('Güvenlik ayarları'),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Bildirimler',
                  subtitle: 'Bildirim tercihlerinizi yönetin',
                  color: const Color(0xFF8B5CF6),
                  onTap: () => _showComingSoon('Bildirim ayarları'),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.language_outlined,
                  title: 'Dil & Bölge',
                  subtitle: 'Türkçe, TRY',
                  color: const Color(0xFF10B981),
                  onTap: () => _showComingSoon('Dil ayarları'),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.palette_outlined,
                  title: 'Tema',
                  subtitle: 'Açık tema',
                  color: const Color(0xFFEC4899),
                  onTap: () => _showComingSoon('Tema ayarları'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Destek & Yasal',
            style: GoogleFonts.inter(
              color: const Color(0xFF1F2937),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
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
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.help_outline,
                  title: 'Yardım Merkezi',
                  subtitle: 'SSS ve destek',
                  color: const Color(0xFF3B82F6),
                  onTap: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const HelpCenterPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: animation.drive(
                            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
                          ),
                          child: child,
                        );
                      },
                    ),
                  ),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Kullanım Koşulları',
                  subtitle: 'Şartlar ve koşullar',
                  color: const Color(0xFF6B7280),
                  onTap: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const TermsOfUsePage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: animation.drive(
                            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
                          ),
                          child: child,
                        );
                      },
                    ),
                  ),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Gizlilik Politikası',
                  subtitle: 'Veri kullanımı ve gizlilik',
                  color: const Color(0xFF6B7280),
                  onTap: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const PrivacyPolicyPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: animation.drive(
                            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
                          ),
                          child: child,
                        );
                      },
                    ),
                  ),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'Hakkında',
                  subtitle: 'Uygulama bilgileri ve teknolojiler',
                  color: const Color(0xFF3B82F6),
                  onTap: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const AboutPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: animation.drive(
                            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
                          ),
                          child: child,
                        );
                      },
                    ),
                  ),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.logout_outlined,
                  title: 'Çıkış Yap',
                  subtitle: 'Hesabınızdan çıkış yapın',
                  color: const Color(0xFFEF4444),
                  onTap: () {
                    print('🔥 Çıkış Yap butonuna tıklandı!');
                    _showLogoutConfirmation();
                  },
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: () {
        print('📱 InkWell tıklandı: $title');
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Icon Container
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: isDestructive ? color : const Color(0xFF1F2937),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF6B7280),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFF6B7280),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: const Color(0xFFE5E7EB),
      indent: 60,
      endIndent: 20,
    );
  }

  void _showEditProfile() {
    _showComingSoon('Profil düzenleme');
  }

  void _showLogoutConfirmation() {
    print('🚨 _showLogoutConfirmation çağrıldı!'); // Debug için
    
    showDialog(
      context: context,
      barrierDismissible: true, // Dialog dışına tıklayınca kapansın
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout_outlined,
                color: Color(0xFFEF4444),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Çıkış Yap',
                style: GoogleFonts.inter(
                  color: const Color(0xFF1F2937),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hesabınızdan çıkış yapmak istediğinizden emin misiniz?',
              style: GoogleFonts.inter(
                color: const Color(0xFF6B7280),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bu işlem sizi ana sayfaya yönlendirecektir.',
              style: GoogleFonts.inter(
                color: const Color(0xFF9CA3AF),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    print('🚫 İptal butonuna basıldı');
                    Navigator.pop(dialogContext);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Color(0xFFE5E7EB),
                      ),
                    ),
                  ),
                  child: Text(
                    'İptal',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF6B7280),
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
                    print('✅ Çıkış Yap butonuna basıldı');
                    Navigator.pop(dialogContext);
                    _showComingSoon('Çıkış yapma işlemi');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Çıkış Yap',
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
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature özelliği yakında! 🚀',
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
}