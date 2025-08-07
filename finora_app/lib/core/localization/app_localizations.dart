import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('tr', 'TR'), // Türkçe
    Locale('en', 'US'), // İngilizce
    Locale('de', 'DE'), // Almanca
    Locale('fr', 'FR'), // Fransızca
    Locale('es', 'ES'), // İspanyolca
    Locale('ar', 'SA'), // Arapça
  ];

  // Genel
  String get appName => _getValue('app_name');
  String get welcome => _getValue('welcome');
  String get continueText => _getValue('continue');
  String get cancel => _getValue('cancel');
  String get save => _getValue('save');
  String get delete => _getValue('delete');
  String get edit => _getValue('edit');
  String get loading => _getValue('loading');
  String get error => _getValue('error');
  String get success => _getValue('success');
  String get yes => _getValue('yes');
  String get no => _getValue('no');

  // Navigasyon
  String get dashboard => _getValue('dashboard');
  String get transactions => _getValue('transactions');
  String get history => _getValue('history');
  String get goals => _getValue('goals');
  String get categories => _getValue('categories');
  String get profile => _getValue('profile');
  String get settings => _getValue('settings');

  // Finansal
  String get income => _getValue('income');
  String get expense => _getValue('expense');
  String get amount => _getValue('amount');
  String get balance => _getValue('balance');
  String get total => _getValue('total');
  String get budget => _getValue('budget');
  String get goal => _getValue('goal');
  String get target => _getValue('target');
  String get progress => _getValue('progress');

  // Tarih ve Zaman
  String get today => _getValue('today');
  String get yesterday => _getValue('yesterday');
  String get thisWeek => _getValue('this_week');
  String get thisMonth => _getValue('this_month');
  String get thisYear => _getValue('this_year');

  // Form Alanları
  String get email => _getValue('email');
  String get password => _getValue('password');
  String get phone => _getValue('phone');
  String get name => _getValue('name');
  String get description => _getValue('description');
  String get title => _getValue('title');
  String get category => _getValue('category');
  String get date => _getValue('date');

  // Ayarlar
  String get language => _getValue('language');
  String get currency => _getValue('currency');
  String get theme => _getValue('theme');
  String get notifications => _getValue('notifications');
  String get security => _getValue('security');
  String get privacy => _getValue('privacy');
  String get helpCenter => _getValue('help_center');
  String get feedback => _getValue('feedback');
  String get logout => _getValue('logout');

  // Dil isimleri
  String get turkish => _getValue('turkish');
  String get english => _getValue('english');
  String get german => _getValue('german');
  String get french => _getValue('french');
  String get spanish => _getValue('spanish');
  String get arabic => _getValue('arabic');

  String _getValue(String key) {
    final Map<String, Map<String, String>> localizedValues = {
      'tr': _turkishValues,
      'en': _englishValues,
      'de': _germanValues,
      'fr': _frenchValues,
      'es': _spanishValues,
      'ar': _arabicValues,
    };

    return localizedValues[locale.languageCode]?[key] ?? key;
  }

  static const Map<String, String> _turkishValues = {
    'app_name': 'Finora',
    'welcome': 'Hoş Geldiniz',
    'continue': 'Devam Et',
    'cancel': 'İptal',
    'save': 'Kaydet',
    'delete': 'Sil',
    'edit': 'Düzenle',
    'loading': 'Yükleniyor...',
    'error': 'Hata',
    'success': 'Başarılı',
    'yes': 'Evet',
    'no': 'Hayır',
    
    'dashboard': 'Ana Sayfa',
    'transactions': 'İşlemler',
    'history': 'Geçmiş',
    'goals': 'Hedefler',
    'categories': 'Kategoriler',
    'profile': 'Profil',
    'settings': 'Ayarlar',
    
    'income': 'Gelir',
    'expense': 'Gider',
    'amount': 'Tutar',
    'balance': 'Bakiye',
    'total': 'Toplam',
    'budget': 'Bütçe',
    'goal': 'Hedef',
    'target': 'Hedef',
    'progress': 'İlerleme',
    
    'today': 'Bugün',
    'yesterday': 'Dün',
    'this_week': 'Bu Hafta',
    'this_month': 'Bu Ay',
    'this_year': 'Bu Yıl',
    
    'email': 'E-posta',
    'password': 'Şifre',
    'phone': 'Telefon',
    'name': 'İsim',
    'description': 'Açıklama',
    'title': 'Başlık',
    'category': 'Kategori',
    'date': 'Tarih',
    
    'language': 'Dil',
    'currency': 'Para Birimi',
    'theme': 'Tema',
    'notifications': 'Bildirimler',
    'security': 'Güvenlik',
    'privacy': 'Gizlilik',
    'help_center': 'Yardım Merkezi',
    'feedback': 'Geri Bildirim',
    'logout': 'Çıkış Yap',
    
    'turkish': 'Türkçe',
    'english': 'İngilizce',
    'german': 'Almanca',
    'french': 'Fransızca',
    'spanish': 'İspanyolca',
    'arabic': 'Arapça',
  };

  static const Map<String, String> _englishValues = {
    'app_name': 'Finora',
    'welcome': 'Welcome',
    'continue': 'Continue',
    'cancel': 'Cancel',
    'save': 'Save',
    'delete': 'Delete',
    'edit': 'Edit',
    'loading': 'Loading...',
    'error': 'Error',
    'success': 'Success',
    'yes': 'Yes',
    'no': 'No',
    
    'dashboard': 'Dashboard',
    'transactions': 'Transactions',
    'history': 'History',
    'goals': 'Goals',
    'categories': 'Categories',
    'profile': 'Profile',
    'settings': 'Settings',
    
    'income': 'Income',
    'expense': 'Expense',
    'amount': 'Amount',
    'balance': 'Balance',
    'total': 'Total',
    'budget': 'Budget',
    'goal': 'Goal',
    'target': 'Target',
    'progress': 'Progress',
    
    'today': 'Today',
    'yesterday': 'Yesterday',
    'this_week': 'This Week',
    'this_month': 'This Month',
    'this_year': 'This Year',
    
    'email': 'Email',
    'password': 'Password',
    'phone': 'Phone',
    'name': 'Name',
    'description': 'Description',
    'title': 'Title',
    'category': 'Category',
    'date': 'Date',
    
    'language': 'Language',
    'currency': 'Currency',
    'theme': 'Theme',
    'notifications': 'Notifications',
    'security': 'Security',
    'privacy': 'Privacy',
    'help_center': 'Help Center',
    'feedback': 'Feedback',
    'logout': 'Logout',
    
    'turkish': 'Turkish',
    'english': 'English',
    'german': 'German',
    'french': 'French',
    'spanish': 'Spanish',
    'arabic': 'Arabic',
  };

  static const Map<String, String> _germanValues = {
    'app_name': 'Finora',
    'welcome': 'Willkommen',
    'continue': 'Weiter',
    'cancel': 'Abbrechen',
    'save': 'Speichern',
    'delete': 'Löschen',
    'edit': 'Bearbeiten',
    'loading': 'Wird geladen...',
    'error': 'Fehler',
    'success': 'Erfolgreich',
    'yes': 'Ja',
    'no': 'Nein',
    
    'dashboard': 'Dashboard',
    'transactions': 'Transaktionen',
    'history': 'Verlauf',
    'goals': 'Ziele',
    'categories': 'Kategorien',
    'profile': 'Profil',
    'settings': 'Einstellungen',
    
    'income': 'Einkommen',
    'expense': 'Ausgabe',
    'amount': 'Betrag',
    'balance': 'Saldo',
    'total': 'Gesamt',
    'budget': 'Budget',
    'goal': 'Ziel',
    'target': 'Ziel',
    'progress': 'Fortschritt',
    
    'today': 'Heute',
    'yesterday': 'Gestern',
    'this_week': 'Diese Woche',
    'this_month': 'Dieser Monat',
    'this_year': 'Dieses Jahr',
    
    'email': 'E-Mail',
    'password': 'Passwort',
    'phone': 'Telefon',
    'name': 'Name',
    'description': 'Beschreibung',
    'title': 'Titel',
    'category': 'Kategorie',
    'date': 'Datum',
    
    'language': 'Sprache',
    'currency': 'Währung',
    'theme': 'Thema',
    'notifications': 'Benachrichtigungen',
    'security': 'Sicherheit',
    'privacy': 'Datenschutz',
    'help_center': 'Hilfe-Center',
    'feedback': 'Feedback',
    'logout': 'Abmelden',
    
    'turkish': 'Türkisch',
    'english': 'Englisch',
    'german': 'Deutsch',
    'french': 'Französisch',
    'spanish': 'Spanisch',
    'arabic': 'Arabisch',
  };

  static const Map<String, String> _frenchValues = {
    'app_name': 'Finora',
    'welcome': 'Bienvenue',
    'continue': 'Continuer',
    'cancel': 'Annuler',
    'save': 'Enregistrer',
    'delete': 'Supprimer',
    'edit': 'Modifier',
    'loading': 'Chargement...',
    'error': 'Erreur',
    'success': 'Succès',
    'yes': 'Oui',
    'no': 'Non',
    
    'dashboard': 'Tableau de bord',
    'transactions': 'Transactions',
    'history': 'Historique',
    'goals': 'Objectifs',
    'categories': 'Catégories',
    'profile': 'Profil',
    'settings': 'Paramètres',
    
    'income': 'Revenus',
    'expense': 'Dépense',
    'amount': 'Montant',
    'balance': 'Solde',
    'total': 'Total',
    'budget': 'Budget',
    'goal': 'Objectif',
    'target': 'Cible',
    'progress': 'Progrès',
    
    'today': "Aujourd'hui",
    'yesterday': 'Hier',
    'this_week': 'Cette semaine',
    'this_month': 'Ce mois',
    'this_year': 'Cette année',
    
    'email': 'Email',
    'password': 'Mot de passe',
    'phone': 'Téléphone',
    'name': 'Nom',
    'description': 'Description',
    'title': 'Titre',
    'category': 'Catégorie',
    'date': 'Date',
    
    'language': 'Langue',
    'currency': 'Devise',
    'theme': 'Thème',
    'notifications': 'Notifications',
    'security': 'Sécurité',
    'privacy': 'Confidentialité',
    'help_center': "Centre d'aide",
    'feedback': 'Commentaires',
    'logout': 'Se déconnecter',
    
    'turkish': 'Turc',
    'english': 'Anglais',
    'german': 'Allemand',
    'french': 'Français',
    'spanish': 'Espagnol',
    'arabic': 'Arabe',
  };

  static const Map<String, String> _spanishValues = {
    'app_name': 'Finora',
    'welcome': 'Bienvenido',
    'continue': 'Continuar',
    'cancel': 'Cancelar',
    'save': 'Guardar',
    'delete': 'Eliminar',
    'edit': 'Editar',
    'loading': 'Cargando...',
    'error': 'Error',
    'success': 'Éxito',
    'yes': 'Sí',
    'no': 'No',
    
    'dashboard': 'Panel',
    'transactions': 'Transacciones',
    'history': 'Historial',
    'goals': 'Objetivos',
    'categories': 'Categorías',
    'profile': 'Perfil',
    'settings': 'Configuración',
    
    'income': 'Ingresos',
    'expense': 'Gasto',
    'amount': 'Cantidad',
    'balance': 'Saldo',
    'total': 'Total',
    'budget': 'Presupuesto',
    'goal': 'Objetivo',
    'target': 'Meta',
    'progress': 'Progreso',
    
    'today': 'Hoy',
    'yesterday': 'Ayer',
    'this_week': 'Esta semana',
    'this_month': 'Este mes',
    'this_year': 'Este año',
    
    'email': 'Correo',
    'password': 'Contraseña',
    'phone': 'Teléfono',
    'name': 'Nombre',
    'description': 'Descripción',
    'title': 'Título',
    'category': 'Categoría',
    'date': 'Fecha',
    
    'language': 'Idioma',
    'currency': 'Moneda',
    'theme': 'Tema',
    'notifications': 'Notificaciones',
    'security': 'Seguridad',
    'privacy': 'Privacidad',
    'help_center': 'Centro de ayuda',
    'feedback': 'Comentarios',
    'logout': 'Cerrar sesión',
    
    'turkish': 'Turco',
    'english': 'Inglés',
    'german': 'Alemán',
    'french': 'Francés',
    'spanish': 'Español',
    'arabic': 'Árabe',
  };

  static const Map<String, String> _arabicValues = {
    'app_name': 'فينورا',
    'welcome': 'مرحباً',
    'continue': 'متابعة',
    'cancel': 'إلغاء',
    'save': 'حفظ',
    'delete': 'حذف',
    'edit': 'تعديل',
    'loading': 'جارٍ التحميل...',
    'error': 'خطأ',
    'success': 'نجح',
    'yes': 'نعم',
    'no': 'لا',
    
    'dashboard': 'لوحة التحكم',
    'transactions': 'المعاملات',
    'history': 'التاريخ',
    'goals': 'الأهداف',
    'categories': 'الفئات',
    'profile': 'الملف الشخصي',
    'settings': 'الإعدادات',
    
    'income': 'الدخل',
    'expense': 'المصروف',
    'amount': 'المبلغ',
    'balance': 'الرصيد',
    'total': 'المجموع',
    'budget': 'الميزانية',
    'goal': 'الهدف',
    'target': 'الهدف',
    'progress': 'التقدم',
    
    'today': 'اليوم',
    'yesterday': 'أمس',
    'this_week': 'هذا الأسبوع',
    'this_month': 'هذا الشهر',
    'this_year': 'هذا العام',
    
    'email': 'البريد الإلكتروني',
    'password': 'كلمة المرور',
    'phone': 'الهاتف',
    'name': 'الاسم',
    'description': 'الوصف',
    'title': 'العنوان',
    'category': 'الفئة',
    'date': 'التاريخ',
    
    'language': 'اللغة',
    'currency': 'العملة',
    'theme': 'السمة',
    'notifications': 'الإشعارات',
    'security': 'الأمان',
    'privacy': 'الخصوصية',
    'help_center': 'مركز المساعدة',
    'feedback': 'التعليقات',
    'logout': 'تسجيل الخروج',
    
    'turkish': 'التركية',
    'english': 'الإنجليزية',
    'german': 'الألمانية',
    'french': 'الفرنسية',
    'spanish': 'الإسبانية',
    'arabic': 'العربية',
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((supportedLocale) => supportedLocale.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}