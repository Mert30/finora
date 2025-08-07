import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_theme.dart';

class HelpItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String category;
  final List<String> content;

  HelpItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
    required this.content,
  });
}

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String _selectedCategory = 'Tümü';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _categories = [
    'Tümü',
    'Hesap Yönetimi',
    'İşlemler',
    'Güvenlik',
    'Özellikler',
    'Teknik',
  ];

  final List<HelpItem> _helpItems = [
    HelpItem(
      title: 'Hesap nasıl oluşturabilirim?',
      description: 'Yeni hesap açma süreci hakkında bilgi',
      icon: Icons.person_add_outlined,
      color: const Color(0xFF3B82F6),
      category: 'Hesap Yönetimi',
      content: [
        '1. Ana sayfada "Kayıt Ol" butonuna tıklayın',
        '2. E-posta adresinizi ve güçlü bir şifre girin',
        '3. Hesap bilgilerinizi doğrulayın',
        '4. E-posta adresinize gelen doğrulama linkine tıklayın',
        '5. Hesabınız aktifleştirildi! Giriş yapabilirsiniz.',
      ],
    ),
    HelpItem(
      title: 'Şifremi unuttum, nasıl sıfırlayabilirim?',
      description: 'Şifre sıfırlama adımları',
      icon: Icons.lock_reset,
      color: const Color(0xFFEF4444),
      category: 'Güvenlik',
      content: [
        '1. Giriş sayfasında "Şifremi Unuttum" linkine tıklayın',
        '2. E-posta adresinizi girin',
        '3. E-postanıza gelen şifre sıfırlama linkine tıklayın',
        '4. Yeni şifrenizi belirleyin',
        '5. Şifreniz başarıyla güncellendi!',
      ],
    ),
    HelpItem(
      title: 'İşlem nasıl eklerim?',
      description: 'Gelir ve gider ekleme rehberi',
      icon: Icons.add_circle_outline,
      color: const Color(0xFF10B981),
      category: 'İşlemler',
      content: [
        '1. Alt menüden "Ekle" butonuna tıklayın',
        '2. İşlem tipini seçin (Gelir/Gider)',
        '3. Tutarı girin',
        '4. Kategori seçin',
        '5. Tarih ve açıklama ekleyin',
        '6. "Kaydet" butonuna tıklayın',
      ],
    ),
    HelpItem(
      title: 'Kategorilerimi nasıl düzenlerim?',
      description: 'Kategori yönetimi hakkında bilgi',
      icon: Icons.category_outlined,
      color: const Color(0xFF8B5CF6),
      category: 'Özellikler',
      content: [
        '1. Alt menüden "Kategoriler" sekmesine gidin',
        '2. Gelir/Gider kategorilerini seçin',
        '3. "Yeni Kategori Ekle" butonuna tıklayın',
        '4. Kategori adı, icon ve renk seçin',
        '5. Mevcut kategorileri düzenlemek için üzerine tıklayın',
      ],
    ),
    HelpItem(
      title: 'Hedeflerimi nasıl ayarlarım?',
      description: 'Bütçe hedefleri oluşturma',
      icon: Icons.flag_outlined,
      color: const Color(0xFFF59E0B),
      category: 'Özellikler',
      content: [
        '1. "Hedefler" sekmesine gidin',
        '2. "Yeni Hedef Ekle" butonuna tıklayın',
        '3. Hedef adı ve kategori belirleyin',
        '4. Hedef tutarı ve bitiş tarihi girin',
        '5. İlerlemenizi takip edin',
      ],
    ),
    HelpItem(
      title: 'Verilerim güvende mi?',
      description: 'Güvenlik önlemleri hakkında',
      icon: Icons.security,
      color: const Color(0xFF06B6D4),
      category: 'Güvenlik',
      content: [
        '• Tüm verileriniz SSL ile şifrelenir',
        '• Firebase güvenlik sistemi kullanılır',
        '• Şifreleriniz hash\'lenerek saklanır',
        '• Kişisel bilgileriniz hiçbir zaman paylaşılmaz',
        '• Düzenli güvenlik güncellemeleri yapılır',
      ],
    ),
    HelpItem(
      title: 'Uygulama yavaş çalışıyor',
      description: 'Performans sorunları çözümü',
      icon: Icons.speed,
      color: const Color(0xFFEC4899),
      category: 'Teknik',
      content: [
        '1. Uygulamayı kapatıp yeniden açın',
        '2. İnternet bağlantınızı kontrol edin',
        '3. Uygulamayı güncelleyin',
        '4. Cihazınızı yeniden başlatın',
        '5. Sorun devam ederse bizimle iletişime geçin',
      ],
    ),
    HelpItem(
      title: 'Hesabımı nasıl silerim?',
      description: 'Hesap silme işlemi',
      icon: Icons.delete_outline,
      color: const Color(0xFFEF4444),
      category: 'Hesap Yönetimi',
      content: [
        '1. Ayarlar sayfasına gidin',
        '2. "Hesap Yönetimi" bölümünü bulun',
        '3. "Hesabı Sil" seçeneğine tıklayın',
        '4. Şifrenizi doğrulayın',
        '5. Onay verin (Bu işlem geri alınamaz!)',
      ],
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
    _searchController.dispose();
    super.dispose();
  }

  List<HelpItem> get _filteredItems {
    List<HelpItem> filtered = _helpItems;
    
    // Kategori filtresi
    if (_selectedCategory != 'Tümü') {
      filtered = filtered.where((item) => item.category == _selectedCategory).toList();
    }
    
    // Arama filtresi
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) => 
        item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        item.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return filtered;
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
              
              // Search Bar
              SliverToBoxAdapter(
                child: _buildSearchBar(),
              ),
              
              // Category Filter
              SliverToBoxAdapter(
                child: _buildCategoryFilter(),
              ),
              
              // Contact Cards
              SliverToBoxAdapter(
                child: _buildContactCards(),
              ),
              
              // Help Items
              _buildHelpItems(),
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
                  'Yardım Merkezi 🆘',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.getTextPrimary(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Size nasıl yardımcı olabiliriz?',
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: _searchController,
          style: GoogleFonts.inter(
            color: AppTheme.getTextPrimary(),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Soru arayın...',
            hintStyle: GoogleFonts.inter(
              color: AppTheme.getTextSecondary(),
              fontSize: 16,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: AppTheme.getTextSecondary(),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF3B82F6) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  category,
                  style: GoogleFonts.inter(
                    color: isSelected ? Colors.white : AppTheme.getTextPrimary(),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hızlı İletişim',
            style: GoogleFonts.inter(
              color: AppTheme.getTextPrimary(),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildContactCard(
                  'Canlı Destek',
                  'Hemen sohbet başlat',
                  Icons.chat_outlined,
                  const Color(0xFF10B981),
                  () => _showComingSoon('Canlı destek'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildContactCard(
                  'E-posta',
                  'support@finora.com',
                  Icons.email_outlined,
                  const Color(0xFF3B82F6),
                  () => _showComingSoon('E-posta desteği'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    String title, 
    String subtitle, 
    IconData icon, 
    Color color,
    VoidCallback onTap,
  ) {
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
                color: AppTheme.getTextPrimary(),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppTheme.getTextSecondary(),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItems() {
    final filteredItems = _filteredItems;
    
    if (filteredItems.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF64748B).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_off,
                  size: 64,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Aradığınız soru bulunamadı',
                style: GoogleFonts.inter(
                  color: AppTheme.getTextPrimary(),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Farklı anahtar kelimeler deneyebilirsiniz',
                style: GoogleFonts.inter(
                  color: AppTheme.getTextSecondary(),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    }

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
                    'Sıkça Sorulan Sorular',
                    style: GoogleFonts.inter(
                      color: AppTheme.getTextPrimary(),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${filteredItems.length} soru bulundu',
                    style: GoogleFonts.inter(
                      color: AppTheme.getTextSecondary(),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildHelpCard(filteredItems[index]),
                ],
              );
            }
            
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _buildHelpCard(filteredItems[index]),
            );
          },
          childCount: filteredItems.length,
        ),
      ),
    );
  }

  Widget _buildHelpCard(HelpItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: item.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            item.icon,
            color: item.color,
            size: 20,
          ),
        ),
        title: Text(
          item.title,
          style: GoogleFonts.inter(
            color: AppTheme.getTextPrimary(),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            item.description,
            style: GoogleFonts.inter(
              color: AppTheme.getTextSecondary(),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: item.content.map((step) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    step,
                    style: GoogleFonts.inter(
                      color: AppTheme.getTextPrimary(),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                );
              }).toList(),
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
          '$feature yakında kullanıma sunulacak! 🚀',
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