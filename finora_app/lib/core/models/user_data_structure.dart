// 🔥 FINORA - USERS COLLECTION VERİ YAPISI
// Her kullanıcı için detaylı Firestore document structure

/*
📂 users/{userId}/
├── 👤 personalInfo (Map)
├── 💰 financialData (Map)
├── ⚙️ settings (Map)
├── 📊 analytics (Map)
├── 🤖 aiPreferences (Map)
├── 🔔 notifications (Map)
└── 📅 metadata (Map)

📂 users/{userId}/transactions/ (Sub-collection)
├── 📄 {transactionId} (Document)

📂 users/{userId}/cards/ (Sub-collection)
├── 💳 {cardId} (Document)

📂 users/{userId}/goals/ (Sub-collection)
├── 🎯 {goalId} (Document)

📂 users/{userId}/categories/ (Sub-collection)
├── 📂 {categoryId} (Document)
*/

// 🎯 MAIN USER DOCUMENT STRUCTURE:

class UserDocumentStructure {
  // 👤 KİŞİSEL BİLGİLER
  static const Map<String, dynamic> personalInfo = {
    'firstName': 'Ahmet',                    // String
    'lastName': 'Yılmaz',                    // String
    'email': 'ahmet@gmail.com',              // String
    'phone': '+90 555 123 4567',             // String
    'dateOfBirth': '1990-05-15',             // String (ISO format)
    'gender': 'male',                        // String: male, female, other
    'profileImageUrl': 'https://...',        // String (nullable)
    'membershipDate': '2024-01-15',          // String (ISO format)
    'accountType': 'premium',                // String: free, premium, gold
    'isVerified': true,                      // bool
    'nationalId': '12345678901',             // String (encrypted)
    'address': {                             // Map
      'street': 'Atatürk Caddesi No:123',
      'district': 'Kadıköy',
      'city': 'İstanbul',
      'postalCode': '34710',
      'country': 'Türkiye'
    }
  };

  // 💰 FİNANSAL VERİLER
  static const Map<String, dynamic> financialData = {
    'totalBalance': 45750.50,                // double
    'monthlyIncome': 15000.0,                // double
    'monthlyExpense': 8500.0,                // double
    'savingsGoal': 50000.0,                  // double
    'currentSavings': 12500.0,               // double
    'creditScore': 785,                      // int (300-850)
    'riskLevel': 'moderate',                 // String: low, moderate, high
    'investmentPortfolio': {                 // Map
      'stocks': 25000.0,
      'bonds': 15000.0,
      'crypto': 5000.0,
      'gold': 10000.0
    },
    'financialHealthScore': 81,              // int (0-100)
    'lastCalculated': '2024-01-15T10:30:00Z' // String (ISO timestamp)
  };

  // ⚙️ AYARLAR
  static const Map<String, dynamic> settings = {
    'language': 'tr',                        // String: tr, en, de, fr, es, ar
    'currency': 'TRY',                       // String: TRY, USD, EUR, etc.
    'theme': 'light',                        // String: light, dark, auto
    'notifications': {                       // Map
      'budgetAlerts': true,                  // bool
      'savingTips': true,                    // bool
      'goalUpdates': false,                  // bool
      'billReminders': true,                 // bool
      'dailySummary': false,                 // bool
      'pushEnabled': true,                   // bool
      'emailEnabled': false,                 // bool
      'smsEnabled': true                     // bool
    },
    'security': {                            // Map
      'biometricEnabled': true,              // bool
      'twoFactorAuth': false,                // bool
      'sessionTimeout': 30,                  // int (minutes)
      'autoLogout': true                     // bool
    },
    'privacy': {                             // Map
      'shareAnalytics': true,                // bool
      'personalizedAds': false,              // bool
      'dataCollection': true                 // bool
    }
  };

  // 📊 ANALİTİK VERİLER
  static const Map<String, dynamic> analytics = {
    'totalTransactions': 156,                // int
    'averageMonthlySpending': 8500.0,        // double
    'topSpendingCategory': 'market',         // String
    'savingsRate': 0.43,                     // double (percentage as decimal)
    'spendingTrends': {                      // Map
      'lastMonth': 8750.0,
      'last3Months': 25500.0,
      'last6Months': 51000.0,
      'lastYear': 102000.0
    },
    'categorySpending': {                    // Map
      'market': 2500.0,
      'transport': 800.0,
      'entertainment': 1200.0,
      'bills': 2000.0,
      'healthcare': 500.0
    },
    'monthlyGrowth': 0.12,                   // double (percentage as decimal)
    'lastUpdated': '2024-01-15T10:30:00Z'    // String (ISO timestamp)
  };

  // 🤖 AI TERCİHLERİ
  static const Map<String, dynamic> aiPreferences = {
    'chatbotEnabled': true,                  // bool
    'autoInsights': true,                    // bool
    'smartRecommendations': true,            // bool
    'predictiveAnalysis': false,             // bool
    'voiceCommands': true,                   // bool
    'personalityType': 'friendly',           // String: friendly, professional, casual
    'responseLength': 'medium',              // String: short, medium, long
    'learningEnabled': true,                 // bool
    'conversationHistory': true,             // bool
    'aiTips': {                              // Map
      'budgeting': true,
      'saving': true,
      'investing': false,
      'spending': true
    }
  };

  // 🔔 BİLDİRİM GEÇMİŞİ
  static const Map<String, dynamic> notifications = {
    'unreadCount': 3,                        // int
    'lastReadTime': '2024-01-15T08:00:00Z',  // String (ISO timestamp)
    'preferences': {                         // Map (same as settings.notifications)
      'budgetAlerts': true,
      'savingTips': true,
      'goalUpdates': false,
      'billReminders': true,
      'dailySummary': false
    }
  };

  // 📅 METADATA
  static const Map<String, dynamic> metadata = {
    'createdAt': '2024-01-01T00:00:00Z',     // String (ISO timestamp)
    'updatedAt': '2024-01-15T10:30:00Z',     // String (ISO timestamp)
    'lastLoginAt': '2024-01-15T09:00:00Z',   // String (ISO timestamp)
    'loginCount': 45,                        // int
    'appVersion': '1.0.0',                   // String
    'deviceInfo': {                          // Map
      'platform': 'android',                // String: android, ios
      'deviceModel': 'SM-G991B',             // String
      'osVersion': '13.0',                   // String
      'appBuild': '100'                      // String
    },
    'isActive': true,                        // bool
    'isDeleted': false                       // bool
  };
}

// 📊 SUB-COLLECTIONS:

// 💳 CARDS SUB-COLLECTION: users/{userId}/cards/{cardId}
class CardDocumentStructure {
  static const Map<String, dynamic> cardDocument = {
    'cardId': 'card_001',                    // String
    'bankName': 'İş Bankası',                // String
    'cardType': 'debit',                     // String: debit, credit
    'cardNumber': '****1234',                // String (masked)
    'cardHolderName': 'AHMET YILMAZ',        // String
    'expiryDate': '12/26',                   // String
    'balance': 15750.50,                     // double
    'currency': 'TRY',                       // String
    'isDefault': true,                       // bool
    'isActive': true,                        // bool
    'cardColor': '#6366F1',                  // String (hex color)
    'lastUsed': '2024-01-15T10:00:00Z',      // String (ISO timestamp)
    'monthlyLimit': 50000.0,                 // double
    'dailyLimit': 5000.0,                    // double
    'createdAt': '2024-01-01T00:00:00Z',     // String (ISO timestamp)
    'updatedAt': '2024-01-15T10:30:00Z'      // String (ISO timestamp)
  };
}

// 📊 TRANSACTIONS SUB-COLLECTION: users/{userId}/transactions/{transactionId}
class TransactionDocumentStructure {
  static const Map<String, dynamic> transactionDocument = {
    'transactionId': 'tx_001',               // String
    'type': 'expense',                       // String: income, expense, transfer
    'amount': 125.50,                        // double
    'currency': 'TRY',                       // String
    'categoryId': 'cat_market',              // String (reference to category)
    'categoryName': 'Market',                // String (denormalized for speed)
    'categoryIcon': 'shopping_cart',         // String
    'categoryColor': '#10B981',              // String (hex color)
    'description': 'Haftalık market alışverişi', // String
    'date': '2024-01-15T14:30:00Z',          // String (ISO timestamp)
    'cardId': 'card_001',                    // String (reference to card)
    'location': {                            // Map (optional)
      'name': 'Migros',
      'address': 'Kadıköy, İstanbul',
      'latitude': 40.9923,
      'longitude': 29.0243
    },
    'tags': ['market', 'yiyecek', 'haftalık'], // Array<String>
    'isRecurring': false,                    // bool
    'recurringPattern': null,                // String (nullable): daily, weekly, monthly
    'attachments': [],                       // Array<String> (image URLs)
    'status': 'completed',                   // String: pending, completed, failed
    'createdAt': '2024-01-15T14:30:00Z',     // String (ISO timestamp)
    'updatedAt': '2024-01-15T14:30:00Z'      // String (ISO timestamp)
  };
}

// 🎯 GOALS SUB-COLLECTION: users/{userId}/goals/{goalId}
class GoalDocumentStructure {
  static const Map<String, dynamic> goalDocument = {
    'goalId': 'goal_001',                    // String
    'title': 'Acil Durum Fonu',             // String
    'description': '6 aylık gelir kadar acil fon', // String
    'targetAmount': 90000.0,                 // double
    'currentAmount': 25000.0,                // double
    'currency': 'TRY',                       // String
    'targetDate': '2024-12-31',              // String (ISO date)
    'category': 'emergency',                 // String: saving, emergency, vacation, etc.
    'priority': 'high',                      // String: low, medium, high
    'isActive': true,                        // bool
    'isCompleted': false,                    // bool
    'completedAt': null,                     // String (nullable, ISO timestamp)
    'monthlyContribution': 10000.0,          // double
    'autoDeduction': true,                   // bool
    'reminderEnabled': true,                 // bool
    'createdAt': '2024-01-01T00:00:00Z',     // String (ISO timestamp)
    'updatedAt': '2024-01-15T10:30:00Z'      // String (ISO timestamp)
  };
}

// 📂 CATEGORIES SUB-COLLECTION: users/{userId}/categories/{categoryId}
class CategoryDocumentStructure {
  static const Map<String, dynamic> categoryDocument = {
    'categoryId': 'cat_market',              // String
    'name': 'Market',                        // String
    'icon': 'shopping_cart',                 // String
    'color': '#10B981',                      // String (hex color)
    'type': 'expense',                       // String: income, expense
    'monthlyBudget': 3000.0,                 // double
    'currentSpent': 1250.0,                  // double
    'currency': 'TRY',                       // String
    'isDefault': false,                      // bool
    'isActive': true,                        // bool
    'parentCategoryId': null,                // String (nullable, for subcategories)
    'sortOrder': 1,                          // int
    'createdAt': '2024-01-01T00:00:00Z',     // String (ISO timestamp)
    'updatedAt': '2024-01-15T10:30:00Z'      // String (ISO timestamp)
  };
}