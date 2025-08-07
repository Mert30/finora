import 'package:finora_app/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpItem {
  final String title;
  final String description;
  final String category;
  final IconData icon;

  HelpItem({
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
  });
}

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Tümü';

  final List<String> _categories = [
    'Tümü',
    'Hesap',
    'İşlemler',
    'Güvenlik',
    'Teknik',
    'Faturalar',
  ];

  final List<HelpItem> _helpItems = [
    HelpItem(
      title: 'Hesabımı nasıl oluştururum?',
      description:
          'Yeni hesap oluşturmak için ana sayfadaki "Kayıt Ol" butonuna tıklayın. E-posta adresinizi, güçlü bir şifre belirleyin ve telefon numaranızı doğrulayın.',
      category: 'Hesap',
      icon: Icons.person_add_outlined,
    ),
    HelpItem(
      title: 'Şifremi unuttum, nasıl sıfırlarım?',
      description:
          'Giriş sayfasında "Şifremi Unuttum" linkine tıklayın. Kayıtlı e-posta adresinizi girin, size şifre sıfırlama linki gönderilecektir.',
      category: 'Hesap',
      icon: Icons.lock_reset_outlined,
    ),
    HelpItem(
      title: 'Nasıl para transferi yaparım?',
      description:
          'Ana sayfadan "Transfer" seçeneğini seçin. Alıcının hesap bilgilerini girin, tutarı belirleyin ve transfer işlemini onaylayın.',
      category: 'İşlemler',
      icon: Icons.send_outlined,
    ),
    HelpItem(
      title: 'İşlem geçmişimi nasıl görüntülerim?',
      description:
          'Menüden "Geçmiş" sekmesine gidin. Burada tüm işlemlerinizi tarih, tutar ve işlem türüne göre filtreleyebilirsiniz.',
      category: 'İşlemler',
      icon: Icons.history_outlined,
    ),
    HelpItem(
      title: 'Hesabım güvenli mi?',
      description:
          'Evet! 256-bit SSL şifreleme, iki faktörlü doğrulama ve gelişmiş fraud koruması ile hesabınız maksimum güvenlik altında.',
      category: 'Güvenlik',
      icon: Icons.security_outlined,
    ),
    HelpItem(
      title: 'İki faktörlü doğrulamayı nasıl aktifleştiririm?',
      description:
          'Ayarlar > Güvenlik bölümünden "İki Faktörlü Doğrulama" seçeneğini açın. SMS veya authenticator app ile doğrulama kurabilirsiniz.',
      category: 'Güvenlik',
      icon: Icons.verified_user_outlined,
    ),
    HelpItem(
      title: 'Uygulama yavaş çalışıyor',
      description:
          'Uygulamayı tamamen kapatıp tekrar açmayı deneyin. Sorun devam ederse ayarlardan cache temizleme yapabilirsiniz.',
      category: 'Teknik',
      icon: Icons.speed_outlined,
    ),
    HelpItem(
      title: 'Bildirimler gelmiyor',
      description:
          'Cihazınızın bildirim ayarlarını kontrol edin. Uygulama ayarlarından da bildirim izinlerinin açık olduğundan emin olun.',
      category: 'Teknik',
      icon: Icons.notifications_outlined,
    ),
  ];

  List<HelpItem> get _filteredItems {
    List<HelpItem> filtered = _selectedCategory == 'Tümü'
        ? _helpItems
        : _helpItems
              .where((item) => item.category == _selectedCategory)
              .toList();

    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where(
            (item) =>
                item.title.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ||
                item.description.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ),
          )
          .toList();
    }

    return filtered;
  }

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
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
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

              // Search Bar
              SliverToBoxAdapter(child: _buildSearchBar()),

              // Category Filter
              SliverToBoxAdapter(child: _buildCategoryFilter()),

              // Contact Cards
              SliverToBoxAdapter(child: _buildContactCards()),

              // Help Items
              _buildHelpItems(),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return SliverAppBar(
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
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
        ),
      ),
      expandedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFFF8FAFC),
      elevation: 0,
      automaticallyImplyLeading: true,
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Yardım Merkezi',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Size nasıl yardımcı olabiliriz?',
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
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
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Sorunuzu aratın...',
            hintStyle: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: const Icon(
              Icons.search_outlined,
              color: Color(0xFF6B7280),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
          style: GoogleFonts.inter(
            color: const Color(0xFF1F2937),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: FilterChip(
              label: Text(
                category,
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : const Color(0xFF1F2937),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF3B82F6),
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFFE5E7EB),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContactCards() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: _buildContactCard(
              title: 'Canlı Destek',
              subtitle: '7/24 müşteri hizmetleri',
              icon: Icons.support_agent_outlined,
              color: const Color(0xFF10B981),
              onTap: () => _showComingSoon('Canlı destek'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildContactCard(
              title: 'E-posta',
              subtitle: 'destek@finora.com',
              icon: Icons.email_outlined,
              color: const Color(0xFF3B82F6),
              onTap: () => _showComingSoon('E-posta desteği'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
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
              child: Icon(icon, color: color, size: 24),
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

  Widget _buildHelpItems() {
    final items = _filteredItems;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sık Sorulan Sorular',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1F2937),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${items.length} sonuç bulundu',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF6B7280),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                _buildHelpCard(items[index]),
              ],
            );
          }

          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _buildHelpCard(items[index]),
          );
        }, childCount: items.length),
      ),
    );
  }

  Widget _buildHelpCard(HelpItem item) {
    return Container(
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
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(item.icon, color: const Color(0xFF3B82F6), size: 20),
        ),
        title: Text(
          item.title,
          style: GoogleFonts.inter(
            color: const Color(0xFF1F2937),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              item.description,
              style: GoogleFonts.inter(
                color: const Color(0xFF6B7280),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
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
