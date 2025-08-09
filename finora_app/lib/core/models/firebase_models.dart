// 🔥 FINORA - FIREBASE MODELS
// Mevcut sayfalardaki verilere göre optimize edilmiş Firebase modelleri

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════
// 👤 USER PROFILE MODEL (ProfilePage'den)
// ═══════════════════════════════════════════════════════════════════

class FirebaseUserProfile {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String memberSince;
  final String profileImageUrl;
  final bool isVerified;
  final String accountType;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // ProfileStats integration
  final ProfileStats stats;
  
  // Additional fields for Firebase  
  final String? fullName; // firstName/lastName yerine fullName kullanıyoruz
  final String? dateOfBirth;
  final String? gender;
  final String? nationalId;
  final UserAddress? address;

  FirebaseUserProfile({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.memberSince,
    required this.profileImageUrl,
    required this.isVerified,
    required this.accountType,
    required this.createdAt,
    required this.updatedAt,
    required this.stats,
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.nationalId,
    this.address,
  });

  // Getter for personalInfo to maintain compatibility
  Map<String, dynamic> get personalInfo => {
    'fullName': fullName ?? name,
    'name': name,
    'email': email,
    'phone': phone,
    'memberSince': memberSince,
    'profileImageUrl': profileImageUrl,
    'isVerified': isVerified,
    'accountType': accountType,
    'dateOfBirth': dateOfBirth,
    'gender': gender,
    'nationalId': nationalId,
    'address': address?.toMap(),
  };

  // Firestore'a kaydetmek için
  Map<String, dynamic> toFirestore() {
    return {
      'personalInfo': {
        'name': name,
        'fullName': fullName ?? name,
        'email': email,
        'phone': phone,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'profileImageUrl': profileImageUrl,
        'memberSince': memberSince,
        'accountType': accountType,
        'isVerified': isVerified,
        'nationalId': nationalId,
        'address': address?.toMap(),
      },
      'stats': {
        'totalTransactions': stats.totalTransactions,
        'totalIncome': stats.totalIncome,
        'totalExpense': stats.totalExpense,
        'activeGoals': stats.activeGoals,
        'categoriesUsed': stats.categoriesUsed,
      },
      'metadata': {
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
        'userId': userId,
      }
    };
  }

  // Firestore'dan okumak için
  factory FirebaseUserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final personalInfo = data['personalInfo'] as Map<String, dynamic>;
    final statsData = data['stats'] as Map<String, dynamic>;
    final metadata = data['metadata'] as Map<String, dynamic>;

    return FirebaseUserProfile(
      userId: doc.id,
      name: personalInfo['name'] ?? '',
      email: personalInfo['email'] ?? '',
      phone: personalInfo['phone'] ?? '',
      memberSince: personalInfo['memberSince'] ?? '',
      profileImageUrl: personalInfo['profileImageUrl'] ?? '',
      isVerified: personalInfo['isVerified'] ?? false,
      accountType: personalInfo['accountType'] ?? 'free',
      fullName: personalInfo['fullName'],
      dateOfBirth: personalInfo['dateOfBirth'],
      gender: personalInfo['gender'],
      nationalId: personalInfo['nationalId'],
      address: personalInfo['address'] != null 
          ? UserAddress.fromMap(personalInfo['address']) 
          : null,
      stats: ProfileStats.fromMap(statsData),
      createdAt: (metadata['createdAt'] as Timestamp).toDate(),
      updatedAt: (metadata['updatedAt'] as Timestamp).toDate(),
    );
  }
}

class ProfileStats {
  final int totalTransactions;
  final double totalIncome;
  final double totalExpense;
  final int activeGoals;
  final int categoriesUsed;

  ProfileStats({
    required this.totalTransactions,
    required this.totalIncome,
    required this.totalExpense,
    required this.activeGoals,
    required this.categoriesUsed,
  });

  Map<String, dynamic> toMap() {
    return {
      'totalTransactions': totalTransactions,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'activeGoals': activeGoals,
      'categoriesUsed': categoriesUsed,
    };
  }

  factory ProfileStats.fromMap(Map<String, dynamic> map) {
    return ProfileStats(
      totalTransactions: map['totalTransactions'] ?? 0,
      totalIncome: (map['totalIncome'] ?? 0.0).toDouble(),
      totalExpense: (map['totalExpense'] ?? 0.0).toDouble(),
      activeGoals: map['activeGoals'] ?? 0,
      categoriesUsed: map['categoriesUsed'] ?? 0,
    );
  }
}

class UserAddress {
  final String street;
  final String district;
  final String city;
  final String postalCode;
  final String country;

  UserAddress({
    required this.street,
    required this.district,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'district': district,
      'city': city,
      'postalCode': postalCode,
      'country': country,
    };
  }

  factory UserAddress.fromMap(Map<String, dynamic> map) {
    return UserAddress(
      street: map['street'] ?? '',
      district: map['district'] ?? '',
      city: map['city'] ?? '',
      postalCode: map['postalCode'] ?? '',
      country: map['country'] ?? '',
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// 📊 TRANSACTION MODEL (HistoryPage'den)
// ═══════════════════════════════════════════════════════════════════

class FirebaseTransaction {
  final String id;
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final bool isIncome;
  final String iconName; // IconData'dan String'e çevrildi
  final String colorHex; // Color'dan hex string'e çevrildi
  final String? description;
  final String userId;
  final String? categoryId;
  final String? cardId;
  final TransactionLocation? location;
  final List<String> tags;
  final bool isRecurring;
  final String? recurringPattern;
  final List<String> attachments;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  FirebaseTransaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.isIncome,
    required this.iconName,
    required this.colorHex,
    this.description,
    required this.userId,
    this.categoryId,
    this.cardId,
    this.location,
    this.tags = const [],
    this.isRecurring = false,
    this.recurringPattern,
    this.attachments = const [],
    this.status = 'completed',
    required this.createdAt,
    required this.updatedAt,
  });

  // Firestore'a kaydetmek için
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'category': category,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'isIncome': isIncome,
      'type': isIncome ? 'income' : 'expense',
      'iconName': iconName,
      'colorHex': colorHex,
      'description': description,
      'categoryId': categoryId,
      'cardId': cardId,
      'location': location?.toMap(),
      'tags': tags,
      'isRecurring': isRecurring,
      'recurringPattern': recurringPattern,
      'attachments': attachments,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Firestore'dan okumak için
  factory FirebaseTransaction.fromFirestore(DocumentSnapshot doc, String userId) {
    final data = doc.data() as Map<String, dynamic>;

    return FirebaseTransaction(
      id: doc.id,
      userId: userId,
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      isIncome: data['isIncome'] ?? false,
      iconName: data['iconName'] ?? 'category',
      colorHex: data['colorHex'] ?? '#6B7280',
      description: data['description'],
      categoryId: data['categoryId'],
      cardId: data['cardId'],
      location: data['location'] != null 
          ? TransactionLocation.fromMap(data['location']) 
          : null,
      tags: List<String>.from(data['tags'] ?? []),
      isRecurring: data['isRecurring'] ?? false,
      recurringPattern: data['recurringPattern'],
      attachments: List<String>.from(data['attachments'] ?? []),
      status: data['status'] ?? 'completed',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // UI için IconData'ya çevirmek için
  IconData get icon {
    switch (iconName) {
      case 'shopping_cart': return Icons.shopping_cart;
      case 'restaurant': return Icons.restaurant;
      case 'local_gas_station': return Icons.local_gas_station;
      case 'work': return Icons.work;
      case 'home': return Icons.home;
      case 'school': return Icons.school;
      case 'local_hospital': return Icons.local_hospital;
      case 'sports_esports': return Icons.sports_esports;
      default: return Icons.category;
    }
  }

  // UI için Color'a çevirmek için
  Color get color {
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }
}

class TransactionLocation {
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  TransactionLocation({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory TransactionLocation.fromMap(Map<String, dynamic> map) {
    return TransactionLocation(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// 🎯 BUDGET GOAL MODEL (BudgetGoalsPage'den)
// ═══════════════════════════════════════════════════════════════════

class FirebaseBudgetGoal {
  final String id;
  final String title;
  final String category;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final String iconName;
  final String colorHex;
  final String description;
  final String userId;
  final String priority;
  final bool isActive;
  final bool isCompleted;
  final DateTime? completedAt;
  final double monthlyContribution;
  final bool autoDeduction;
  final bool reminderEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  FirebaseBudgetGoal({
    required this.id,
    required this.title,
    required this.category,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.iconName,
    required this.colorHex,
    required this.description,
    required this.userId,
    this.priority = 'medium',
    this.isActive = true,
    this.isCompleted = false,
    this.completedAt,
    this.monthlyContribution = 0.0,
    this.autoDeduction = false,
    this.reminderEnabled = true,
    required this.createdAt,
    required this.updatedAt,
  });

  // Firestore'a kaydetmek için
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'category': category,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'deadline': Timestamp.fromDate(deadline),
      'iconName': iconName,
      'colorHex': colorHex,
      'description': description,
      'priority': priority,
      'isActive': isActive,
      'isCompleted': isCompleted,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'monthlyContribution': monthlyContribution,
      'autoDeduction': autoDeduction,
      'reminderEnabled': reminderEnabled,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Firestore'dan okumak için
  factory FirebaseBudgetGoal.fromFirestore(DocumentSnapshot doc, String userId) {
    final data = doc.data() as Map<String, dynamic>;

    return FirebaseBudgetGoal(
      id: doc.id,
      userId: userId,
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      targetAmount: (data['targetAmount'] ?? 0.0).toDouble(),
      currentAmount: (data['currentAmount'] ?? 0.0).toDouble(),
      deadline: (data['deadline'] as Timestamp).toDate(),
      iconName: data['iconName'] ?? 'savings',
      colorHex: data['colorHex'] ?? '#10B981',
      description: data['description'] ?? '',
      priority: data['priority'] ?? 'medium',
      isActive: data['isActive'] ?? true,
      isCompleted: data['isCompleted'] ?? false,
      completedAt: data['completedAt'] != null 
          ? (data['completedAt'] as Timestamp).toDate() 
          : null,
      monthlyContribution: (data['monthlyContribution'] ?? 0.0).toDouble(),
      autoDeduction: data['autoDeduction'] ?? false,
      reminderEnabled: data['reminderEnabled'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Calculated properties
  double get progress => currentAmount / targetAmount;
  bool get isCompletedGoal => currentAmount >= targetAmount;
  int get daysLeft => deadline.difference(DateTime.now()).inDays;

  // UI için IconData'ya çevirmek için
  IconData get icon {
    switch (iconName) {
      case 'savings': return Icons.savings;
      case 'home': return Icons.home;
      case 'flight': return Icons.flight;
      case 'school': return Icons.school;
      case 'car_rental': return Icons.car_rental;
      case 'emergency': return Icons.emergency;
      default: return Icons.savings;
    }
  }

  // UI için Color'a çevirmek için
  Color get color {
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }
}

// ═══════════════════════════════════════════════════════════════════
// 📂 CATEGORY MODEL (CategoryManagementPage'den)
// ═══════════════════════════════════════════════════════════════════

class FirebaseCategoryModel {
  final String id;
  final String name;
  final String iconName;
  final String colorHex;
  final int transactionCount;
  final double totalAmount;
  final String userId;
  final String type; // 'income' or 'expense'
  final double monthlyBudget;
  final double currentSpent;
  final String currency;
  final bool isDefault;
  final bool isActive;
  final String? parentCategoryId;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  FirebaseCategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorHex,
    required this.transactionCount,
    required this.totalAmount,
    required this.userId,
    required this.type,
    this.monthlyBudget = 0.0,
    this.currentSpent = 0.0,
    this.currency = 'TRY',
    this.isDefault = false,
    this.isActive = true,
    this.parentCategoryId,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  // Firestore'a kaydetmek için
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'iconName': iconName,
      'colorHex': colorHex,
      'transactionCount': transactionCount,
      'totalAmount': totalAmount,
      'type': type,
      'monthlyBudget': monthlyBudget,
      'currentSpent': currentSpent,
      'currency': currency,
      'isDefault': isDefault,
      'isActive': isActive,
      'parentCategoryId': parentCategoryId,
      'sortOrder': sortOrder,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Firestore'dan okumak için
  factory FirebaseCategoryModel.fromFirestore(DocumentSnapshot doc, String userId) {
    final data = doc.data() as Map<String, dynamic>;

    return FirebaseCategoryModel(
      id: doc.id,
      userId: userId,
      name: data['name'] ?? '',
      iconName: data['iconName'] ?? 'category',
      colorHex: data['colorHex'] ?? '#6B7280',
      transactionCount: data['transactionCount'] ?? 0,
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      type: data['type'] ?? 'expense',
      monthlyBudget: (data['monthlyBudget'] ?? 0.0).toDouble(),
      currentSpent: (data['currentSpent'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'TRY',
      isDefault: data['isDefault'] ?? false,
      isActive: data['isActive'] ?? true,
      parentCategoryId: data['parentCategoryId'],
      sortOrder: data['sortOrder'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // UI için IconData'ya çevirmek için
  IconData get icon {
    switch (iconName) {
      case 'work_outlined': return Icons.work_outlined;
      case 'laptop_outlined': return Icons.laptop_outlined;
      case 'trending_up_outlined': return Icons.trending_up_outlined;
      case 'card_giftcard_outlined': return Icons.card_giftcard_outlined;
      case 'shopping_cart_outlined': return Icons.shopping_cart_outlined;
      case 'restaurant_outlined': return Icons.restaurant_outlined;
      case 'local_gas_station_outlined': return Icons.local_gas_station_outlined;
      case 'home_outlined': return Icons.home_outlined;
      case 'school_outlined': return Icons.school_outlined;
      case 'local_hospital_outlined': return Icons.local_hospital_outlined;
      case 'sports_esports_outlined': return Icons.sports_esports_outlined;
      case 'checkroom_outlined': return Icons.checkroom_outlined;
      default: return Icons.category_outlined;
    }
  }

  // UI için Color'a çevirmek için
  Color get color {
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }
}

// ═══════════════════════════════════════════════════════════════════
// 💳 CARD MODEL (MoneyTransferPage'den)
// ═══════════════════════════════════════════════════════════════════

class FirebaseCard {
  final String id;
  final String bankName;
  final String cardNumber; // Masked (örn: "**** **** **** 1234")
  final String cardHolderName;
  final String expiryDate;
  final double balance;
  final String currency;
  final String colorHex;
  final String cardType; // 'debit', 'credit'
  final bool isDefault;
  final bool isActive;
  final String userId;
  final DateTime lastUsed;
  final double monthlyLimit;
  final double dailyLimit;
  final DateTime createdAt;
  final DateTime updatedAt;

  FirebaseCard({
    required this.id,
    required this.bankName,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.balance,
    this.currency = 'TRY',
    required this.colorHex,
    this.cardType = 'debit',
    this.isDefault = false,
    this.isActive = true,
    required this.userId,
    required this.lastUsed,
    this.monthlyLimit = 50000.0,
    this.dailyLimit = 5000.0,
    required this.createdAt,
    required this.updatedAt,
  });

  // Firestore'a kaydetmek için
  Map<String, dynamic> toFirestore() {
    return {
      'bankName': bankName,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'balance': balance,
      'currency': currency,
      'colorHex': colorHex,
      'cardType': cardType,
      'isDefault': isDefault,
      'isActive': isActive,
      'lastUsed': Timestamp.fromDate(lastUsed),
      'monthlyLimit': monthlyLimit,
      'dailyLimit': dailyLimit,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Firestore'dan okumak için
  factory FirebaseCard.fromFirestore(DocumentSnapshot doc, String userId) {
    final data = doc.data() as Map<String, dynamic>;

    return FirebaseCard(
      id: doc.id,
      userId: userId,
      bankName: data['bankName'] ?? '',
      cardNumber: data['cardNumber'] ?? '',
      cardHolderName: data['cardHolderName'] ?? '',
      expiryDate: data['expiryDate'] ?? '',
      balance: (data['balance'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'TRY',
      colorHex: data['colorHex'] ?? '#6B7280',
      cardType: data['cardType'] ?? 'debit',
      isDefault: data['isDefault'] ?? false,
      isActive: data['isActive'] ?? true,
      lastUsed: (data['lastUsed'] as Timestamp).toDate(),
      monthlyLimit: (data['monthlyLimit'] ?? 50000.0).toDouble(),
      dailyLimit: (data['dailyLimit'] ?? 5000.0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // UI için Color'a çevirmek için
  Color get color {
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  // Formatted balance string
  String get formattedBalance {
    return '${balance.toStringAsFixed(2).replaceAll('.', ',')} ₺';
  }
}

// ═══════════════════════════════════════════════════════════════════
// ⚙️ USER SETTINGS MODEL (SettingsPage'den)
// ═══════════════════════════════════════════════════════════════════

class FirebaseUserSettings {
  final String userId;
  final String language;
  final String currency;
  final String theme;
  final NotificationSettings notifications;
  final SecuritySettings security;
  final PrivacySettings privacy;
  final DateTime updatedAt;

  FirebaseUserSettings({
    required this.userId,
    this.language = 'tr',
    this.currency = 'TRY',
    this.theme = 'light',
    required this.notifications,
    required this.security,
    required this.privacy,
    required this.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'language': language,
      'currency': currency,
      'theme': theme,
      'notifications': notifications.toMap(),
      'security': security.toMap(),
      'privacy': privacy.toMap(),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory FirebaseUserSettings.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return FirebaseUserSettings(
      userId: doc.id,
      language: data['language'] ?? 'tr',
      currency: data['currency'] ?? 'TRY',
      theme: data['theme'] ?? 'light',
      notifications: NotificationSettings.fromMap(data['notifications'] ?? {}),
      security: SecuritySettings.fromMap(data['security'] ?? {}),
      privacy: PrivacySettings.fromMap(data['privacy'] ?? {}),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}

class NotificationSettings {
  final bool instanceBudgetAlerts;
  final bool instanceSavingTips;
  final bool instanceGoalUpdates;
  final bool instanceBillReminders;
  final bool instanceDailySummary;
  final bool pushEnabled;
  final bool emailEnabled;
  final bool smsEnabled;

  // Static properties for global access (kept for backward compatibility)
  static bool _globalBudgetAlerts = true;
  static bool _globalSavingTips = true;
  static bool _globalGoalUpdates = false;
  static bool _globalBillReminders = true;
  static bool _globalDailySummary = false;

  static bool get budgetAlerts => _globalBudgetAlerts;
  static set budgetAlerts(bool value) => _globalBudgetAlerts = value;
  
  static bool get savingTips => _globalSavingTips;
  static set savingTips(bool value) => _globalSavingTips = value;
  
  static bool get goalUpdates => _globalGoalUpdates;
  static set goalUpdates(bool value) => _globalGoalUpdates = value;
  
  static bool get billReminders => _globalBillReminders;
  static set billReminders(bool value) => _globalBillReminders = value;
  
  static bool get dailySummary => _globalDailySummary;
  static set dailySummary(bool value) => _globalDailySummary = value;

  static bool get hasActiveNotifications {
    return _globalBudgetAlerts || _globalSavingTips || _globalGoalUpdates || _globalBillReminders || _globalDailySummary;
  }

  static int get activeNotificationCount {
    int count = 0;
    if (_globalBudgetAlerts) count++;
    if (_globalSavingTips) count++;
    if (_globalGoalUpdates) count++;
    if (_globalBillReminders) count++;
    if (_globalDailySummary) count++;
    return count;
  }

  const NotificationSettings({
    this.instanceBudgetAlerts = true,
    this.instanceSavingTips = true,
    this.instanceGoalUpdates = false,
    this.instanceBillReminders = true,
    this.instanceDailySummary = false,
    this.pushEnabled = true,
    this.emailEnabled = false,
    this.smsEnabled = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'budgetAlerts': instanceBudgetAlerts,
      'savingTips': instanceSavingTips,
      'goalUpdates': instanceGoalUpdates,
      'billReminders': instanceBillReminders,
      'dailySummary': instanceDailySummary,
      'pushEnabled': pushEnabled,
      'emailEnabled': emailEnabled,
      'smsEnabled': smsEnabled,
    };
  }

  factory NotificationSettings.fromMap(Map<String, dynamic> map) {
    return NotificationSettings(
      instanceBudgetAlerts: map['budgetAlerts'] ?? true,
      instanceSavingTips: map['savingTips'] ?? true,
      instanceGoalUpdates: map['goalUpdates'] ?? false,
      instanceBillReminders: map['billReminders'] ?? true,
      instanceDailySummary: map['dailySummary'] ?? false,
      pushEnabled: map['pushEnabled'] ?? true,
      emailEnabled: map['emailEnabled'] ?? false,
      smsEnabled: map['smsEnabled'] ?? true,
    );
  }
}

class SecuritySettings {
  final bool biometricEnabled;
  final bool twoFactorAuth;
  final int sessionTimeout;
  final bool autoLogout;

  SecuritySettings({
    this.biometricEnabled = true,
    this.twoFactorAuth = false,
    this.sessionTimeout = 30,
    this.autoLogout = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'biometricEnabled': biometricEnabled,
      'twoFactorAuth': twoFactorAuth,
      'sessionTimeout': sessionTimeout,
      'autoLogout': autoLogout,
    };
  }

  factory SecuritySettings.fromMap(Map<String, dynamic> map) {
    return SecuritySettings(
      biometricEnabled: map['biometricEnabled'] ?? true,
      twoFactorAuth: map['twoFactorAuth'] ?? false,
      sessionTimeout: map['sessionTimeout'] ?? 30,
      autoLogout: map['autoLogout'] ?? true,
    );
  }
}

class PrivacySettings {
  final bool shareAnalytics;
  final bool personalizedAds;
  final bool dataCollection;

  PrivacySettings({
    this.shareAnalytics = true,
    this.personalizedAds = false,
    this.dataCollection = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'shareAnalytics': shareAnalytics,
      'personalizedAds': personalizedAds,
      'dataCollection': dataCollection,
    };
  }

  factory PrivacySettings.fromMap(Map<String, dynamic> map) {
    return PrivacySettings(
      shareAnalytics: map['shareAnalytics'] ?? true,
      personalizedAds: map['personalizedAds'] ?? false,
      dataCollection: map['dataCollection'] ?? true,
    );
  }
}