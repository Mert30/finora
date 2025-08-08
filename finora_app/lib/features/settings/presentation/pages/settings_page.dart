import 'package:finora_app/features/about/presentation/about_page.dart';
import 'package:finora_app/features/feedback/presentation/feedback_page.dart';
import 'package:finora_app/features/help/presentation/help_center_page.dart';
import 'package:finora_app/features/main_screen/presentation/pages/main_screen.dart';
import 'package:finora_app/features/password_reset/presentation/pages/password_reset__page.dart';
import 'package:finora_app/features/profile/presentation/profile_page.dart';
import 'package:finora_app/features/settings/presentation/pages/currency_settings_page.dart';
import 'package:finora_app/features/settings/presentation/pages/language_settings_page.dart';
import 'package:finora_app/features/welcome/presentation/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Notification Settings Model
class NotificationSettings {
  static bool budgetAlerts = true;
  static bool savingTips = true;
  static bool goalUpdates = true;
  static bool billReminders = false;
  static bool dailySummary = false;

  static bool get hasActiveNotifications =>
      budgetAlerts ||
      savingTips ||
      goalUpdates ||
      billReminders ||
      dailySummary;

  static int get activeNotificationCount {
    int count = 0;
    if (budgetAlerts) count++;
    if (savingTips) count++;
    if (goalUpdates) count++;
    return count; // Only show count for important ones
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              // Custom App Bar
              _buildCustomAppBar(),

              // Content
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Profile Card
                      _buildProfileCard(user),

                      const SizedBox(height: 30),

                      // Settings Sections
                      _buildSettingsSection('Hesap & Güvenlik', [
                        _buildSettingsTile(
                          icon: Icons.person_outline,
                          title: 'Profil Bilgileri',
                          subtitle: 'Kişisel bilgilerinizi düzenleyin',
                          onTap: () => {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            ),
                          },
                        ),
                        _buildSettingsTile(
                          icon: Icons.security_outlined,
                          title: 'Güvenlik',
                          subtitle: 'Şifre ve güvenlik ayarları',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PasswordResetPage(),
                              ),
                            );
                          },
                        ),
                        _buildToggleSettingsTile(
                          icon: Icons.fingerprint_outlined,
                          title: 'Biyometrik Giriş',
                          subtitle: 'Parmak izi ile giriş yapın',
                          value: _biometricEnabled,
                          onChanged: (value) {
                            setState(() {
                              _biometricEnabled = value;
                            });
                          },
                        ),
                      ]),

                      const SizedBox(height: 24),

                      _buildSettingsSection('Uygulama', [
                        const SizedBox(height: 12),
                        _buildSettingsSection('Bildirimler', [
                          _buildToggleSettingsTile(
                            icon: Icons.warning_outlined,
                            title: 'Bütçe Uyarıları',
                            subtitle:
                                'Harcama limitlerini aştığınızda bildirim alın',
                            value: NotificationSettings.budgetAlerts,
                            onChanged: (value) {
                              setState(() {
                                NotificationSettings.budgetAlerts = value;
                              });
                            },
                          ),
                          _buildToggleSettingsTile(
                            icon: Icons.lightbulb_outlined,
                            title: 'Tasarruf Önerileri',
                            subtitle:
                                'AI destekli tasarruf fırsatları hakkında bilgi alın',
                            value: NotificationSettings.savingTips,
                            onChanged: (value) {
                              setState(() {
                                NotificationSettings.savingTips = value;
                              });
                            },
                          ),
                          _buildToggleSettingsTile(
                            icon: Icons.flag_outlined,
                            title: 'Hedef Güncellemeleri',
                            subtitle: 'Finansal hedeflerinizdeki ilerlemeler',
                            value: NotificationSettings.goalUpdates,
                            onChanged: (value) {
                              setState(() {
                                NotificationSettings.goalUpdates = value;
                              });
                            },
                          ),
                          _buildToggleSettingsTile(
                            icon: Icons.receipt_outlined,
                            title: 'Fatura Hatırlatmaları',
                            subtitle:
                                'Ödeme tarihleri yaklaştığında hatırlatma',
                            value: NotificationSettings.billReminders,
                            onChanged: (value) {
                              setState(() {
                                NotificationSettings.billReminders = value;
                              });
                            },
                          ),
                          _buildToggleSettingsTile(
                            icon: Icons.summarize_outlined,
                            title: 'Günlük Özet',
                            subtitle: 'Günlük harcama raporu ve özetler',
                            value: NotificationSettings.dailySummary,
                            onChanged: (value) {
                              setState(() {
                                NotificationSettings.dailySummary = value;
                              });
                            },
                          ),
                        ]),
                        const SizedBox(height: 10),
                        _buildSettingsTile(
                          icon: Icons.language_outlined,
                          title: 'Dil',
                          subtitle: 'Türkçe',
                          onTap: () => {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LanguageSettingsPage(),
                              ),
                            ),
                          },
                        ),
                        _buildSettingsTile(
                          icon: Icons.currency_exchange_outlined,
                          title: 'Para Birimi',
                          subtitle: 'TL (Türk Lirası)',
                          onTap: () => {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CurrencySettingsPage(),
                              ),
                            ),
                          },
                        ),
                      ]),

                      const SizedBox(height: 24),

                      _buildSettingsSection('Destek', [
                        _buildSettingsTile(
                          icon: Icons.help_outline,
                          title: 'Yardım Merkezi',
                          subtitle: 'SSS ve yardım dökümanları',
                          onTap: () => {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HelpCenterPage(),
                              ),
                            ),
                          },
                        ),
                        _buildSettingsTile(
                          icon: Icons.feedback_outlined,
                          title: 'Geri Bildirim',
                          subtitle: 'Önerilerinizi paylaşın',
                          onTap: () => {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FeedbackPage(),
                              ),
                            ),
                          },
                        ),
                        _buildSettingsTile(
                          icon: Icons.star_outline,
                          title: 'Uygulamayı Değerlendir',
                          subtitle: 'Google Play\'den puan verin',
                          onTap: () => _showComingSoon(context),
                        ),
                      ]),

                      const SizedBox(height: 24),

                      _buildSettingsSection('Hakkında', [
                        _buildSettingsTile(
                          icon: Icons.info_outline,
                          title: 'Hakkında',
                          subtitle: 'Uygulama hakkında bilgiler',
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutPage(),
                            ),
                          ),
                        ),
                      ]),

                      const SizedBox(height: 24),

                      _buildSettingsSection('Hesap', [
                        _buildSettingsTile(
                          icon: Icons.logout_outlined,
                          title: 'Çıkış Yap',
                          subtitle: 'Hesabınızdan güvenli şekilde çıkın',
                          isDestructive: true,
                          onTap: () => _showLogoutDialog(context),
                        ),
                      ]),

                      const SizedBox(height: 32),

                      // App Version
                      _buildAppVersion(),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return SliverAppBar(
      expandedHeight: 90,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFFF8FAFC),
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
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
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF64748B),
            size: 20,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
        ),
      ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Ayarlar',
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),

                Text(
                  'Kişiselleştirin ve özelleştirin',
                  style: GoogleFonts.inter(
                    fontSize: 15,
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

  Widget _buildProfileCard(User? user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6), Color(0xFF06B6D4)],
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
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(Icons.person, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? 'Kullanıcı',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? 'kullanici@finora.com',
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Standart Üye',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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

  Widget _buildSettingsSection(String title, List<Widget> tiles) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 16),
            child: Text(
              title,
              style: GoogleFonts.inter(
                color: const Color(0xFF1E293B),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
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
            child: Column(children: tiles),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDestructive
                      ? const Color(0xFFEF4444).withOpacity(0.1)
                      : const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: isDestructive
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF3B82F6),
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
                        color: isDestructive
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF1E293B),
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
              Icon(
                Icons.arrow_forward_ios,
                color: const Color(0xFF94A3B8),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFF3B82F6), size: 20),
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
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF3B82F6),
          ),
        ],
      ),
    );
  }

  Widget _buildAppVersion() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              'lib/features/welcome/assets/images/finora_logo.png',
              height: 24,
              width: 24,
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
                    color: const Color(0xFF1E293B),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Sürüm 1.0.0',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF64748B),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Güncel',
              style: GoogleFonts.inter(
                color: const Color(0xFF10B981),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Yakında Geliyor! 🚀',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Bu özellik üzerinde çalışıyoruz. Çok yakında kullanıma sunulacak!',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Tamam',
              style: GoogleFonts.inter(
                color: const Color(0xFF3B82F6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Çıkış Yap',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Hesabınızdan çıkış yapmak istediğinizden emin misiniz?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'İptal',
              style: GoogleFonts.inter(
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
              );
            },
            child: Text(
              'Çıkış Yap',
              style: GoogleFonts.inter(
                color: const Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
