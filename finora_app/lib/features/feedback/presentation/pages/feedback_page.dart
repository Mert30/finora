import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_theme.dart';

class FeedbackType {
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  FeedbackType({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  int _selectedRating = 0;
  FeedbackType? _selectedType;
  bool _isSubmitting = false;

  final List<FeedbackType> _feedbackTypes = [
    FeedbackType(
      name: 'Özellik İsteği',
      description: 'Yeni özellik önerinizi paylaşın',
      icon: Icons.lightbulb_outlined,
      color: const Color(0xFFF59E0B),
    ),
    FeedbackType(
      name: 'Hata Bildirimi',
      description: 'Karşılaştığınız sorunları bildirin',
      icon: Icons.bug_report_outlined,
      color: const Color(0xFFEF4444),
    ),
    FeedbackType(
      name: 'Genel Görüş',
      description: 'Uygulama hakkındaki düşünceleriniz',
      icon: Icons.chat_outlined,
      color: const Color(0xFF3B82F6),
    ),
    FeedbackType(
      name: 'Performans',
      description: 'Hız ve performans sorunları',
      icon: Icons.speed,
      color: const Color(0xFF8B5CF6),
    ),
    FeedbackType(
      name: 'Tasarım',
      description: 'Arayüz ve kullanıcı deneyimi',
      icon: Icons.palette_outlined,
      color: const Color(0xFFEC4899),
    ),
    FeedbackType(
      name: 'Diğer',
      description: 'Diğer konulardaki geri bildirimler',
      icon: Icons.more_horiz,
      color: const Color(0xFF64748B),
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
    _titleController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null) {
      _showSnackBar('Lütfen geri bildirim türünü seçin', isError: true);
      return;
    }
    if (_selectedRating == 0) {
      _showSnackBar('Lütfen puanlama yapın', isError: true);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulated submission
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
    });

    _showSnackBar('Geri bildiriminiz başarıyla gönderildi! Teşekkürler 🙏');
    _resetForm();
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _titleController.clear();
    _descriptionController.clear();
    _emailController.clear();
    setState(() {
      _selectedRating = 0;
      _selectedType = null;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError 
            ? const Color(0xFFEF4444) 
            : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
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
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating Section
                        _buildRatingSection(),
                        
                        const SizedBox(height: 32),
                        
                        // Feedback Type Selection
                        _buildFeedbackTypeSection(),
                        
                        const SizedBox(height: 32),
                        
                        // Title Input
                        _buildTitleInput(),
                        
                        const SizedBox(height: 24),
                        
                        // Description Input
                        _buildDescriptionInput(),
                        
                        const SizedBox(height: 24),
                        
                        // Email Input
                        _buildEmailInput(),
                        
                        const SizedBox(height: 32),
                        
                        // Submit Button
                        _buildSubmitButton(),
                        
                        const SizedBox(height: 24),
                        
                        // Footer
                        _buildFooter(),
                      ],
                    ),
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
      expandedHeight: 100,
      floating: false,
      pinned: true,
                  backgroundColor: const Color(0xFFF8FAFC),
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
                  'Geri Bildirim 💬',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.getTextPrimary(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Görüşleriniz bizim için çok değerli',
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

  Widget _buildRatingSection() {
    return Container(
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.star_outline,
                  color: Color(0xFFF59E0B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Finora\'yı nasıl değerlendirirsiniz?',
                      style: GoogleFonts.inter(
                        color: AppTheme.getTextPrimary(),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Deneyiminizi puanlayın',
                      style: GoogleFonts.inter(
                        color: AppTheme.getTextSecondary(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRating = index + 1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      index < _selectedRating ? Icons.star : Icons.star_outline,
                      color: index < _selectedRating 
                          ? const Color(0xFFF59E0B) 
                          : const Color(0xFFE2E8F0),
                      size: 36,
                    ),
                  ),
                ),
              );
            }),
          ),
          if (_selectedRating > 0) ...[
            const SizedBox(height: 16),
            Center(
              child: Text(
                _getRatingText(_selectedRating),
                style: GoogleFonts.inter(
                  color: const Color(0xFFF59E0B),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1: return 'Çok kötü 😞';
      case 2: return 'Kötü 😕';
      case 3: return 'Orta 😐';
      case 4: return 'İyi 😊';
      case 5: return 'Mükemmel 🤩';
      default: return '';
    }
  }

  Widget _buildFeedbackTypeSection() {
    return Container(
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
          Text(
            'Geri Bildirim Türü',
            style: GoogleFonts.inter(
              color: AppTheme.getTextPrimary(),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hangi konuda geri bildirim vermek istiyorsunuz?',
            style: GoogleFonts.inter(
              color: AppTheme.getTextSecondary(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _feedbackTypes.length,
            itemBuilder: (context, index) {
              final type = _feedbackTypes[index];
              final isSelected = _selectedType == type;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedType = type;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? type.color.withOpacity(0.1) 
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? type.color : const Color(0xFFE2E8F0),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        type.icon,
                        color: isSelected ? type.color : const Color(0xFF64748B),
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        type.name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: isSelected ? type.color : AppTheme.getTextPrimary(),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        type.description,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: AppTheme.getTextSecondary(),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTitleInput() {
    return Container(
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
          Text(
            'Başlık',
            style: GoogleFonts.inter(
              color: AppTheme.getTextPrimary(),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _titleController,
            style: GoogleFonts.inter(
              color: AppTheme.getTextPrimary(),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Geri bildiriminizi özetleyin',
              hintStyle: GoogleFonts.inter(
                color: AppTheme.getTextSecondary(),
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen başlık girin';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return Container(
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
          Text(
            'Detaylı Açıklama',
            style: GoogleFonts.inter(
              color: AppTheme.getTextPrimary(),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _descriptionController,
            maxLines: 5,
            style: GoogleFonts.inter(
              color: AppTheme.getTextPrimary(),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Lütfen deneyiminizi detaylı olarak anlatın...',
              hintStyle: GoogleFonts.inter(
                color: AppTheme.getTextSecondary(),
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen açıklama girin';
              }
              if (value.length < 10) {
                return 'Açıklama en az 10 karakter olmalıdır';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmailInput() {
    return Container(
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
          Text(
            'E-posta Adresi (İsteğe bağlı)',
            style: GoogleFonts.inter(
              color: AppTheme.getTextPrimary(),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Size geri dönüş yapabilmemiz için',
            style: GoogleFonts.inter(
              color: AppTheme.getTextSecondary(),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.inter(
              color: AppTheme.getTextPrimary(),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'ornek@email.com',
              hintStyle: GoogleFonts.inter(
                color: AppTheme.getTextSecondary(),
                fontSize: 16,
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: AppTheme.getTextSecondary(),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (!value.contains('@')) {
                  return 'Geçerli bir e-posta adresi girin';
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3B82F6),
            Color(0xFF8B5CF6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: _isSubmitting ? null : _submitFeedback,
          child: Center(
            child: _isSubmitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Gönder',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.info_outline,
              color: Color(0xFF3B82F6),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Geri bildiriminiz anonim olarak işlenir ve yalnızca ürün geliştirme için kullanılır.',
              style: GoogleFonts.inter(
                color: AppTheme.getTextSecondary(),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}