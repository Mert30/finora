import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LiveMarketsPage extends StatefulWidget {
  const LiveMarketsPage({super.key});

  @override
  State<LiveMarketsPage> createState() => _LiveMarketsPageState();
}

class _LiveMarketsPageState extends State<LiveMarketsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedCategory = 'Döviz';
  final List<String> _categories = ['Döviz', 'Altın & Kıymetli', 'Kripto', 'Borsa'];

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
  }

  @override
  void dispose() {
    _animationController.dispose();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildCategoryTabs(),
                    const SizedBox(height: 24),
                    _buildMarketOverview(),
                    const SizedBox(height: 24),
                    _buildMarketList(),
                    const SizedBox(height: 32),
                  ],
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
                Icons.refresh_outlined,
                color: Color(0xFF64748B),
                size: 24,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('📈 Piyasa verileri yenileniyor...'),
                    backgroundColor: const Color(0xFF059669),
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
                          colors: [Color(0xFF059669), Color(0xFF10B981)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.trending_up_outlined,
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
                            'Canlı Piyasalar',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            'Gerçek zamanlı piyasa verileri',
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
                            'CANLI',
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

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _categories.map((category) {
            final isSelected = category == _selectedCategory;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF059669) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF059669) : const Color(0xFFE5E7EB),
                  ),
                  boxShadow: [
                    if (isSelected) BoxShadow(
                      color: const Color(0xFF059669).withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  category,
                  style: GoogleFonts.inter(
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMarketOverview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Piyasa Özeti',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  title: 'Toplam Hacim',
                  value: '2.4T ₺',
                  change: '+5.2%',
                  isPositive: true,
                  icon: Icons.bar_chart_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildOverviewCard(
                  title: 'Aktif İşlem',
                  value: '8.9K',
                  change: '+12.8%',
                  isPositive: true,
                  icon: Icons.trending_up_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard({
    required String title,
    required String value,
    required String change,
    required bool isPositive,
    required IconData icon,
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  size: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  change,
                  style: GoogleFonts.inter(
                    color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              color: const Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketList() {
    final marketData = _getMarketData();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$_selectedCategory Piyasası',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${marketData.length} Öğe',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF059669),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: marketData.length,
            itemBuilder: (context, index) {
              final item = marketData[index];
              return _buildMarketCard(
                symbol: item['symbol'],
                name: item['name'],
                price: item['price'],
                change: item['change'],
                changePercent: item['changePercent'],
                isPositive: item['isPositive'],
                icon: item['icon'],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMarketCard({
    required String symbol,
    required String name,
    required String price,
    required String change,
    required String changePercent,
    required bool isPositive,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1F2937),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  name,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: GoogleFonts.inter(
                  color: const Color(0xFF1F2937),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    size: 12,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '$change ($changePercent)',
                    style: GoogleFonts.inter(
                      color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMarketData() {
    switch (_selectedCategory) {
      case 'Döviz':
        return [
          {
            'symbol': 'USD/TRY',
            'name': 'Amerikan Doları',
            'price': '33.85 ₺',
            'change': '+0.12',
            'changePercent': '+0.35%',
            'isPositive': true,
            'icon': Icons.attach_money_outlined,
          },
          {
            'symbol': 'EUR/TRY',
            'name': 'Euro',
            'price': '36.92 ₺',
            'change': '-0.08',
            'changePercent': '-0.22%',
            'isPositive': false,
            'icon': Icons.euro_outlined,
          },
          {
            'symbol': 'GBP/TRY',
            'name': 'İngiliz Sterlini',
            'price': '42.15 ₺',
            'change': '+0.25',
            'changePercent': '+0.59%',
            'isPositive': true,
            'icon': Icons.currency_pound_outlined,
          },
          {
            'symbol': 'CHF/TRY',
            'name': 'İsviçre Frangı',
            'price': '37.68 ₺',
            'change': '+0.15',
            'changePercent': '+0.40%',
            'isPositive': true,
            'icon': Icons.currency_exchange_outlined,
          },
        ];
      case 'Altın & Kıymetli':
        return [
          {
            'symbol': 'XAU/USD',
            'name': 'Altın (Ons)',
            'price': '2,048.50 \$',
            'change': '+12.50',
            'changePercent': '+0.61%',
            'isPositive': true,
            'icon': Icons.diamond_outlined,
          },
          {
            'symbol': 'XAG/USD',
            'name': 'Gümüş (Ons)',
            'price': '24.85 \$',
            'change': '-0.35',
            'changePercent': '-1.39%',
            'isPositive': false,
            'icon': Icons.circle_outlined,
          },
          {
            'symbol': 'XPT/USD',
            'name': 'Platin (Ons)',
            'price': '912.40 \$',
            'change': '+8.20',
            'changePercent': '+0.91%',
            'isPositive': true,
            'icon': Icons.star_outline,
          },
          {
            'symbol': 'XPD/USD',
            'name': 'Paladyum (Ons)',
            'price': '1,245.80 \$',
            'change': '-15.60',
            'changePercent': '-1.24%',
            'isPositive': false,
            'icon': Icons.hexagon_outlined,
          },
        ];
      case 'Kripto':
        return [
          {
            'symbol': 'BTC/USD',
            'name': 'Bitcoin',
            'price': '43,250.00 \$',
            'change': '+1,250.00',
            'changePercent': '+2.98%',
            'isPositive': true,
            'icon': Icons.currency_bitcoin_outlined,
          },
          {
            'symbol': 'ETH/USD',
            'name': 'Ethereum',
            'price': '2,685.50 \$',
            'change': '-45.20',
            'changePercent': '-1.66%',
            'isPositive': false,
            'icon': Icons.currency_exchange_outlined,
          },
          {
            'symbol': 'BNB/USD',
            'name': 'Binance Coin',
            'price': '315.80 \$',
            'change': '+8.40',
            'changePercent': '+2.73%',
            'isPositive': true,
            'icon': Icons.token_outlined,
          },
          {
            'symbol': 'ADA/USD',
            'name': 'Cardano',
            'price': '0.485 \$',
            'change': '-0.012',
            'changePercent': '-2.41%',
            'isPositive': false,
            'icon': Icons.account_balance_outlined,
          },
        ];
      case 'Borsa':
        return [
          {
            'symbol': 'BIST100',
            'name': 'Borsa İstanbul 100',
            'price': '8,945.67',
            'change': '+125.43',
            'changePercent': '+1.42%',
            'isPositive': true,
            'icon': Icons.trending_up_outlined,
          },
          {
            'symbol': 'THYAO',
            'name': 'Türk Hava Yolları',
            'price': '285.50 ₺',
            'change': '-5.20',
            'changePercent': '-1.79%',
            'isPositive': false,
            'icon': Icons.flight_outlined,
          },
          {
            'symbol': 'AKBNK',
            'name': 'Akbank',
            'price': '45.80 ₺',
            'change': '+1.15',
            'changePercent': '+2.57%',
            'isPositive': true,
            'icon': Icons.account_balance_outlined,
          },
          {
            'symbol': 'PETKM',
            'name': 'Petkim',
            'price': '12.65 ₺',
            'change': '+0.35',
            'changePercent': '+2.85%',
            'isPositive': true,
            'icon': Icons.local_gas_station_outlined,
          },
        ];
      default:
        return [];
    }
  }
}