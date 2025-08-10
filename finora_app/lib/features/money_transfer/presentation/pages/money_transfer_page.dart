import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/core/services/firebase_service.dart';
import '/core/models/firebase_models.dart';

class MoneyTransferPage extends StatefulWidget {
  const MoneyTransferPage({super.key});

  @override
  State<MoneyTransferPage> createState() => _MoneyTransferPageState();
}

class _MoneyTransferPageState extends State<MoneyTransferPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Form controllers
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _recipientNameController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Form states
  String _selectedTransferType = 'Telefon'; // Changed to Telefon for user search
  FirebaseCard? _selectedFromCard;
  bool _isLoading = false;
  
  // Firebase data
  List<FirebaseCard> _userCards = [];
  List<FirebaseUserProfile> _searchResults = [];
  FirebaseUserProfile? _selectedRecipient;
  String? _currentUserId;
  bool _isLoadingCards = true;
  bool _isSearching = false;

  final List<String> _transferTypes = ['Telefon', 'IBAN', 'QR Kod'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
    
    // Load Firebase data
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      _currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (_currentUserId == null) {
        setState(() => _isLoadingCards = false);
        return;
      }

      debugPrint('💳 Loading user cards for: $_currentUserId');

      final cards = await CardService.getCards(_currentUserId!);
      debugPrint('📋 Retrieved ${cards.length} cards');

      setState(() {
        _userCards = cards;
        if (_userCards.isNotEmpty) {
          _selectedFromCard = _userCards.first;
        }
        _isLoadingCards = false;
      });

      debugPrint('✅ User cards loaded successfully');
    } catch (e) {
      debugPrint('💥 Error loading user data: $e');
      setState(() => _isLoadingCards = false);
    }
  }

  Future<void> _searchUsers(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _selectedRecipient = null;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      debugPrint('🔍 Searching users with query: $query');
      
      // Search users by name, email, or phone
      final users = await UserService.searchUsers(query);
      debugPrint('👥 Found ${users.length} users');

      // Remove current user from results
      final filteredUsers = users.where((user) => user.userId != _currentUserId).toList();
      
      setState(() {
        _searchResults = filteredUsers;
        _isSearching = false;
      });
    } catch (e) {
      debugPrint('💥 Error searching users: $e');
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _amountController.dispose();
    _recipientNameController.dispose();
    _ibanController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: CustomScrollView(
            slivers: [
              _buildCustomAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFromCardSelection(),
                      const SizedBox(height: 24),
                      _buildAmountSection(),
                      const SizedBox(height: 24),
                      _buildTransferTypeSelection(),
                      const SizedBox(height: 24),
                      _buildRecipientSection(),
                      const SizedBox(height: 24),
                      _buildDescriptionSection(),
                      const SizedBox(height: 32),
                      _buildTransferButton(),
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
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFFF8FAFC),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
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
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF64748B),
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
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
            child: IconButton(
              icon: const Icon(
                Icons.contact_phone_outlined,
                color: Color(0xFF64748B),
                size: 24,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('📞 Kişiler özelliği çok yakında!'),
                    backgroundColor: const Color(0xFF10B981),
                  ),
                );
              },
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF8FAFC),
                Color(0xFFE2E8F0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 70, bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Para Gönder',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            'Hızlı ve güvenli para transferi',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'GÜVENLİ',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF10B981),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
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

  Widget _buildFromCardSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gönderen Kart',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
        _buildCardSelector(),
      ],
    );
  }

  Widget _buildCardSelector() {
    if (_isLoadingCards) {
      return Container(
        height: 120,
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
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
          ),
        ),
      );
    }

    if (_userCards.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
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
            Icon(
              Icons.credit_card_off,
              size: 48,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Henüz kartınız yok',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Para göndermek için önce bir kart eklemelisiniz',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF94A3B8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
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
      child: Column(
        children: _userCards.asMap().entries.map((entry) {
          final index = entry.key;
          final card = entry.value;
          final isSelected = _selectedFromCard?.id == card.id;
          final isLast = index == _userCards.length - 1;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFromCard = card;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF10B981).withOpacity(0.05) : Colors.transparent,
                borderRadius: BorderRadius.vertical(
                  top: index == 0 ? const Radius.circular(16) : Radius.zero,
                  bottom: isLast ? const Radius.circular(16) : Radius.zero,
                ),
                border: isSelected ? Border.all(
                  color: const Color(0xFF10B981),
                  width: 2,
                ) : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 38,
                    decoration: BoxDecoration(
                      color: card.color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.credit_card,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              card.bankName,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (card.isDefault)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'VARSAYILAN',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              card.maskedCardNumber,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              card.formattedBalance,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF10B981),
                      size: 24,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gönderilecek Miktar',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '₺',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1F2937),
                      ),
                      decoration: InputDecoration(
                        hintText: '0,00',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFE5E7EB),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                children: ['100', '500', '1000', '2500'].map((amount) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _amountController.text = amount;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF10B981).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        '${amount}₺',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransferTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transfer Yöntemi',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: _transferTypes.map((type) {
            final isSelected = type == _selectedTransferType;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTransferType = type;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(
                    right: type != _transferTypes.last ? 8 : 0,
                    left: type != _transferTypes.first ? 4 : 0,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF10B981) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
                    ),
                    boxShadow: [
                      if (isSelected) BoxShadow(
                        color: const Color(0xFF10B981).withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getTransferTypeIcon(type),
                        color: isSelected ? Colors.white : const Color(0xFF6B7280),
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        type,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : const Color(0xFF6B7280),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecipientSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alıcı Bilgileri',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
        
        // User search for Telefon transfer type
        if (_selectedTransferType == 'Telefon') ...[
          _buildUserSearchSection(),
        ] else ...[
          // Traditional IBAN/QR input
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
              children: [
                _buildTextField(
                  controller: _recipientNameController,
                  label: 'Alıcı Adı Soyadı',
                  hint: 'Tam ad giriniz',
                  icon: Icons.person_outlined,
                ),
                const SizedBox(height: 20),
                if (_selectedTransferType == 'IBAN')
                  _buildTextField(
                    controller: _ibanController,
                    label: 'IBAN',
                    hint: 'TR00 0000 0000 0000 0000 0000 00',
                    icon: Icons.account_balance_outlined,
                  ),
                if (_selectedTransferType == 'QR Kod')
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            size: 40,
                            color: Colors.grey.withOpacity(0.6),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'QR Kod Tarayıcı',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            '(Yakında)',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUserSearchSection() {
    return Container(
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
          Text(
            'Kullanıcı Ara',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (value) {
              _searchUsers(value);
            },
            decoration: InputDecoration(
              hintText: 'İsim, e-posta veya telefon numarası',
              hintStyle: GoogleFonts.inter(
                color: const Color(0xFF9CA3AF),
                fontSize: 14,
              ),
              prefixIcon: _isSearching
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6B7280)),
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.search,
                      color: Color(0xFF6B7280),
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          
          // Selected user display
          if (_selectedRecipient != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF10B981),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFF10B981),
                    child: Text(
                      _getInitials(_selectedRecipient!.name),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedRecipient!.name,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        if (_selectedRecipient!.email.isNotEmpty)
                          Text(
                            _selectedRecipient!.email,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.check_circle,
                    color: const Color(0xFF10B981),
                    size: 24,
                  ),
                ],
              ),
            ),
          ],
          
          // Search results
          if (_searchResults.isNotEmpty && _selectedRecipient == null) ...[
            const SizedBox(height: 16),
            Text(
              'Arama Sonuçları',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final user = _searchResults[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRecipient = user;
                        _recipientNameController.text = user.name;
                        _searchResults = [];
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFF6B7280),
                            child: Text(
                              _getInitials(user.name),
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1F2937),
                                  ),
                                ),
                                if (user.email.isNotEmpty)
                                  Text(
                                    user.email,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Color(0xFF6B7280),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Açıklama (Opsiyonel)',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
        Container(
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
          child: TextField(
            controller: _descriptionController,
            maxLines: 3,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              hintText: 'Transfer açıklaması giriniz...',
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF9CA3AF),
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: GoogleFonts.inter(
            fontSize: 16,
            color: const Color(0xFF1F2937),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF9CA3AF),
            ),
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF6B7280),
              size: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE5E7EB),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE5E7EB),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF10B981),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransferButton() {
    final isValid = _selectedFromCard != null && 
                   _amountController.text.isNotEmpty &&
                   _recipientNameController.text.isNotEmpty &&
                   (_selectedTransferType != 'IBAN' || _ibanController.text.isNotEmpty) &&
                   (_selectedTransferType != 'Telefon' || _phoneController.text.isNotEmpty);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isValid && !_isLoading ? _showTransferConfirmation : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF10B981),
          disabledBackgroundColor: const Color(0xFFE5E7EB),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.send_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Para Gönder',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  IconData _getTransferTypeIcon(String type) {
    switch (type) {
      case 'IBAN':
        return Icons.account_balance_outlined;
      case 'Telefon':
        return Icons.phone_outlined;
      case 'QR Kod':
        return Icons.qr_code_scanner_outlined;
      default:
        return Icons.send_outlined;
    }
  }

  List<Map<String, dynamic>> _getMyCards() {
    return [
      {
        'id': 'card_1',
        'bankName': 'İş Bankası',
        'cardNumber': '**** **** **** 1234',
        'balance': '15.750,00 ₺',
        'color': const Color(0xFF1E40AF),
      },
      {
        'id': 'card_2',
        'bankName': 'Akbank',
        'cardNumber': '**** **** **** 5678',
        'balance': '8.450,00 ₺',
        'color': const Color(0xFFDC2626),
      },
      {
        'id': 'card_3',
        'bankName': 'Garanti BBVA',
        'cardNumber': '**** **** **** 9012',
        'balance': '22.100,00 ₺',
        'color': const Color(0xFF059669),
      },
    ];
  }

  void _showTransferConfirmation() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                    Icons.check_circle_outlined,
                    color: Color(0xFF10B981),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transfer Onayı',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        'Bilgileri kontrol edin',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Column(
                children: [
                  _buildConfirmationItem('Gönderilen Miktar', '${_amountController.text} ₺'),
                  _buildConfirmationItem('Alıcı', _recipientNameController.text),
                  _buildConfirmationItem('Transfer Yöntemi', _selectedTransferType),
                  if (_selectedTransferType == 'IBAN')
                    _buildConfirmationItem('IBAN', _ibanController.text),
                  if (_selectedTransferType == 'Telefon')
                    _buildConfirmationItem('Telefon', _phoneController.text),
                  _buildConfirmationItem('İşlem Ücreti', '0,00 ₺'),
                  const Divider(),
                  _buildConfirmationItem('Toplam Tutar', '${_amountController.text} ₺', isTotal: true),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'İptal',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _processTransfer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Onayla ve Gönder',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationItem(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: const Color(0xFF6B7280),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              color: isTotal ? const Color(0xFF10B981) : const Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processTransfer() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Validation
      if (_selectedFromCard == null) {
        _showErrorMessage('Lütfen gönderen kartı seçin');
        return;
      }

      if (_selectedTransferType == 'Telefon' && _selectedRecipient == null) {
        _showErrorMessage('Lütfen alıcı kullanıcıyı seçin');
        return;
      }

      if (_amountController.text.trim().isEmpty) {
        _showErrorMessage('Lütfen transfer tutarını girin');
        return;
      }

      final transferAmount = double.tryParse(_amountController.text.trim());
      if (transferAmount == null || transferAmount <= 0) {
        _showErrorMessage('Geçerli bir tutar girin');
        return;
      }

      // Check balance
      if (_selectedFromCard!.balance < transferAmount) {
        _showErrorMessage('Yetersiz bakiye. Kart bakiyesi: ${_selectedFromCard!.formattedBalance}');
        return;
      }

      debugPrint('💸 Processing transfer: ₺$transferAmount');
      debugPrint('📤 From: ${_selectedFromCard!.bankName} - ${_selectedFromCard!.maskedCardNumber}');
      debugPrint('📥 To: ${_selectedRecipient?.name ?? 'External'}');

      // Create transaction for sender (expense)
      final senderTransaction = FirebaseTransaction(
        id: '', // Will be set by Firestore
        userId: _currentUserId!,
        title: 'Para Transferi',
        category: 'Transfer',
        amount: transferAmount,
        date: DateTime.now(),
        isIncome: false, // Expense for sender
        iconName: 'transfer',
        colorHex: '#EF4444', // Red for expense
        description: _descriptionController.text.trim().isEmpty 
            ? 'Para transferi - ${_selectedRecipient?.name ?? 'Alıcı'}'
            : _descriptionController.text.trim(),
        categoryId: null,
        cardId: _selectedFromCard!.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save sender transaction
      final senderTransactionId = await TransactionService.createTransaction(senderTransaction);
      debugPrint('✅ Sender transaction created: $senderTransactionId');

      // Update sender card balance
      final newSenderBalance = _selectedFromCard!.balance - transferAmount;
      await CardService.updateCardBalance(_selectedFromCard!.id, newSenderBalance);
      debugPrint('✅ Sender card balance updated: ₺$newSenderBalance');

      // If recipient is a registered user, create income transaction for them
      if (_selectedRecipient != null) {
        final recipientTransaction = FirebaseTransaction(
          id: '', // Will be set by Firestore
          userId: _selectedRecipient!.userId,
          title: 'Para Transferi Alındı',
          category: 'Transfer',
          amount: transferAmount,
          date: DateTime.now(),
          isIncome: true, // Income for recipient
          iconName: 'transfer',
          colorHex: '#10B981', // Green for income
          description: 'Para transferi alındı - ${FirebaseAuth.instance.currentUser?.displayName ?? 'Gönderen'}',
          categoryId: null,
          cardId: null, // No specific card for incoming transfer
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final recipientTransactionId = await TransactionService.createTransaction(recipientTransaction);
        debugPrint('✅ Recipient transaction created: $recipientTransactionId');
      }

      setState(() {
        _isLoading = false;
      });

      // Close confirmation modal and go back
      Navigator.pop(context); // Close confirmation modal
      Navigator.pop(context); // Go back to previous screen
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('₺${transferAmount.toStringAsFixed(2)} başarıyla transfer edildi!'),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          duration: const Duration(seconds: 4),
        ),
      );

      debugPrint('🎉 Transfer completed successfully!');

    } catch (e) {
      debugPrint('💥 Error processing transfer: $e');
      setState(() {
        _isLoading = false;
      });
      _showErrorMessage('Transfer işlemi başarısız: $e');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}