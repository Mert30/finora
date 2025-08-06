import 'package:finora_app/features/main_screen/presentation/pages/main_screen.dart';
import 'package:finora_app/features/password_reset/presentation/pages/password_reset__page.dart';
import 'package:flutter/material.dart';
import '../widgets/settings_tile.dart';
import '../widgets/section_header.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
        ),
        centerTitle: true,
        title: const Text('Ayarlar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionHeader(title: 'Hesap'),
          const SettingsTile(
            icon: Icons.person,
            title: 'Profil Bilgilerim',
            onTap: null, // Profil sayfasına yönlendirme yapılabilir
          ),
          SettingsTile(
            icon: Icons.lock_outline,
            title: 'Şifre Değiştir',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const PasswordResetPage(),
                ),
              );
            },
          ),

          const SectionHeader(title: 'Uygulama'),
          const SettingsTile(
            icon: Icons.language,
            title: 'Dil Seçimi',
            onTap: null,
          ),
          const SettingsTile(
            icon: Icons.dark_mode,
            title: 'Karanlık Tema',
            onTap: null,
          ),

          const SectionHeader(title: 'Destek'),
          const SettingsTile(
            icon: Icons.help_outline,
            title: 'Yardım / Destek',
            onTap: null,
          ),
          const SettingsTile(
            icon: Icons.feedback_outlined,
            title: 'Geri Bildirim',
            onTap: null,
          ),

          const SectionHeader(title: 'Hesap'),
          SettingsTile(
            icon: Icons.logout,
            title: 'Çıkış Yap',
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () {
              // Firebase signOut vs yapılabilir
            },
          ),
        ],
      ),
    );
  }
}
