import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('tr', 'TR'), // Turkish
    Locale('en', 'US'), // English
    Locale('de', 'DE'), // German
    Locale('fr', 'FR'), // French
    Locale('es', 'ES'), // Spanish
    Locale('ar', 'SA'), // Arabic
  ];

  String get languageCode => locale.languageCode;

  // Common Terms
  String get appName => _getValue('app_name');
  String get welcome => _getValue('welcome');
  String get continueText => _getValue('continue');
  String get cancel => _getValue('cancel');
  String get save => _getValue('save');
  String get delete => _getValue('delete');
  String get edit => _getValue('edit');
  String get add => _getValue('add');
  String get search => _getValue('search');
  String get filter => _getValue('filter');
  String get sort => _getValue('sort');
  String get settings => _getValue('settings');
  String get profile => _getValue('profile');
  String get logout => _getValue('logout');
  String get loading => _getValue('loading');
  String get error => _getValue('error');
  String get success => _getValue('success');
  String get warning => _getValue('warning');
  String get info => _getValue('info');
  String get yes => _getValue('yes');
  String get no => _getValue('no');
  String get ok => _getValue('ok');
  String get close => _getValue('close');
  String get back => _getValue('back');
  String get next => _getValue('next');
  String get previous => _getValue('previous');
  String get done => _getValue('done');
  String get submit => _getValue('submit');
  String get confirm => _getValue('confirm');
  String get retry => _getValue('retry');
  String get refresh => _getValue('refresh');
  String get share => _getValue('share');
  String get copy => _getValue('copy');
  String get clear => _getValue('clear');

  // Navigation
  String get dashboard => _getValue('dashboard');
  String get addTransaction => _getValue('add_transaction');
  String get history => _getValue('history');
  String get analytics => _getValue('analytics');
  String get budgetGoals => _getValue('budget_goals');
  String get categories => _getValue('categories');
  String get helpCenter => _getValue('help_center');
  String get feedback => _getValue('feedback');

  // Financial Terms
  String get income => _getValue('income');
  String get expense => _getValue('expense');
  String get amount => _getValue('amount');
  String get balance => _getValue('balance');
  String get transaction => _getValue('transaction');
  String get transactions => _getValue('transactions');
  String get total => _getValue('total');
  String get category => _getValue('category');
  String get date => _getValue('date');
  String get description => _getValue('description');
  String get budget => _getValue('budget');
  String get goal => _getValue('goal');
  String get goals => _getValue('goals');
  String get savings => _getValue('savings');
  String get spending => _getValue('spending');
  String get summary => _getValue('summary');
  String get report => _getValue('report');
  String get reports => _getValue('reports');

  // Authentication
  String get login => _getValue('login');
  String get register => _getValue('register');
  String get email => _getValue('email');
  String get password => _getValue('password');
  String get confirmPassword => _getValue('confirm_password');
  String get forgotPassword => _getValue('forgot_password');
  String get resetPassword => _getValue('reset_password');
  String get createAccount => _getValue('create_account');
  String get alreadyHaveAccount => _getValue('already_have_account');
  String get dontHaveAccount => _getValue('dont_have_account');
  String get signInWithGoogle => _getValue('sign_in_with_google');
  String get signInWithApple => _getValue('sign_in_with_apple');

  // Settings
  String get language => _getValue('language');
  String get currency => _getValue('currency');
  String get notifications => _getValue('notifications');
  String get security => _getValue('security');
  String get privacy => _getValue('privacy');
  String get termsOfUse => _getValue('terms_of_use');
  String get privacyPolicy => _getValue('privacy_policy');
  String get aboutApp => _getValue('about_app');
  String get version => _getValue('version');
  String get contactUs => _getValue('contact_us');
  String get rateApp => _getValue('rate_app');
  String get shareApp => _getValue('share_app');

  // Time Periods
  String get today => _getValue('today');
  String get yesterday => _getValue('yesterday');
  String get thisWeek => _getValue('this_week');
  String get lastWeek => _getValue('last_week');
  String get thisMonth => _getValue('this_month');
  String get lastMonth => _getValue('last_month');
  String get thisYear => _getValue('this_year');
  String get lastYear => _getValue('last_year');
  String get custom => _getValue('custom');

  // Categories
  String get food => _getValue('food');
  String get transport => _getValue('transport');
  String get shopping => _getValue('shopping');
  String get entertainment => _getValue('entertainment');
  String get health => _getValue('health');
  String get education => _getValue('education');
  String get utilities => _getValue('utilities');
  String get rent => _getValue('rent');
  String get insurance => _getValue('insurance');
  String get investment => _getValue('investment');
  String get salary => _getValue('salary');
  String get freelance => _getValue('freelance');
  String get business => _getValue('business');
  String get gift => _getValue('gift');
  String get other => _getValue('other');

  // Messages
  String get transactionAddedSuccessfully =>
      _getValue('transaction_added_successfully');
  String get transactionDeletedSuccessfully =>
      _getValue('transaction_deleted_successfully');
  String get budgetGoalCreated => _getValue('budget_goal_created');
  String get categoryCreated => _getValue('category_created');
  String get settingsSaved => _getValue('settings_saved');
  String get passwordResetEmailSent => _getValue('password_reset_email_sent');
  String get loginSuccessful => _getValue('login_successful');
  String get registrationSuccessful => _getValue('registration_successful');
  String get feedbackSubmitted => _getValue('feedback_submitted');
  String get comingSoon => _getValue('coming_soon');

  // Error Messages
  String get invalidEmail => _getValue('invalid_email');
  String get weakPassword => _getValue('weak_password');
  String get passwordsDontMatch => _getValue('passwords_dont_match');
  String get emailAlreadyInUse => _getValue('email_already_in_use');
  String get userNotFound => _getValue('user_not_found');
  String get wrongPassword => _getValue('wrong_password');
  String get networkError => _getValue('network_error');
  String get somethingWentWrong => _getValue('something_went_wrong');
  String get pleaseEnterValidAmount => _getValue('please_enter_valid_amount');
  String get pleaseSelectCategory => _getValue('please_select_category');
  String get pleaseEnterDescription => _getValue('please_enter_description');
  String get fieldRequired => _getValue('field_required');

  // Numbers and formatting
  String get thousand => _getValue('thousand');
  String get million => _getValue('million');
  String get billion => _getValue('billion');

  // Help Center
  String get frequentlyAskedQuestions =>
      _getValue('frequently_asked_questions');
  String get howToAddTransaction => _getValue('how_to_add_transaction');
  String get howToSetBudget => _getValue('how_to_set_budget');
  String get howToExportData => _getValue('how_to_export_data');
  String get contactSupport => _getValue('contact_support');
  String get sendEmail => _getValue('send_email');
  String get callUs => _getValue('call_us');
  String get liveChat => _getValue('live_chat');

  // Feedback
  String get feedbackType => _getValue('feedback_type');
  String get suggestion => _getValue('suggestion');
  String get bugReport => _getValue('bug_report');
  String get feature => _getValue('feature');
  String get complaint => _getValue('complaint');
  String get compliment => _getValue('compliment');
  String get rating => _getValue('rating');
  String get title => _getValue('title');
  String get yourFeedback => _getValue('your_feedback');
  String get contactEmail => _getValue('contact_email');

  // Profile
  String get personalInfo => _getValue('personal_info');
  String get accountSettings => _getValue('account_settings');
  String get securitySettings => _getValue('security_settings');
  String get notificationSettings => _getValue('notification_settings');
  String get dataBackup => _getValue('data_backup');
  String get downloadReport => _getValue('download_report');
  String get deleteAccount => _getValue('delete_account');
  String get changePassword => _getValue('change_password');
  String get twoFactorAuth => _getValue('two_factor_auth');
  String get loginHistory => _getValue('login_history');

  // Statistics
  String get totalTransactions => _getValue('total_transactions');
  String get totalIncome => _getValue('total_income');
  String get totalExpense => _getValue('total_expense');
  String get activeGoals => _getValue('active_goals');
  String get monthlyAverage => _getValue('monthly_average');
  String get topCategory => _getValue('top_category');
  String get savingsRate => _getValue('savings_rate');

  // Internal method to get localized values
  String _getValue(String key) {
    switch (languageCode) {
      case 'tr':
        return _turkishValues[key] ?? _englishValues[key] ?? key;
      case 'de':
        return _germanValues[key] ?? _englishValues[key] ?? key;
      case 'fr':
        return _frenchValues[key] ?? _englishValues[key] ?? key;
      case 'es':
        return _spanishValues[key] ?? _englishValues[key] ?? key;
      case 'ar':
        return _arabicValues[key] ?? _englishValues[key] ?? key;
      default:
        return _englishValues[key] ?? key;
    }
  }

  // Turkish translations
  static const Map<String, String> _turkishValues = {
    'app_name': 'Finora',
    'welcome': 'Hoş Geldiniz',
    'continue': 'Devam Et',
    'cancel': 'İptal',
    'save': 'Kaydet',
    'delete': 'Sil',
    'edit': 'Düzenle',
    'add': 'Ekle',
    'search': 'Ara',
    'filter': 'Filtrele',
    'sort': 'Sırala',
    'settings': 'Ayarlar',
    'profile': 'Profil',
    'logout': 'Çıkış Yap',
    'loading': 'Yükleniyor',
    'error': 'Hata',
    'success': 'Başarılı',
    'warning': 'Uyarı',
    'info': 'Bilgi',
    'yes': 'Evet',
    'no': 'Hayır',
    'ok': 'Tamam',
    'close': 'Kapat',
    'back': 'Geri',
    'next': 'İleri',
    'previous': 'Önceki',
    'done': 'Bitti',
    'submit': 'Gönder',
    'confirm': 'Onayla',
    'retry': 'Tekrar Dene',
    'refresh': 'Yenile',
    'share': 'Paylaş',
    'copy': 'Kopyala',
    'clear': 'Temizle',

    // Navigation
    'dashboard': 'Ana Sayfa',
    'add_transaction': 'İşlem Ekle',
    'history': 'Geçmiş',
    'analytics': 'Analitik',
    'budget_goals': 'Bütçe Hedefleri',
    'categories': 'Kategoriler',
    'help_center': 'Yardım Merkezi',
    'feedback': 'Geri Bildirim',

    // Financial Terms
    'income': 'Gelir',
    'expense': 'Gider',
    'amount': 'Tutar',
    'balance': 'Bakiye',
    'transaction': 'İşlem',
    'transactions': 'İşlemler',
    'total': 'Toplam',
    'category': 'Kategori',
    'date': 'Tarih',
    'description': 'Açıklama',
    'budget': 'Bütçe',
    'goal': 'Hedef',
    'goals': 'Hedefler',
    'savings': 'Tasarruf',
    'spending': 'Harcama',
    'summary': 'Özet',
    'report': 'Rapor',
    'reports': 'Raporlar',

    // Authentication
    'login': 'Giriş Yap',
    'register': 'Kayıt Ol',
    'email': 'E-posta',
    'password': 'Şifre',
    'confirm_password': 'Şifre Onayla',
    'forgot_password': 'Şifremi Unuttum',
    'reset_password': 'Şifre Sıfırla',
    'create_account': 'Hesap Oluştur',
    'already_have_account': 'Zaten hesabınız var mı?',
    'dont_have_account': 'Hesabınız yok mu?',
    'sign_in_with_google': 'Google ile Giriş Yap',
    'sign_in_with_apple': 'Apple ile Giriş Yap',

    // Settings
    'language': 'Dil',
    'currency': 'Para Birimi',
    'notifications': 'Bildirimler',
    'security': 'Güvenlik',
    'privacy': 'Gizlilik',
    'terms_of_use': 'Kullanım Şartları',
    'privacy_policy': 'Gizlilik Politikası',
    'about_app': 'Uygulama Hakkında',
    'version': 'Sürüm',
    'contact_us': 'İletişim',
    'rate_app': 'Uygulamayı Değerlendir',
    'share_app': 'Uygulamayı Paylaş',

    // Time Periods
    'today': 'Bugün',
    'yesterday': 'Dün',
    'this_week': 'Bu Hafta',
    'last_week': 'Geçen Hafta',
    'this_month': 'Bu Ay',
    'last_month': 'Geçen Ay',
    'this_year': 'Bu Yıl',
    'last_year': 'Geçen Yıl',
    'custom': 'Özel',

    // Categories
    'food': 'Yemek',
    'transport': 'Ulaşım',
    'shopping': 'Alışveriş',
    'entertainment': 'Eğlence',
    'health': 'Sağlık',
    'education': 'Eğitim',
    'utilities': 'Faturalar',
    'rent': 'Kira',
    'insurance': 'Sigorta',
    'investment': 'Yatırım',
    'salary': 'Maaş',
    'freelance': 'Serbest Çalışma',
    'business': 'İş',
    'gift': 'Hediye',
    'other': 'Diğer',

    // Messages
    'transaction_added_successfully': 'İşlem başarıyla eklendi!',
    'transaction_deleted_successfully': 'İşlem başarıyla silindi!',
    'budget_goal_created': 'Bütçe hedefi oluşturuldu!',
    'category_created': 'Kategori oluşturuldu!',
    'settings_saved': 'Ayarlar kaydedildi!',
    'password_reset_email_sent': 'Şifre sıfırlama e-postası gönderildi!',
    'login_successful': 'Giriş başarılı!',
    'registration_successful': 'Kayıt başarılı!',
    'feedback_submitted': 'Geri bildiriminiz gönderildi!',
    'coming_soon': 'Yakında geliyor!',

    // Error Messages
    'invalid_email': 'Geçersiz e-posta adresi',
    'weak_password': 'Şifre çok zayıf',
    'passwords_dont_match': 'Şifreler eşleşmiyor',
    'email_already_in_use': 'Bu e-posta adresi zaten kullanımda',
    'user_not_found': 'Kullanıcı bulunamadı',
    'wrong_password': 'Yanlış şifre',
    'network_error': 'Ağ hatası',
    'something_went_wrong': 'Bir şeyler yanlış gitti',
    'please_enter_valid_amount': 'Lütfen geçerli bir tutar girin',
    'please_select_category': 'Lütfen bir kategori seçin',
    'please_enter_description': 'Lütfen açıklama girin',
    'field_required': 'Bu alan zorunludur',

    // Numbers
    'thousand': 'B',
    'million': 'M',
    'billion': 'Mr',

    // Help Center
    'frequently_asked_questions': 'Sık Sorulan Sorular',
    'how_to_add_transaction': 'İşlem Nasıl Eklenir?',
    'how_to_set_budget': 'Bütçe Nasıl Belirlenir?',
    'how_to_export_data': 'Veriler Nasıl Dışa Aktarılır?',
    'contact_support': 'Destek ile İletişim',
    'send_email': 'E-posta Gönder',
    'call_us': 'Bizi Arayın',
    'live_chat': 'Canlı Sohbet',

    // Feedback
    'feedback_type': 'Geri Bildirim Türü',
    'suggestion': 'Öneri',
    'bug_report': 'Hata Bildirimi',
    'feature': 'Özellik İsteği',
    'complaint': 'Şikayet',
    'compliment': 'Tebrik',
    'rating': 'Değerlendirme',
    'title': 'Başlık',
    'your_feedback': 'Geri Bildiriminiz',
    'contact_email': 'İletişim E-postası',

    // Profile
    'personal_info': 'Kişisel Bilgiler',
    'account_settings': 'Hesap Ayarları',
    'security_settings': 'Güvenlik Ayarları',
    'notification_settings': 'Bildirim Ayarları',
    'data_backup': 'Veri Yedekleme',
    'download_report': 'Rapor İndir',
    'delete_account': 'Hesabı Sil',
    'change_password': 'Şifre Değiştir',
    'two_factor_auth': 'İki Faktörlü Doğrulama',
    'login_history': 'Giriş Geçmişi',

    // Statistics
    'total_transactions': 'Toplam İşlem',
    'total_income': 'Toplam Gelir',
    'total_expense': 'Toplam Gider',
    'active_goals': 'Aktif Hedefler',
    'monthly_average': 'Aylık Ortalama',
    'top_category': 'En Çok Harcanan',
    'savings_rate': 'Tasarruf Oranı',
  };

  // English translations
  static const Map<String, String> _englishValues = {
    'app_name': 'Finora',
    'welcome': 'Welcome',
    'continue': 'Continue',
    'cancel': 'Cancel',
    'save': 'Save',
    'delete': 'Delete',
    'edit': 'Edit',
    'add': 'Add',
    'search': 'Search',
    'filter': 'Filter',
    'sort': 'Sort',
    'settings': 'Settings',
    'profile': 'Profile',
    'logout': 'Logout',
    'loading': 'Loading',
    'error': 'Error',
    'success': 'Success',
    'warning': 'Warning',
    'info': 'Info',
    'yes': 'Yes',
    'no': 'No',
    'ok': 'OK',
    'close': 'Close',
    'back': 'Back',
    'next': 'Next',
    'previous': 'Previous',
    'done': 'Done',
    'submit': 'Submit',
    'confirm': 'Confirm',
    'retry': 'Retry',
    'refresh': 'Refresh',
    'share': 'Share',
    'copy': 'Copy',
    'clear': 'Clear',

    // Navigation
    'dashboard': 'Dashboard',
    'add_transaction': 'Add Transaction',
    'history': 'History',
    'analytics': 'Analytics',
    'budget_goals': 'Budget Goals',
    'categories': 'Categories',
    'help_center': 'Help Center',
    'feedback': 'Feedback',

    // Financial Terms
    'income': 'Income',
    'expense': 'Expense',
    'amount': 'Amount',
    'balance': 'Balance',
    'transaction': 'Transaction',
    'transactions': 'Transactions',
    'total': 'Total',
    'category': 'Category',
    'date': 'Date',
    'description': 'Description',
    'budget': 'Budget',
    'goal': 'Goal',
    'goals': 'Goals',
    'savings': 'Savings',
    'spending': 'Spending',
    'summary': 'Summary',
    'report': 'Report',
    'reports': 'Reports',

    // Authentication
    'login': 'Login',
    'register': 'Register',
    'email': 'Email',
    'password': 'Password',
    'confirm_password': 'Confirm Password',
    'forgot_password': 'Forgot Password',
    'reset_password': 'Reset Password',
    'create_account': 'Create Account',
    'already_have_account': 'Already have an account?',
    'dont_have_account': "Don't have an account?",
    'sign_in_with_google': 'Sign in with Google',
    'sign_in_with_apple': 'Sign in with Apple',

    // Settings
    'language': 'Language',
    'currency': 'Currency',
    'notifications': 'Notifications',
    'security': 'Security',
    'privacy': 'Privacy',
    'terms_of_use': 'Terms of Use',
    'privacy_policy': 'Privacy Policy',
    'about_app': 'About App',
    'version': 'Version',
    'contact_us': 'Contact Us',
    'rate_app': 'Rate App',
    'share_app': 'Share App',

    // Time Periods
    'today': 'Today',
    'yesterday': 'Yesterday',
    'this_week': 'This Week',
    'last_week': 'Last Week',
    'this_month': 'This Month',
    'last_month': 'Last Month',
    'this_year': 'This Year',
    'last_year': 'Last Year',
    'custom': 'Custom',

    // Categories
    'food': 'Food',
    'transport': 'Transport',
    'shopping': 'Shopping',
    'entertainment': 'Entertainment',
    'health': 'Health',
    'education': 'Education',
    'utilities': 'Utilities',
    'rent': 'Rent',
    'insurance': 'Insurance',
    'investment': 'Investment',
    'salary': 'Salary',
    'freelance': 'Freelance',
    'business': 'Business',
    'gift': 'Gift',
    'other': 'Other',

    // Messages
    'transaction_added_successfully': 'Transaction added successfully!',
    'transaction_deleted_successfully': 'Transaction deleted successfully!',
    'budget_goal_created': 'Budget goal created!',
    'category_created': 'Category created!',
    'settings_saved': 'Settings saved!',
    'password_reset_email_sent': 'Password reset email sent!',
    'login_successful': 'Login successful!',
    'registration_successful': 'Registration successful!',
    'feedback_submitted': 'Feedback submitted!',
    'coming_soon': 'Coming soon!',

    // Error Messages
    'invalid_email': 'Invalid email address',
    'weak_password': 'Password is too weak',
    'passwords_dont_match': "Passwords don't match",
    'email_already_in_use': 'Email is already in use',
    'user_not_found': 'User not found',
    'wrong_password': 'Wrong password',
    'network_error': 'Network error',
    'something_went_wrong': 'Something went wrong',
    'please_enter_valid_amount': 'Please enter a valid amount',
    'please_select_category': 'Please select a category',
    'please_enter_description': 'Please enter description',
    'field_required': 'This field is required',

    // Numbers
    'thousand': 'K',
    'million': 'M',
    'billion': 'B',

    // Help Center
    'frequently_asked_questions': 'Frequently Asked Questions',
    'how_to_add_transaction': 'How to Add Transaction?',
    'how_to_set_budget': 'How to Set Budget?',
    'how_to_export_data': 'How to Export Data?',
    'contact_support': 'Contact Support',
    'send_email': 'Send Email',
    'call_us': 'Call Us',
    'live_chat': 'Live Chat',

    // Feedback
    'feedback_type': 'Feedback Type',
    'suggestion': 'Suggestion',
    'bug_report': 'Bug Report',
    'feature': 'Feature Request',
    'complaint': 'Complaint',
    'compliment': 'Compliment',
    'rating': 'Rating',
    'title': 'Title',
    'your_feedback': 'Your Feedback',
    'contact_email': 'Contact Email',

    // Profile
    'personal_info': 'Personal Info',
    'account_settings': 'Account Settings',
    'security_settings': 'Security Settings',
    'notification_settings': 'Notification Settings',
    'data_backup': 'Data Backup',
    'download_report': 'Download Report',
    'delete_account': 'Delete Account',
    'change_password': 'Change Password',
    'two_factor_auth': 'Two-Factor Auth',
    'login_history': 'Login History',

    // Statistics
    'total_transactions': 'Total Transactions',
    'total_income': 'Total Income',
    'total_expense': 'Total Expense',
    'active_goals': 'Active Goals',
    'monthly_average': 'Monthly Average',
    'top_category': 'Top Category',
    'savings_rate': 'Savings Rate',
  };

  // German translations
  static const Map<String, String> _germanValues = {
    'app_name': 'Finora',
    'welcome': 'Willkommen',
    'continue': 'Fortfahren',
    'cancel': 'Abbrechen',
    'save': 'Speichern',
    'delete': 'Löschen',
    'edit': 'Bearbeiten',
    'add': 'Hinzufügen',
    'search': 'Suchen',
    'filter': 'Filtern',
    'sort': 'Sortieren',
    'settings': 'Einstellungen',
    'profile': 'Profil',
    'logout': 'Abmelden',
    'loading': 'Laden',
    'error': 'Fehler',
    'success': 'Erfolg',
    'warning': 'Warnung',
    'info': 'Information',
    'yes': 'Ja',
    'no': 'Nein',
    'ok': 'OK',
    'close': 'Schließen',
    'back': 'Zurück',
    'next': 'Weiter',
    'previous': 'Vorherige',
    'done': 'Fertig',
    'submit': 'Senden',
    'confirm': 'Bestätigen',
    'retry': 'Wiederholen',
    'refresh': 'Aktualisieren',
    'share': 'Teilen',
    'copy': 'Kopieren',
    'clear': 'Löschen',

    // Navigation
    'dashboard': 'Dashboard',
    'add_transaction': 'Transaktion Hinzufügen',
    'history': 'Verlauf',
    'analytics': 'Analysen',
    'budget_goals': 'Budget-Ziele',
    'categories': 'Kategorien',
    'help_center': 'Hilfe-Center',
    'feedback': 'Feedback',

    // Financial Terms
    'income': 'Einkommen',
    'expense': 'Ausgabe',
    'amount': 'Betrag',
    'balance': 'Saldo',
    'transaction': 'Transaktion',
    'transactions': 'Transaktionen',
    'total': 'Gesamt',
    'category': 'Kategorie',
    'date': 'Datum',
    'description': 'Beschreibung',
    'budget': 'Budget',
    'goal': 'Ziel',
    'goals': 'Ziele',
    'savings': 'Ersparnisse',
    'spending': 'Ausgaben',
    'summary': 'Zusammenfassung',
    'report': 'Bericht',
    'reports': 'Berichte',

    // Categories
    'food': 'Essen',
    'transport': 'Transport',
    'shopping': 'Einkaufen',
    'entertainment': 'Unterhaltung',
    'health': 'Gesundheit',
    'education': 'Bildung',
    'utilities': 'Versorgung',
    'rent': 'Miete',
    'insurance': 'Versicherung',
    'investment': 'Investition',
    'salary': 'Gehalt',
    'freelance': 'Freiberuflich',
    'business': 'Geschäft',
    'gift': 'Geschenk',
    'other': 'Andere',
  };

  // French translations
  static const Map<String, String> _frenchValues = {
    'app_name': 'Finora',
    'welcome': 'Bienvenue',
    'continue': 'Continuer',
    'cancel': 'Annuler',
    'save': 'Enregistrer',
    'delete': 'Supprimer',
    'edit': 'Modifier',
    'add': 'Ajouter',
    'search': 'Rechercher',
    'filter': 'Filtrer',
    'sort': 'Trier',
    'settings': 'Paramètres',
    'profile': 'Profil',
    'logout': 'Se déconnecter',
    'loading': 'Chargement',
    'error': 'Erreur',
    'success': 'Succès',
    'warning': 'Avertissement',
    'info': 'Information',
    'yes': 'Oui',
    'no': 'Non',
    'ok': 'OK',
    'close': 'Fermer',
    'back': 'Retour',
    'next': 'Suivant',
    'previous': 'Précédent',
    'done': 'Terminé',
    'submit': 'Soumettre',
    'confirm': 'Confirmer',
    'retry': 'Réessayer',
    'refresh': 'Actualiser',
    'share': 'Partager',
    'copy': 'Copier',
    'clear': 'Effacer',

    // Navigation
    'dashboard': 'Tableau de bord',
    'add_transaction': 'Ajouter Transaction',
    'history': 'Historique',
    'analytics': 'Analyses',
    'budget_goals': 'Objectifs Budget',
    'categories': 'Catégories',
    'help_center': 'Centre d\'aide',
    'feedback': 'Commentaire',

    // Financial Terms
    'income': 'Revenu',
    'expense': 'Dépense',
    'amount': 'Montant',
    'balance': 'Solde',
    'transaction': 'Transaction',
    'transactions': 'Transactions',
    'total': 'Total',
    'category': 'Catégorie',
    'date': 'Date',
    'description': 'Description',
    'budget': 'Budget',
    'goal': 'Objectif',
    'goals': 'Objectifs',
    'savings': 'Économies',
    'spending': 'Dépenses',
    'summary': 'Résumé',
    'report': 'Rapport',
    'reports': 'Rapports',

    // Categories
    'food': 'Nourriture',
    'transport': 'Transport',
    'shopping': 'Shopping',
    'entertainment': 'Divertissement',
    'health': 'Santé',
    'education': 'Éducation',
    'utilities': 'Services publics',
    'rent': 'Loyer',
    'insurance': 'Assurance',
    'investment': 'Investissement',
    'salary': 'Salaire',
    'freelance': 'Freelance',
    'business': 'Affaires',
    'gift': 'Cadeau',
    'other': 'Autre',
  };

  // Spanish translations
  static const Map<String, String> _spanishValues = {
    'app_name': 'Finora',
    'welcome': 'Bienvenido',
    'continue': 'Continuar',
    'cancel': 'Cancelar',
    'save': 'Guardar',
    'delete': 'Eliminar',
    'edit': 'Editar',
    'add': 'Agregar',
    'search': 'Buscar',
    'filter': 'Filtrar',
    'sort': 'Ordenar',
    'settings': 'Configuración',
    'profile': 'Perfil',
    'logout': 'Cerrar sesión',
    'loading': 'Cargando',
    'error': 'Error',
    'success': 'Éxito',
    'warning': 'Advertencia',
    'info': 'Información',
    'yes': 'Sí',
    'no': 'No',
    'ok': 'OK',
    'close': 'Cerrar',
    'back': 'Atrás',
    'next': 'Siguiente',
    'previous': 'Anterior',
    'done': 'Hecho',
    'submit': 'Enviar',
    'confirm': 'Confirmar',
    'retry': 'Reintentar',
    'refresh': 'Actualizar',
    'share': 'Compartir',
    'copy': 'Copiar',
    'clear': 'Limpiar',

    // Navigation
    'dashboard': 'Panel',
    'add_transaction': 'Agregar Transacción',
    'history': 'Historial',
    'analytics': 'Análisis',
    'budget_goals': 'Metas Presupuesto',
    'categories': 'Categorías',
    'help_center': 'Centro de Ayuda',
    'feedback': 'Comentarios',

    // Financial Terms
    'income': 'Ingresos',
    'expense': 'Gasto',
    'amount': 'Cantidad',
    'balance': 'Saldo',
    'transaction': 'Transacción',
    'transactions': 'Transacciones',
    'total': 'Total',
    'category': 'Categoría',
    'date': 'Fecha',
    'description': 'Descripción',
    'budget': 'Presupuesto',
    'goal': 'Meta',
    'goals': 'Metas',
    'savings': 'Ahorros',
    'spending': 'Gastos',
    'summary': 'Resumen',
    'report': 'Informe',
    'reports': 'Informes',

    // Categories
    'food': 'Comida',
    'transport': 'Transporte',
    'shopping': 'Compras',
    'entertainment': 'Entretenimiento',
    'health': 'Salud',
    'education': 'Educación',
    'utilities': 'Servicios',
    'rent': 'Alquiler',
    'insurance': 'Seguro',
    'investment': 'Inversión',
    'salary': 'Salario',
    'freelance': 'Freelance',
    'business': 'Negocio',
    'gift': 'Regalo',
    'other': 'Otro',
  };

  // Arabic translations
  static const Map<String, String> _arabicValues = {
    'app_name': 'فينورا',
    'welcome': 'مرحباً',
    'continue': 'متابعة',
    'cancel': 'إلغاء',
    'save': 'حفظ',
    'delete': 'حذف',
    'edit': 'تعديل',
    'add': 'إضافة',
    'search': 'بحث',
    'filter': 'تصفية',
    'sort': 'ترتيب',
    'settings': 'الإعدادات',
    'profile': 'الملف الشخصي',
    'logout': 'تسجيل الخروج',
    'loading': 'جاري التحميل',
    'error': 'خطأ',
    'success': 'نجح',
    'warning': 'تحذير',
    'info': 'معلومات',
    'yes': 'نعم',
    'no': 'لا',
    'ok': 'موافق',
    'close': 'إغلاق',
    'back': 'رجوع',
    'next': 'التالي',
    'previous': 'السابق',
    'done': 'تم',
    'submit': 'إرسال',
    'confirm': 'تأكيد',
    'retry': 'إعادة المحاولة',
    'refresh': 'تحديث',
    'share': 'مشاركة',
    'copy': 'نسخ',
    'clear': 'مسح',

    // Navigation
    'dashboard': 'لوحة التحكم',
    'add_transaction': 'إضافة معاملة',
    'history': 'التاريخ',
    'analytics': 'التحليلات',
    'budget_goals': 'أهداف الميزانية',
    'categories': 'الفئات',
    'help_center': 'مركز المساعدة',
    'feedback': 'التعليقات',

    // Financial Terms
    'income': 'الدخل',
    'expense': 'المصروف',
    'amount': 'المبلغ',
    'balance': 'الرصيد',
    'transaction': 'المعاملة',
    'transactions': 'المعاملات',
    'total': 'المجموع',
    'category': 'الفئة',
    'date': 'التاريخ',
    'description': 'الوصف',
    'budget': 'الميزانية',
    'goal': 'الهدف',
    'goals': 'الأهداف',
    'savings': 'المدخرات',
    'spending': 'الإنفاق',
    'summary': 'الملخص',
    'report': 'التقرير',
    'reports': 'التقارير',

    // Categories
    'food': 'الطعام',
    'transport': 'النقل',
    'shopping': 'التسوق',
    'entertainment': 'الترفيه',
    'health': 'الصحة',
    'education': 'التعليم',
    'utilities': 'المرافق',
    'rent': 'الإيجار',
    'insurance': 'التأمين',
    'investment': 'الاستثمار',
    'salary': 'الراتب',
    'freelance': 'العمل الحر',
    'business': 'الأعمال',
    'gift': 'الهدية',
    'other': 'أخرى',
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .map((l) => l.languageCode)
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
