import 'package:finora_app/features/about/presentation/about_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsOfUsePage extends StatefulWidget {
  const TermsOfUsePage({super.key});

  @override
  State<TermsOfUsePage> createState() => _TermsOfUsePageState();
}

class _TermsOfUsePageState extends State<TermsOfUsePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

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

              // Content
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildContent(),
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
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AboutPage()),
            ),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF1F2937),
              size: 20,
            ),
          ),
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
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Kullanım Koşulları',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Son güncelleme: 15 Aralık 2024',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF6B7280),
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
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Introduction
          _buildIntroSection(),
          const SizedBox(height: 32),

          // Terms Sections
          _buildTermsSection(
            '1. Hizmet Tanımı',
            [
              'FINŌRA, kişisel finans yönetimi için tasarlanmış bir mobil uygulamadır.',
              'Uygulama gelir, gider takibi, bütçe planlaması ve finansal analiz araçları sunar.',
              'Hizmetlerimiz sürekli geliştirilmekte ve güncellenebilir.',
            ],
            Icons.info_outline,
            const Color(0xFF3B82F6),
          ),

          _buildTermsSection(
            '2. Kullanıcı Sorumlulukları',
            [
              'Hesap bilgilerinizin güvenliğinden tamamen siz sorumlusunuz.',
              'Doğru ve güncel bilgiler sağlamanız gerekmektedir.',
              'Uygulamayı yasa dışı amaçlarla kullanmazsınız.',
              'Üçüncü şahısların haklarını ihlal etmeyeceksiniz.',
            ],
            Icons.person_outline,
            const Color(0xFF10B981),
          ),

          _buildTermsSection(
            '3. Gizlilik ve Veri Güvenliği',
            [
              'Kişisel verileriniz en yüksek güvenlik standartlarıyla korunur.',
              'Finansal bilgileriniz şifrelenerek saklanır.',
              'Verileri üçüncü taraflarla paylaşmayız.',
              'Detaylı bilgi için Gizlilik Politikamızı inceleyebilirsiniz.',
            ],
            Icons.security_outlined,
            const Color(0xFF8B5CF6),
          ),

          _buildTermsSection(
            '4. İçerik ve Fikri Mülkiyet',
            [
              'Uygulama içeriği telif hakkı ile korunmaktadır.',
              'İzinsiz kopyalama, dağıtma yasaktır.',
              'Ticari marka ve logoları kullanılamaz.',
              'Kullanıcı tarafından oluşturulan içerik size aittir.',
            ],
            Icons.copyright_outlined,
            const Color(0xFFF59E0B),
          ),

          _buildTermsSection(
            '5. Hizmet Kesintileri',
            [
              'Teknik bakım sırasında geçici kesintiler olabilir.',
              'Planli bakımlar önceden duyurulur.',
              'Acil durum kesintilerinde en kısa sürede çözüm sağlanır.',
              'Veri kaybı durumunda yedeklerden geri yükleme yapılır.',
            ],
            Icons.build_outlined,
            const Color(0xFFEF4444),
          ),

          _buildTermsSection(
            '6. Ödeme ve Abonelik',
            [
              'Premium özellikler ücretli abonelik gerektirir.',
              'Ödeme Google Play üzerinden güvenli şekilde alınır.',
              'İptal durumunda veri erişimi devam eder.',
              'Ücret iadesi platform politikalarına göre yapılır.',
            ],
            Icons.payment_outlined,
            const Color(0xFF06B6D4),
          ),

          _buildTermsSection(
            '7. Sorumluluk Reddi',
            [
              'Finansal kararlarınızdan tamamen siz sorumlusunuz.',
              'Uygulama sadece bilgi amaçlı araçlar sunar.',
              'Yatırım tavsiyesi verilmez.',
              'Teknik hatalardan kaynaklanan zararlardan sorumlu değiliz.',
            ],
            Icons.warning_amber_outlined,
            const Color(0xFFDC2626),
          ),

          _buildTermsSection(
            '8. Değişiklikler',
            [
              'Bu koşullar önceden bildirim ile değiştirilebilir.',
              'Önemli değişiklikler uygulama içinde duyurulur.',
              'Kullanmaya devam etmeniz değişiklikleri kabul ettiğiniz anlamına gelir.',
              'Güncel koşulları düzenli olarak kontrol etmenizi öneririz.',
            ],
            Icons.update_outlined,
            const Color(0xFF7C3AED),
          ),

          // Contact Information
          const SizedBox(height: 32),
          _buildContactSection(),

          // Footer
          const SizedBox(height: 32),
          _buildFooter(),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildIntroSection() {
    return Container(
      padding: const EdgeInsets.all(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.handshake_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Hoş Geldiniz!',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'FINŌRA uygulamasını kullanarak aşağıdaki kullanım koşullarını kabul etmiş olursunuz. Lütfen dikkatlice okuyunuz.',
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection(
    String title,
    List<String> items,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF1F2937),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < items.length - 1 ? 12 : 0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF374151),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.support_agent_outlined,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'İletişim',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1F2937),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Sorularınız veya önerileriniz için bizimle iletişime geçebilirsiniz:',
            style: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            Icons.email_outlined,
            'E-posta',
            'support@finora.com',
            const Color(0xFF3B82F6),
          ),
          const SizedBox(height: 12),
          _buildContactItem(
            Icons.language_outlined,
            'Website',
            'www.finora.com',
            const Color(0xFF10B981),
          ),
          const SizedBox(height: 12),
          _buildContactItem(
            Icons.help_outline,
            'Yardım Merkezi',
            'Uygulama içi yardım bölümü',
            const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: GoogleFonts.inter(
            color: const Color(0xFF1F2937),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.account_balance_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'FINŌRA',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '©2025 FINŌRA. Tüm hakları saklıdır.',
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Bu kullanım koşulları Türkiye Cumhuriyeti yasalarına göre düzenlenmiştir.',
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
