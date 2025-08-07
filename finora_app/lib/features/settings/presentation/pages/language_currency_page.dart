import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/currency/currency_service.dart';

class LanguageCurrencyPage extends StatefulWidget {
  const LanguageCurrencyPage({super.key});

  @override
  State<LanguageCurrencyPage> createState() => _LanguageCurrencyPageState();
}

class _LanguageCurrencyPageState extends State<LanguageCurrencyPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedLanguage = 'tr';
  Currency _selectedCurrency = CurrencyService.currentCurrency;

  final List<LanguageOption> _languages = [
    LanguageOption('tr', 'Türkçe', 'Turkish', '🇹🇷'),
    LanguageOption('en', 'English', 'English', '🇺🇸'),
    LanguageOption('de', 'Deutsch', 'German', '🇩🇪'),
    LanguageOption('fr', 'Français', 'French', '🇫🇷'),
    LanguageOption('es', 'Español', 'Spanish', '🇪🇸'),
    LanguageOption('ar', 'العربية', 'Arabic', '🇸🇦'),
  ];

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
              
              // Language Section
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildLanguageSection(),
                ),
              ),
              
              // Currency Section
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildCurrencySection(),
                ),
              ),
              
              // Preview Section
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildPreviewSection(),
                ),
              ),
              
              // Save Button
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildSaveButton(),
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
                  'Dil & Para Birimi 🌍',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tercihlerinizi seçin',
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

  Widget _buildLanguageSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dil Seçimi',
            style: GoogleFonts.inter(
              color: const Color(0xFF1F2937),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Uygulamanın dilini seçin',
            style: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w500,
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
              children: _languages.asMap().entries.map((entry) {
                final index = entry.key;
                final language = entry.value;
                final isSelected = _selectedLanguage == language.code;
                
                return Column(
                  children: [
                    _buildLanguageTile(language, isSelected),
                    if (index < _languages.length - 1) _buildDivider(),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(LanguageOption language, bool isSelected) {
    return ListTile(
      onTap: () {
        setState(() {
          _selectedLanguage = language.code;
          // Update recommended currencies based on language
          final recommendedCurrencies = CurrencyService.getCurrenciesForLanguage(language.code);
          if (!recommendedCurrencies.contains(_selectedCurrency)) {
            _selectedCurrency = recommendedCurrencies.first;
          }
        });
      },
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF3B82F6).withOpacity(0.1)
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF3B82F6)
                : const Color(0xFFE5E7EB),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            language.flag,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
      title: Text(
        language.nativeName,
        style: GoogleFonts.inter(
          color: isSelected 
              ? const Color(0xFF3B82F6)
              : const Color(0xFF1F2937),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        language.englishName,
        style: GoogleFonts.inter(
          color: const Color(0xFF6B7280),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: isSelected
          ? Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            )
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }

  Widget _buildCurrencySection() {
    final availableCurrencies = CurrencyService.getCurrenciesForLanguage(_selectedLanguage);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Para Birimi',
            style: GoogleFonts.inter(
              color: const Color(0xFF1F2937),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Seçilen dile uygun para birimler',
            style: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w500,
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
              children: availableCurrencies.asMap().entries.map((entry) {
                final index = entry.key;
                final currency = entry.value;
                final isSelected = _selectedCurrency.code == currency.code;
                
                return Column(
                  children: [
                    _buildCurrencyTile(currency, isSelected),
                    if (index < availableCurrencies.length - 1) _buildDivider(),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyTile(Currency currency, bool isSelected) {
    return ListTile(
      onTap: () {
        setState(() {
          _selectedCurrency = currency;
        });
      },
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF10B981).withOpacity(0.1)
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF10B981)
                : const Color(0xFFE5E7EB),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            currency.flag,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
      title: Row(
        children: [
          Text(
            currency.symbol,
            style: GoogleFonts.inter(
              color: isSelected 
                  ? const Color(0xFF10B981)
                  : const Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              currency.code,
              style: GoogleFonts.inter(
                color: isSelected 
                    ? const Color(0xFF10B981)
                    : const Color(0xFF1F2937),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(
        CurrencyService.getCurrencyName(currency.code, _selectedLanguage),
        style: GoogleFonts.inter(
          color: const Color(0xFF6B7280),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: isSelected
          ? Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            )
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }

  Widget _buildPreviewSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
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
                    Icons.preview_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Önizleme',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildPreviewItem(
              'Dil',
              _languages.firstWhere((l) => l.code == _selectedLanguage).nativeName,
              Icons.language_outlined,
            ),
            const SizedBox(height: 16),
            _buildPreviewItem(
              'Para Birimi',
              '${_selectedCurrency.symbol} ${_selectedCurrency.code}',
              Icons.monetization_on_outlined,
            ),
            const SizedBox(height: 16),
            _buildPreviewItem(
              'Örnek Tutar',
              CurrencyService.formatAmount(1234.56, currency: _selectedCurrency),
              Icons.account_balance_wallet_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(0.8),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    color: Colors.white,
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

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF059669)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: _saveSettings,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.save_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Ayarları Kaydet',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: const Color(0xFFE5E7EB),
      indent: 76,
      endIndent: 20,
    );
  }

  void _saveSettings() {
    // Save language and currency settings
    CurrencyService.setCurrency(_selectedCurrency);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Ayarlar başarıyla kaydedildi! 🎉',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );

    // Navigate back after a short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }
}

class LanguageOption {
  final String code;
  final String nativeName;
  final String englishName;
  final String flag;

  LanguageOption(this.code, this.nativeName, this.englishName, this.flag);
}