// 🔥 FINORA - FIREBASE SERVICE
// Gerçek kullanıcı verisi için eksiksiz Firebase operations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/core/models/firebase_models.dart';

// ═══════════════════════════════════════════════════════════════════
// 🔥 BASE FIREBASE SERVICE
// ═══════════════════════════════════════════════════════════════════

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Current user ID
  static String? get currentUserId => _auth.currentUser?.uid;
  
  // Check if user is authenticated
  static bool get isAuthenticated => _auth.currentUser != null;

  // Error handling wrapper
  static Future<T?> _handleErrors<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on FirebaseException catch (e) {
      debugPrint('🔥 Firebase Error: ${e.code} - ${e.message}');
      throw FirebaseServiceException(e.code, e.message ?? 'Unknown error');
    } catch (e) {
      debugPrint('🔥 General Error: $e');
      throw FirebaseServiceException('unknown', e.toString());
    }
  }
}

// Custom exception class
class FirebaseServiceException implements Exception {
  final String code;
  final String message;
  
  FirebaseServiceException(this.code, this.message);
  
  @override
  String toString() => 'FirebaseServiceException: $code - $message';
}

// ═══════════════════════════════════════════════════════════════════
// 👤 USER SERVICE
// ═══════════════════════════════════════════════════════════════════

class UserService {
  static final CollectionReference _usersCollection = 
      FirebaseService._firestore.collection('users');

  // ➤ CREATE USER PROFILE
  static Future<void> createUserProfile(FirebaseUserProfile profile) async {
    await FirebaseService._handleErrors(() async {
      await _usersCollection.doc(profile.userId).set(profile.toFirestore());
      debugPrint('✅ User profile created: ${profile.userId}');
    });
  }

  // ➤ GET USER PROFILE
  static Future<FirebaseUserProfile?> getUserProfile(String userId) async {
    return await FirebaseService._handleErrors(() async {
      final doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        return FirebaseUserProfile.fromFirestore(doc);
      }
      return null;
    });
  }

  // ➤ UPDATE USER PROFILE
  static Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    await FirebaseService._handleErrors(() async {
      await _usersCollection.doc(userId).update({
        ...updates,
        'metadata.updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ User profile updated: $userId');
    });
  }

  // ➤ UPDATE FULL USER PROFILE (with object)
  static Future<void> updateFullUserProfile(FirebaseUserProfile profile) async {
    await FirebaseService._handleErrors(() async {
      await _usersCollection.doc(profile.userId).update(profile.toFirestore());
      debugPrint('✅ User profile fully updated: ${profile.userId}');
    });
  }

  // ➤ UPDATE USER STATS
  static Future<void> updateUserStats(String userId, ProfileStats stats) async {
    await FirebaseService._handleErrors(() async {
      await _usersCollection.doc(userId).update({
        'stats': stats.toMap(),
        'metadata.updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ User stats updated: $userId');
    });
  }

  // ➤ GET USER PROFILE STREAM (Real-time)
  static Stream<FirebaseUserProfile?> getUserProfileStream(String userId) {
    return _usersCollection.doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return FirebaseUserProfile.fromFirestore(doc);
      }
      return null;
    });
  }

  // ➤ DELETE USER PROFILE
  static Future<void> deleteUserProfile(String userId) async {
    await FirebaseService._handleErrors(() async {
      await _usersCollection.doc(userId).delete();
      debugPrint('✅ User profile deleted: $userId');
    });
  }

  // ➤ SEARCH USERS (for money transfer)
  static Future<List<FirebaseUserProfile>> searchUsers(String query) async {
    final result = await FirebaseService._handleErrors(() async {
      if (query.trim().isEmpty) return <FirebaseUserProfile>[];

      final String searchQuery = query.toLowerCase().trim();
      debugPrint('🔍 Searching users with query: $searchQuery');

      // Search by name (personalInfo.fullName or personalInfo.name)
      QuerySnapshot nameSnapshot = await _usersCollection
          .where('personalInfo.fullName', isGreaterThanOrEqualTo: searchQuery)
          .where('personalInfo.fullName', isLessThan: searchQuery + '\uf8ff')
          .limit(10)
          .get();

      // Search by email
      QuerySnapshot emailSnapshot = await _usersCollection
          .where('personalInfo.email', isGreaterThanOrEqualTo: searchQuery)
          .where('personalInfo.email', isLessThan: searchQuery + '\uf8ff')
          .limit(10)
          .get();

      // Search by phone
      QuerySnapshot phoneSnapshot = await _usersCollection
          .where('personalInfo.phone', isGreaterThanOrEqualTo: searchQuery)
          .where('personalInfo.phone', isLessThan: searchQuery + '\uf8ff')
          .limit(10)
          .get();

      // Combine results and remove duplicates
      Set<String> seenUserIds = {};
      List<FirebaseUserProfile> users = [];

      // Process all snapshots
      for (QuerySnapshot snapshot in [nameSnapshot, emailSnapshot, phoneSnapshot]) {
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          if (!seenUserIds.contains(doc.id)) {
            seenUserIds.add(doc.id);
            try {
              users.add(FirebaseUserProfile.fromFirestore(doc));
            } catch (e) {
              debugPrint('⚠️ Error parsing user ${doc.id}: $e');
            }
          }
        }
      }

      debugPrint('✅ Found ${users.length} unique users');
      return users;
    });

    return result ?? [];
  }
}

// ═══════════════════════════════════════════════════════════════════
// 📊 TRANSACTION SERVICE
// ═══════════════════════════════════════════════════════════════════

class TransactionService {
  static CollectionReference _getTransactionsCollection(String userId) {
    return FirebaseService._firestore
        .collection('users')
        .doc(userId)
        .collection('transactions');
  }

  // ➤ CREATE TRANSACTION
  static Future<String> createTransaction(FirebaseTransaction transaction) async {
    final result = await FirebaseService._handleErrors(() async {
      final docRef = await _getTransactionsCollection(transaction.userId)
          .add(transaction.toFirestore());
      
      debugPrint('✅ Transaction created: ${docRef.id}');
      
      // Update user stats
      await _updateUserStatsAfterTransaction(transaction);
      
      return docRef.id;
    });
    return result ?? '';
  }

  // ➤ GET TRANSACTIONS
  static Future<List<FirebaseTransaction>> getTransactions(String userId, {
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
    bool? isIncome,
    String? categoryId,
  }) async {
    final result = await FirebaseService._handleErrors(() async {
      Query query = _getTransactionsCollection(userId)
          .orderBy('date', descending: true);

      // Apply filters
      if (startDate != null) {
        query = query.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
      }
      if (endDate != null) {
        query = query.where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }
      if (isIncome != null) {
        query = query.where('isIncome', isEqualTo: isIncome);
      }
      if (categoryId != null) {
        query = query.where('categoryId', isEqualTo: categoryId);
      }
      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => FirebaseTransaction.fromFirestore(doc, userId))
          .toList();
    });
    return result ?? [];
  }

  // ➤ GET TRANSACTIONS STREAM (Real-time)
  static Stream<List<FirebaseTransaction>> getTransactionsStream(String userId, {
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    Query query = _getTransactionsCollection(userId)
        .orderBy('date', descending: true);

    if (startDate != null) {
      query = query.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
    }
    if (endDate != null) {
      query = query.where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => FirebaseTransaction.fromFirestore(doc, userId))
            .toList());
  }

  // ➤ UPDATE TRANSACTION
  static Future<void> updateTransaction(FirebaseTransaction transaction) async {
    await FirebaseService._handleErrors(() async {
      await _getTransactionsCollection(transaction.userId)
          .doc(transaction.id)
          .update(transaction.toFirestore());
      
      debugPrint('✅ Transaction updated: ${transaction.id}');
      
      // Update user stats
      await _updateUserStatsAfterTransaction(transaction);
    });
  }

  // ➤ DELETE TRANSACTION
  static Future<void> deleteTransaction(String userId, String transactionId) async {
    await FirebaseService._handleErrors(() async {
      await _getTransactionsCollection(userId).doc(transactionId).delete();
      debugPrint('✅ Transaction deleted: $transactionId');
      
      // Recalculate user stats
      await _recalculateUserStats(userId);
    });
  }

  // ➤ GET MONTHLY SUMMARY
  static Future<Map<String, double>> getMonthlySummary(String userId, DateTime month) async {
    final result = await FirebaseService._handleErrors(() async {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0);

      final transactions = await getTransactions(
        userId,
        startDate: startOfMonth,
        endDate: endOfMonth,
      );

      double totalIncome = 0;
      double totalExpense = 0;

      for (final transaction in transactions) {
        if (transaction.isIncome) {
          totalIncome += transaction.amount;
        } else {
          totalExpense += transaction.amount;
        }
      }

      return {
        'income': totalIncome,
        'expense': totalExpense,
        'balance': totalIncome - totalExpense,
      };
    });
    return result ?? {'income': 0, 'expense': 0, 'balance': 0};
  }

  // ➤ Private: Update user stats after transaction
  static Future<void> _updateUserStatsAfterTransaction(FirebaseTransaction transaction) async {
    // Get current stats and update them
    final userProfile = await UserService.getUserProfile(transaction.userId);
    if (userProfile != null) {
      final updatedStats = ProfileStats(
        totalTransactions: userProfile.stats.totalTransactions + 1,
        totalIncome: transaction.isIncome 
            ? userProfile.stats.totalIncome + transaction.amount
            : userProfile.stats.totalIncome,
        totalExpense: !transaction.isIncome 
            ? userProfile.stats.totalExpense + transaction.amount
            : userProfile.stats.totalExpense,
        activeGoals: userProfile.stats.activeGoals,
        categoriesUsed: userProfile.stats.categoriesUsed,
      );
      
      await UserService.updateUserStats(transaction.userId, updatedStats);
    }
  }

  // ➤ Private: Recalculate user stats
  static Future<void> _recalculateUserStats(String userId) async {
    final transactions = await getTransactions(userId);
    
    int totalTransactions = transactions.length;
    double totalIncome = 0;
    double totalExpense = 0;
    Set<String> categories = {};

    for (final transaction in transactions) {
      if (transaction.isIncome) {
        totalIncome += transaction.amount;
      } else {
        totalExpense += transaction.amount;
      }
      if (transaction.categoryId != null) {
        categories.add(transaction.categoryId!);
      }
    }

    final updatedStats = ProfileStats(
      totalTransactions: totalTransactions,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      activeGoals: 0, // Will be updated by GoalService
      categoriesUsed: categories.length,
    );

    await UserService.updateUserStats(userId, updatedStats);
  }
}

// ═══════════════════════════════════════════════════════════════════
// 🎯 GOAL SERVICE
// ═══════════════════════════════════════════════════════════════════

class GoalService {
  static CollectionReference _getGoalsCollection(String userId) {
    return FirebaseService._firestore
        .collection('users')
        .doc(userId)
        .collection('goals');
  }

  // ➤ CREATE GOAL
  static Future<String> createGoal(FirebaseBudgetGoal goal) async {
    final result = await FirebaseService._handleErrors(() async {
      final docRef = await _getGoalsCollection(goal.userId).add(goal.toFirestore());
      debugPrint('✅ Goal created: ${docRef.id}');
      
      // Update user stats
      await _updateActiveGoalsCount(goal.userId);
      
      return docRef.id;
    });
    return result ?? '';
  }

  // ➤ GET GOALS
  static Future<List<FirebaseBudgetGoal>> getGoals(String userId, {
    bool? isActive,
    bool? isCompleted,
  }) async {
    final result = await FirebaseService._handleErrors(() async {
      Query query = _getGoalsCollection(userId).orderBy('createdAt', descending: true);

      if (isActive != null) {
        query = query.where('isActive', isEqualTo: isActive);
      }
      if (isCompleted != null) {
        query = query.where('isCompleted', isEqualTo: isCompleted);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => FirebaseBudgetGoal.fromFirestore(doc, userId))
          .toList();
    });
    return result ?? [];
  }

  // ➤ GET GOALS STREAM (Real-time)
  static Stream<List<FirebaseBudgetGoal>> getGoalsStream(String userId) {
    return _getGoalsCollection(userId)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FirebaseBudgetGoal.fromFirestore(doc, userId))
            .toList());
  }

  // ➤ UPDATE GOAL
  static Future<void> updateGoal(FirebaseBudgetGoal goal) async {
    await FirebaseService._handleErrors(() async {
      await _getGoalsCollection(goal.userId).doc(goal.id).update(goal.toFirestore());
      debugPrint('✅ Goal updated: ${goal.id}');
    });
  }

  // ➤ UPDATE GOAL PROGRESS
  static Future<void> updateGoalProgress(String userId, String goalId, double newAmount) async {
    await FirebaseService._handleErrors(() async {
      await _getGoalsCollection(userId).doc(goalId).update({
        'currentAmount': newAmount,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      // Check if goal is completed
      final goalDoc = await _getGoalsCollection(userId).doc(goalId).get();
      if (goalDoc.exists) {
        final goal = FirebaseBudgetGoal.fromFirestore(goalDoc, userId);
        if (goal.currentAmount >= goal.targetAmount && !goal.isCompleted) {
          await _getGoalsCollection(userId).doc(goalId).update({
            'isCompleted': true,
            'completedAt': FieldValue.serverTimestamp(),
          });
          debugPrint('🎉 Goal completed: ${goal.title}');
        }
      }
    });
  }

  // ➤ DELETE GOAL
  static Future<void> deleteGoal(String userId, String goalId) async {
    await FirebaseService._handleErrors(() async {
      await _getGoalsCollection(userId).doc(goalId).delete();
      debugPrint('✅ Goal deleted: $goalId');
      
      // Update user stats
      await _updateActiveGoalsCount(userId);
    });
  }

  // ➤ Private: Update active goals count
  static Future<void> _updateActiveGoalsCount(String userId) async {
    final activeGoals = await getGoals(userId, isActive: true);
    final userProfile = await UserService.getUserProfile(userId);
    
    if (userProfile != null) {
      final updatedStats = ProfileStats(
        totalTransactions: userProfile.stats.totalTransactions,
        totalIncome: userProfile.stats.totalIncome,
        totalExpense: userProfile.stats.totalExpense,
        activeGoals: activeGoals.length,
        categoriesUsed: userProfile.stats.categoriesUsed,
      );
      
      await UserService.updateUserStats(userId, updatedStats);
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// 📂 CATEGORY SERVICE
// ═══════════════════════════════════════════════════════════════════

class CategoryService {
  static CollectionReference _getCategoriesCollection(String userId) {
    return FirebaseService._firestore
        .collection('users')
        .doc(userId)
        .collection('categories');
  }

  // ➤ CREATE CATEGORY
  static Future<String> createCategory(FirebaseCategoryModel category) async {
    final result = await FirebaseService._handleErrors(() async {
      final docRef = await _getCategoriesCollection(category.userId).add(category.toFirestore());
      debugPrint('✅ Category created: ${docRef.id}');
      return docRef.id;
    });
    return result ?? '';
  }

  // ➤ GET CATEGORIES
  static Future<List<FirebaseCategoryModel>> getCategories(String userId, {
    String? type, // 'income' or 'expense'
    bool? isActive,
  }) async {
    try {
      debugPrint('🔍 Getting categories for user: $userId, type: $type, isActive: $isActive');
      Query query = _getCategoriesCollection(userId);

      // Only use type filter to avoid composite index requirement
      if (type != null) {
        query = query.where('type', isEqualTo: type);
      }
      // Remove isActive filter from query - will filter in memory

      debugPrint('🔥 Executing Firestore query...');
      final snapshot = await query.get();
      debugPrint('📋 Found ${snapshot.docs.length} categories in Firestore');
      
      final categories = <FirebaseCategoryModel>[];
      for (int i = 0; i < snapshot.docs.length; i++) {
        try {
          final doc = snapshot.docs[i];
          debugPrint('🔄 Processing category ${i + 1}: ${doc.id}');
          final category = FirebaseCategoryModel.fromFirestore(doc, userId);
          
          // Filter isActive in memory
          if (isActive == null || category.isActive == isActive) {
            categories.add(category);
            debugPrint('✅ Successfully parsed category: ${category.name}');
          } else {
            debugPrint('⏭️ Skipped inactive category: ${category.name}');
          }
        } catch (e) {
          debugPrint('💥 Error parsing category ${i + 1}: $e');
          debugPrint('📄 Document data: ${snapshot.docs[i].data()}');
        }
      }
      
      // Sort in memory to avoid index requirement
      categories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      debugPrint('✅ Categories sorted by sortOrder: ${categories.length} total');
      
      return categories;
    } catch (e) {
      debugPrint('💥 Major error in getCategories: $e');
      return [];
    }
  }

  // ➤ GET CATEGORIES STREAM (Real-time)
  static Stream<List<FirebaseCategoryModel>> getCategoriesStream(String userId, {String? type}) {
    Query query = _getCategoriesCollection(userId);

    if (type != null) {
      query = query.where('type', isEqualTo: type);
    }

    return query.snapshots().map((snapshot) {
      final categories = snapshot.docs
          .map((doc) => FirebaseCategoryModel.fromFirestore(doc, userId))
          .where((category) => category.isActive) // Filter active in memory
          .toList();
      
      // Sort in memory
      categories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return categories;
    });
  }

  // ➤ UPDATE CATEGORY
  static Future<void> updateCategory(FirebaseCategoryModel category) async {
    await FirebaseService._handleErrors(() async {
      await _getCategoriesCollection(category.userId).doc(category.id).update(category.toFirestore());
      debugPrint('✅ Category updated: ${category.id}');
    });
  }

  // ➤ DELETE CATEGORY
  static Future<void> deleteCategory(String userId, String categoryId) async {
    await FirebaseService._handleErrors(() async {
      await _getCategoriesCollection(userId).doc(categoryId).delete();
      debugPrint('✅ Category deleted: $categoryId');
    });
  }

  // ➤ CREATE DEFAULT CATEGORIES FOR NEW USER
  static Future<void> createDefaultCategories(String userId) async {
    await FirebaseService._handleErrors(() async {
      debugPrint('🏗️ Creating default categories for user: $userId');
      final defaultCategories = _getDefaultCategories(userId);
      debugPrint('📋 Default categories to create: ${defaultCategories.length}');
      
      for (final category in defaultCategories) {
        debugPrint('➕ Creating category: ${category.name} (${category.type})');
        await _getCategoriesCollection(userId).add(category.toFirestore());
      }
      
      debugPrint('✅ Default categories created for user: $userId');
    });
  }

  // ➤ Private: Get default categories
  static List<FirebaseCategoryModel> _getDefaultCategories(String userId) {
    final now = DateTime.now();
    
    return [
      // Income categories
      FirebaseCategoryModel(
        id: '',
        userId: userId,
        name: 'Maaş',
        iconName: 'work_outlined',
        colorHex: '#10B981',
        type: 'income',
        transactionCount: 0,
        totalAmount: 0,
        isDefault: true,
        isActive: true,
        sortOrder: 1,
        createdAt: now,
        updatedAt: now,
      ),
      FirebaseCategoryModel(
        id: '',
        userId: userId,
        name: 'Freelance',
        iconName: 'laptop_outlined',
        colorHex: '#3B82F6',
        type: 'income',
        transactionCount: 0,
        totalAmount: 0,
        isDefault: true,
        isActive: true,
        sortOrder: 2,
        createdAt: now,
        updatedAt: now,
      ),
      // Expense categories
      FirebaseCategoryModel(
        id: '',
        userId: userId,
        name: 'Market',
        iconName: 'shopping_cart_outlined',
        colorHex: '#EF4444',
        type: 'expense',
        monthlyBudget: 3000,
        transactionCount: 0,
        totalAmount: 0,
        isDefault: true,
        isActive: true,
        sortOrder: 1,
        createdAt: now,
        updatedAt: now,
      ),
      FirebaseCategoryModel(
        id: '',
        userId: userId,
        name: 'Ulaşım',
        iconName: 'local_gas_station_outlined',
        colorHex: '#F59E0B',
        type: 'expense',
        monthlyBudget: 1500,
        transactionCount: 0,
        totalAmount: 0,
        isDefault: true,
        isActive: true,
        sortOrder: 2,
        createdAt: now,
        updatedAt: now,
      ),
      FirebaseCategoryModel(
        id: '',
        userId: userId,
        name: 'Yemek',
        iconName: 'restaurant_outlined',
        colorHex: '#8B5CF6',
        type: 'expense',
        monthlyBudget: 2000,
        transactionCount: 0,
        totalAmount: 0,
        isDefault: true,
        isActive: true,
        sortOrder: 3,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}

// ═══════════════════════════════════════════════════════════════════
// 💳 CARD SERVICE
// ═══════════════════════════════════════════════════════════════════

class CardService {
  static CollectionReference _getCardsCollection(String userId) {
    return FirebaseService._firestore
        .collection('users')
        .doc(userId)
        .collection('cards');
  }

  // ➤ CREATE CARD
  static Future<String> createCard(FirebaseCard card) async {
    final result = await FirebaseService._handleErrors(() async {
      final docRef = await _getCardsCollection(card.userId).add(card.toFirestore());
      debugPrint('✅ Card created: ${docRef.id}');
      return docRef.id;
    });
    return result ?? '';
  }

  // ➤ GET CARDS
  static Future<List<FirebaseCard>> getCards(String userId, {bool? isActive}) async {
    final result = await FirebaseService._handleErrors(() async {
      Query query = _getCardsCollection(userId);

      if (isActive != null) {
        query = query.where('isActive', isEqualTo: isActive);
      }

      final snapshot = await query.get();
      final cards = snapshot.docs
          .map((doc) => FirebaseCard.fromFirestore(doc, userId))
          .toList();
      
      // Sort in memory to avoid index requirement
      cards.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return cards;
    });
    return result ?? [];
  }

  // ➤ GET CARDS STREAM (Real-time)
  static Stream<List<FirebaseCard>> getCardsStream(String userId) {
    debugPrint('🔍 CardService - Getting cards stream for user: $userId');
    
    // Temporary fix: Remove orderBy to avoid index requirement
    return _getCardsCollection(userId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .handleError((error) {
          debugPrint('❌ CardService - Stream error: $error');
        })
        .map((snapshot) {
          debugPrint('📊 CardService - Got ${snapshot.docs.length} cards');
          final cards = snapshot.docs
              .map((doc) {
                try {
                  return FirebaseCard.fromFirestore(doc, userId);
                } catch (e) {
                  debugPrint('❌ CardService - Error parsing card ${doc.id}: $e');
                  rethrow;
                }
              })
              .toList();
          
          // Sort in memory (temporary solution)
          cards.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return cards;
        });
  }

  // ➤ UPDATE CARD
  static Future<void> updateCard(FirebaseCard card) async {
    await FirebaseService._handleErrors(() async {
      await _getCardsCollection(card.userId).doc(card.id).update(card.toFirestore());
      debugPrint('✅ Card updated: ${card.id}');
    });
  }

  // ➤ UPDATE CARD BALANCE
  static Future<void> updateCardBalance(String cardId, double newBalance) async {
    await FirebaseService._handleErrors(() async {
      // Get userId from card document first, or use a simpler approach
      final cardDoc = await FirebaseService._firestore.collectionGroup('cards').where(FieldPath.documentId, isEqualTo: cardId).get();
      
      if (cardDoc.docs.isNotEmpty) {
        await cardDoc.docs.first.reference.update({
          'balance': newBalance,
          'lastUsed': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        debugPrint('✅ Card balance updated: $cardId -> ₺$newBalance');
      } else {
        throw Exception('Card not found: $cardId');
      }
    });
  }

  // ➤ DELETE CARD
  static Future<void> deleteCard(String userId, String cardId) async {
    await FirebaseService._handleErrors(() async {
      await _getCardsCollection(userId).doc(cardId).delete();
      debugPrint('✅ Card deleted: $cardId');
    });
  }

  // ➤ SET DEFAULT CARD
  static Future<void> setDefaultCard(String userId, String cardId) async {
    await FirebaseService._handleErrors(() async {
      // First, remove default from all cards
      final batch = FirebaseService._firestore.batch();
      final allCards = await getCards(userId);
      
      for (final card in allCards) {
        batch.update(_getCardsCollection(userId).doc(card.id), {'isDefault': false});
      }
      
      // Set new default
      batch.update(_getCardsCollection(userId).doc(cardId), {'isDefault': true});
      
      await batch.commit();
      debugPrint('✅ Default card set: $cardId');
    });
  }
}

// ═══════════════════════════════════════════════════════════════════
// ⚙️ SETTINGS SERVICE
// ═══════════════════════════════════════════════════════════════════

class SettingsService {
  static DocumentReference _getSettingsDocument(String userId) {
    return FirebaseService._firestore.collection('users').doc(userId);
  }

  // ➤ UPDATE SETTINGS
  static Future<void> updateSettings(FirebaseUserSettings settings) async {
    await FirebaseService._handleErrors(() async {
      await _getSettingsDocument(settings.userId).update({
        'settings': settings.toFirestore(),
      });
      debugPrint('✅ Settings updated: ${settings.userId}');
    });
  }

  // ➤ GET SETTINGS
  static Future<FirebaseUserSettings?> getSettings(String userId) async {
    return await FirebaseService._handleErrors(() async {
      final doc = await _getSettingsDocument(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('settings')) {
          return FirebaseUserSettings.fromFirestore(doc);
        }
      }
      return null;
    });
  }

  // ➤ GET SETTINGS STREAM (Real-time)
  static Stream<FirebaseUserSettings?> getSettingsStream(String userId) {
    return _getSettingsDocument(userId).snapshots().map((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('settings')) {
          return FirebaseUserSettings.fromFirestore(doc);
        }
      }
      return null;
    });
  }
}

// ===== FEEDBACK SERVICE =====
class FeedbackService extends FirebaseService {
  static const String _collection = 'feedbacks';

  // Create new feedback
  static Future<String?> createFeedback(FirebaseFeedback feedback) async {
    return _handleErrors(() async {
      debugPrint('📝 Creating feedback: ${feedback.title}');
      
      final docRef = await _firestore.collection(_collection).add(feedback.toFirestore());
      
      debugPrint('✅ Feedback created successfully: ${docRef.id}');
      return docRef.id;
    });
  }

  // Get all feedbacks (for admin)
  static Future<List<FirebaseFeedback>?> getAllFeedbacks({
    int limit = 50,
    bool onlyUnresolved = false,
  }) async {
    return _handleErrors(() async {
      debugPrint('📋 Getting all feedbacks...');
      
      Query query = _firestore.collection(_collection);
      
      if (onlyUnresolved) {
        query = query.where('isResolved', isEqualTo: false);
      }
      
      query = query.orderBy('createdAt', descending: true).limit(limit);
      
      final snapshot = await query.get();
      final feedbacks = snapshot.docs.map((doc) => FirebaseFeedback.fromFirestore(doc)).toList();
      
      debugPrint('✅ Retrieved ${feedbacks.length} feedbacks');
      return feedbacks;
    });
  }

  // Get feedbacks by user
  static Future<List<FirebaseFeedback>?> getUserFeedbacks(String userId) async {
    return _handleErrors(() async {
      debugPrint('👤 Getting feedbacks for user: $userId');
      
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      
      final feedbacks = snapshot.docs.map((doc) => FirebaseFeedback.fromFirestore(doc)).toList();
      
      debugPrint('✅ Retrieved ${feedbacks.length} user feedbacks');
      return feedbacks;
    });
  }

  // Update feedback (for admin responses)
  static Future<bool?> updateFeedback(String feedbackId, {
    bool? isResolved,
    String? adminResponse,
  }) async {
    return _handleErrors(() async {
      debugPrint('📝 Updating feedback: $feedbackId');
      
      final updates = <String, dynamic>{};
      
      if (isResolved != null) {
        updates['isResolved'] = isResolved;
      }
      
      if (adminResponse != null) {
        updates['adminResponse'] = adminResponse;
        updates['respondedAt'] = FieldValue.serverTimestamp();
      }
      
      updates['updatedAt'] = FieldValue.serverTimestamp();
      
      await _firestore.collection(_collection).doc(feedbackId).update(updates);
      
      debugPrint('✅ Feedback updated successfully');
      return true;
    });
  }

  // Delete feedback
  static Future<bool?> deleteFeedback(String feedbackId) async {
    return _handleErrors(() async {
      debugPrint('🗑️ Deleting feedback: $feedbackId');
      
      await _firestore.collection(_collection).doc(feedbackId).delete();
      
      debugPrint('✅ Feedback deleted successfully');
      return true;
    });
  }

  // Get feedback statistics
  static Future<Map<String, dynamic>?> getFeedbackStats() async {
    return _handleErrors(() async {
      debugPrint('📊 Getting feedback statistics...');
      
      final snapshot = await _firestore.collection(_collection).get();
      final feedbacks = snapshot.docs.map((doc) => FirebaseFeedback.fromFirestore(doc)).toList();
      
      final Map<String, int> typeBreakdown = <String, int>{};
      final Map<int, int> ratingBreakdown = <int, int>{};
      
      final stats = <String, dynamic>{
        'total': feedbacks.length,
        'resolved': feedbacks.where((f) => f.isResolved).length,
        'unresolved': feedbacks.where((f) => !f.isResolved).length,
        'averageRating': feedbacks.isEmpty ? 0.0 : 
            feedbacks.map((f) => f.rating).reduce((a, b) => a + b) / feedbacks.length,
        'typeBreakdown': typeBreakdown,
        'ratingBreakdown': ratingBreakdown,
      };
      
      // Calculate feedback type breakdown
      for (final feedback in feedbacks) {
        final type = feedback.feedbackType;
        typeBreakdown[type] = (typeBreakdown[type] ?? 0) + 1;
      }
      
      // Calculate rating breakdown
      for (final feedback in feedbacks) {
        final rating = feedback.rating;
        ratingBreakdown[rating] = (ratingBreakdown[rating] ?? 0) + 1;
      }
      
      debugPrint('✅ Feedback stats calculated: ${stats['total']} total feedbacks');
      return stats;
    });
  }

  // Get device info helper
  static String getDeviceInfo() {
    // In a real app, you'd use device_info_plus package
    return 'Flutter App - ${DateTime.now().toString().split(' ')[0]}';
  }

  // Get app version helper  
  static String getAppVersion() {
    // In a real app, you'd use package_info_plus package
    return '1.0.0';
  }
}