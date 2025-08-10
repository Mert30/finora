import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/core/services/firebase_service.dart';
import '/core/models/firebase_models.dart';
import 'add_goal_page.dart';

class BudgetGoalsPage extends StatefulWidget {
  const BudgetGoalsPage({super.key});

  @override
  State<BudgetGoalsPage> createState() => _BudgetGoalsPageState();
}

class _BudgetGoalsPageState extends State<BudgetGoalsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Firebase data state
  bool _isLoading = true;
  List<FirebaseBudgetGoal> _goals = [];
  String? _userId;

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
    
    // Load Firebase data
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    try {
      _userId = FirebaseAuth.instance.currentUser?.uid;
      if (_userId == null) {
        setState(() => _isLoading = false);
        return;
      }

      debugPrint('🎯 Loading goals for user: $_userId');

      final goals = await GoalService.getGoals(_userId!);
      debugPrint('📋 Retrieved ${goals.length} goals');

      setState(() {
        _goals = goals;
        _isLoading = false;
      });

      debugPrint('✅ Goals loaded successfully');
    } catch (e) {
      debugPrint('💥 Error loading goals: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
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
              
              // Summary Section
              SliverToBoxAdapter(
                child: _buildSummarySection(),
              ),
              
              // Goals List
              _buildGoalsList(),
              
              // Add Goal Button
              SliverToBoxAdapter(
                child: _buildAddGoalButton(),
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
              colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
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
                  'Hedeflerim 🎯',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Finansal hedeflerinizi planlayın ve takip edin',
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

  Widget _buildSummarySection() {
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          height: 200,
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
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
            ),
          ),
        ),
      );
    }

    if (_goals.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(32),
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
            children: [
              Icon(
                Icons.flag_outlined,
                size: 64,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Henüz hedef belirlemediniz',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'İlk bütçe hedefinizi ekleyerek başlayın',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF94A3B8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final totalTargetAmount = _goals.fold(0.0, (sum, goal) => sum + goal.targetAmount);
    final totalCurrentAmount = _goals.fold(0.0, (sum, goal) => sum + goal.currentAmount);
    final totalProgress = totalTargetAmount > 0 ? totalCurrentAmount / totalTargetAmount : 0.0;
    final completedGoals = _goals.where((goal) => goal.isCompleted).length;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Main Progress Card
          Container(
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
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.flag_outlined,
                        color: Color(0xFF3B82F6),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Toplam İlerleme',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF6B7280),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₺${totalCurrentAmount.toStringAsFixed(0)} / ₺${totalTargetAmount.toStringAsFixed(0)}',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1F2937),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${(totalProgress * 100).toStringAsFixed(1)}%',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF3B82F6),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: totalProgress,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 8,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Tamamlanan',
                  value: '$completedGoals/${_goals.length}',
                  icon: Icons.check_circle_outline,
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: 'Ortalama İlerleme',
                  value: '${(_goals.fold(0.0, (sum, goal) => sum + goal.progress) / _goals.length * 100).toStringAsFixed(0)}%',
                  icon: Icons.insights_outlined,
                  color: const Color(0xFF8B5CF6),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: GoogleFonts.inter(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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

  Widget _buildGoalsList() {
    if (_isLoading) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: List.generate(3, (index) => 
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (_goals.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            children: [
              Icon(
                Icons.flag_outlined,
                size: 80,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                'Henüz hedef eklemediniz',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'İlk hedefinizi ekleyerek tasarruf yolculuğunuza başlayın',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF94A3B8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildGoalCard(_goals[index]),
            );
          },
          childCount: _goals.length,
        ),
      ),
    );
  }

  Widget _buildGoalCard(FirebaseBudgetGoal goal) {
    final icon = _getIconFromString(goal.iconName);
    final color = _getColorFromString(goal.colorHex);
    final progress = goal.targetAmount > 0 ? goal.currentAmount / goal.targetAmount : 0.0;
    final daysLeft = goal.deadline.difference(DateTime.now()).inDays;
    
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF1F2937),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      goal.category,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF6B7280),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (goal.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Tamamlandı',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF10B981),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            goal.description,
            style: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'İlerleme',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF6B7280),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₺${goal.currentAmount.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            color: color,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '₺${goal.targetAmount.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF6B7280),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    daysLeft > 0 ? '$daysLeft gün' : 'Süre doldu',
                    style: GoogleFonts.inter(
                      color: daysLeft > 0 ? const Color(0xFF6B7280) : const Color(0xFFEF4444),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '%${(progress * 100).toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
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

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'savings':
        return Icons.savings_outlined;
      case 'laptop':
        return Icons.laptop_mac_outlined;
      case 'flight':
        return Icons.flight_outlined;
      case 'trending_up':
        return Icons.trending_up_outlined;
      case 'home':
        return Icons.home_outlined;
      case 'car':
        return Icons.directions_car_outlined;
      case 'security':
        return Icons.security_outlined;
      case 'school':
        return Icons.school_outlined;
      case 'medical':
        return Icons.medical_services_outlined;
      case 'shopping':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.flag_outlined;
    }
  }

  Color _getColorFromString(String colorHex) {
    try {
      if (colorHex.startsWith('#')) {
        return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
      } else if (colorHex.startsWith('0x')) {
        return Color(int.parse(colorHex));
      } else {
        return Color(int.parse('0xFF$colorHex'));
      }
    } catch (e) {
      return const Color(0xFF3B82F6);
    }
  }

  Widget _buildAddGoalButton() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
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
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddGoalPage(
                    userId: _userId,
                    onGoalAdded: () {
                      _loadGoals();
                    },
                  ),
                ),
              );
              
              // Reload goals if a goal was added
              if (result == true) {
                _loadGoals();
              }
            },
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Yeni Hedef Ekle',
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
      ),
    );
  }
}