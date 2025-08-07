import 'package:intl/intl.dart';

class Currency {
  final String code;
  final String name;
  final String symbol;
  final String flag;
  final int decimalPlaces;
  final bool symbolAtStart;

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
    this.decimalPlaces = 2,
    this.symbolAtStart = true,
  });
}

class CurrencyService {
  static const Currency _defaultCurrency = Currency(
    code: 'TRY',
    name: 'Türk Lirası',
    symbol: '₺',
    flag: '🇹🇷',
  );

  static Currency _currentCurrency = _defaultCurrency;

  static const List<Currency> supportedCurrencies = [
    Currency(
      code: 'TRY',
      name: 'Türk Lirası',
      symbol: '₺',
      flag: '🇹🇷',
    ),
    Currency(
      code: 'USD',
      name: 'US Dollar',
      symbol: '\$',
      flag: '🇺🇸',
    ),
    Currency(
      code: 'EUR',
      name: 'Euro',
      symbol: '€',
      flag: '🇪🇺',
    ),
    Currency(
      code: 'GBP',
      name: 'British Pound',
      symbol: '£',
      flag: '🇬🇧',
    ),
    Currency(
      code: 'JPY',
      name: 'Japanese Yen',
      symbol: '¥',
      flag: '🇯🇵',
      decimalPlaces: 0,
    ),
    Currency(
      code: 'CHF',
      name: 'Swiss Franc',
      symbol: 'CHF',
      flag: '🇨🇭',
      symbolAtStart: false,
    ),
    Currency(
      code: 'CAD',
      name: 'Canadian Dollar',
      symbol: 'C\$',
      flag: '🇨🇦',
    ),
    Currency(
      code: 'AUD',
      name: 'Australian Dollar',
      symbol: 'A\$',
      flag: '🇦🇺',
    ),
    Currency(
      code: 'CNY',
      name: 'Chinese Yuan',
      symbol: '¥',
      flag: '🇨🇳',
    ),
    Currency(
      code: 'INR',
      name: 'Indian Rupee',
      symbol: '₹',
      flag: '🇮🇳',
    ),
    Currency(
      code: 'KRW',
      name: 'South Korean Won',
      symbol: '₩',
      flag: '🇰🇷',
      decimalPlaces: 0,
    ),
    Currency(
      code: 'RUB',
      name: 'Russian Ruble',
      symbol: '₽',
      flag: '🇷🇺',
    ),
    Currency(
      code: 'BRL',
      name: 'Brazilian Real',
      symbol: 'R\$',
      flag: '🇧🇷',
    ),
    Currency(
      code: 'MXN',
      name: 'Mexican Peso',
      symbol: 'MX\$',
      flag: '🇲🇽',
    ),
    Currency(
      code: 'AED',
      name: 'UAE Dirham',
      symbol: 'د.إ',
      flag: '🇦🇪',
    ),
    Currency(
      code: 'SAR',
      name: 'Saudi Riyal',
      symbol: 'ر.س',
      flag: '🇸🇦',
    ),
    Currency(
      code: 'EGP',
      name: 'Egyptian Pound',
      symbol: 'ج.م',
      flag: '🇪🇬',
    ),
  ];

  // Exchange rates (mock data - in real app, fetch from API)
  static const Map<String, double> _exchangeRates = {
    'TRY': 1.0,
    'USD': 0.034,
    'EUR': 0.031,
    'GBP': 0.027,
    'JPY': 4.8,
    'CHF': 0.031,
    'CAD': 0.046,
    'AUD': 0.051,
    'CNY': 0.24,
    'INR': 2.83,
    'KRW': 44.2,
    'RUB': 3.1,
    'BRL': 0.17,
    'MXN': 0.58,
    'AED': 0.125,
    'SAR': 0.128,
    'EGP': 1.67,
  };

  static Currency get currentCurrency => _currentCurrency;

  static void setCurrency(Currency currency) {
    _currentCurrency = currency;
  }

  static Currency? getCurrencyByCode(String code) {
    try {
      return supportedCurrencies.firstWhere((currency) => currency.code == code);
    } catch (e) {
      return null;
    }
  }

  static String formatAmount(double amount, {Currency? currency}) {
    final curr = currency ?? _currentCurrency;
    final formatter = NumberFormat.currency(
      locale: _getLocaleForCurrency(curr),
      symbol: '',
      decimalDigits: curr.decimalPlaces,
    );

    final formattedNumber = formatter.format(amount);
    
    if (curr.symbolAtStart) {
      return '${curr.symbol}$formattedNumber';
    } else {
      return '$formattedNumber ${curr.symbol}';
    }
  }

  static String formatAmountWithCode(double amount, {Currency? currency}) {
    final curr = currency ?? _currentCurrency;
    final formattedAmount = formatAmount(amount, currency: curr);
    return '$formattedAmount ${curr.code}';
  }

  static double convertAmount(double amount, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return amount;
    
    final fromRate = _exchangeRates[fromCurrency] ?? 1.0;
    final toRate = _exchangeRates[toCurrency] ?? 1.0;
    
    // Convert to TRY first, then to target currency
    final amountInTRY = amount / fromRate;
    return amountInTRY * toRate;
  }

  static String _getLocaleForCurrency(Currency currency) {
    switch (currency.code) {
      case 'TRY':
        return 'tr_TR';
      case 'USD':
      case 'CAD':
      case 'AUD':
      case 'MXN':
        return 'en_US';
      case 'EUR':
        return 'de_DE';
      case 'GBP':
        return 'en_GB';
      case 'JPY':
        return 'ja_JP';
      case 'CHF':
        return 'de_CH';
      case 'CNY':
        return 'zh_CN';
      case 'INR':
        return 'en_IN';
      case 'KRW':
        return 'ko_KR';
      case 'RUB':
        return 'ru_RU';
      case 'BRL':
        return 'pt_BR';
      case 'AED':
      case 'SAR':
      case 'EGP':
        return 'ar_SA';
      default:
        return 'en_US';
    }
  }

  static List<Currency> getCurrenciesForLanguage(String languageCode) {
    switch (languageCode) {
      case 'tr':
        return [
          getCurrencyByCode('TRY')!,
          getCurrencyByCode('USD')!,
          getCurrencyByCode('EUR')!,
          getCurrencyByCode('GBP')!,
        ];
      case 'en':
        return [
          getCurrencyByCode('USD')!,
          getCurrencyByCode('GBP')!,
          getCurrencyByCode('EUR')!,
          getCurrencyByCode('CAD')!,
          getCurrencyByCode('AUD')!,
        ];
      case 'de':
        return [
          getCurrencyByCode('EUR')!,
          getCurrencyByCode('CHF')!,
          getCurrencyByCode('USD')!,
        ];
      case 'fr':
        return [
          getCurrencyByCode('EUR')!,
          getCurrencyByCode('CHF')!,
          getCurrencyByCode('USD')!,
        ];
      case 'es':
        return [
          getCurrencyByCode('EUR')!,
          getCurrencyByCode('MXN')!,
          getCurrencyByCode('USD')!,
        ];
      case 'ar':
        return [
          getCurrencyByCode('AED')!,
          getCurrencyByCode('SAR')!,
          getCurrencyByCode('EGP')!,
          getCurrencyByCode('USD')!,
        ];
      default:
        return supportedCurrencies.take(5).toList();
    }
  }

  static String getCurrencyName(String currencyCode, String languageCode) {
    final currencyNames = {
      'tr': {
        'TRY': 'Türk Lirası',
        'USD': 'Amerikan Doları',
        'EUR': 'Avro',
        'GBP': 'İngiliz Sterlini',
        'JPY': 'Japon Yeni',
        'CHF': 'İsviçre Frangı',
        'CAD': 'Kanada Doları',
        'AUD': 'Avustralya Doları',
        'CNY': 'Çin Yuanı',
        'INR': 'Hint Rupisi',
        'KRW': 'Güney Kore Wonu',
        'RUB': 'Rus Rublesi',
        'BRL': 'Brezilya Reali',
        'MXN': 'Meksika Pesosu',
        'AED': 'BAE Dirhemi',
        'SAR': 'Suudi Riyali',
        'EGP': 'Mısır Poundu',
      },
      'en': {
        'TRY': 'Turkish Lira',
        'USD': 'US Dollar',
        'EUR': 'Euro',
        'GBP': 'British Pound',
        'JPY': 'Japanese Yen',
        'CHF': 'Swiss Franc',
        'CAD': 'Canadian Dollar',
        'AUD': 'Australian Dollar',
        'CNY': 'Chinese Yuan',
        'INR': 'Indian Rupee',
        'KRW': 'South Korean Won',
        'RUB': 'Russian Ruble',
        'BRL': 'Brazilian Real',
        'MXN': 'Mexican Peso',
        'AED': 'UAE Dirham',
        'SAR': 'Saudi Riyal',
        'EGP': 'Egyptian Pound',
      },
      'de': {
        'TRY': 'Türkische Lira',
        'USD': 'US-Dollar',
        'EUR': 'Euro',
        'GBP': 'Britisches Pfund',
        'JPY': 'Japanischer Yen',
        'CHF': 'Schweizer Franken',
        'CAD': 'Kanadischer Dollar',
        'AUD': 'Australischer Dollar',
        'CNY': 'Chinesischer Yuan',
        'INR': 'Indische Rupie',
        'KRW': 'Südkoreanischer Won',
        'RUB': 'Russischer Rubel',
        'BRL': 'Brasilianischer Real',
        'MXN': 'Mexikanischer Peso',
        'AED': 'VAE-Dirham',
        'SAR': 'Saudi-Riyal',
        'EGP': 'Ägyptisches Pfund',
      },
      'fr': {
        'TRY': 'Livre turque',
        'USD': 'Dollar américain',
        'EUR': 'Euro',
        'GBP': 'Livre sterling',
        'JPY': 'Yen japonais',
        'CHF': 'Franc suisse',
        'CAD': 'Dollar canadien',
        'AUD': 'Dollar australien',
        'CNY': 'Yuan chinois',
        'INR': 'Roupie indienne',
        'KRW': 'Won sud-coréen',
        'RUB': 'Rouble russe',
        'BRL': 'Réal brésilien',
        'MXN': 'Peso mexicain',
        'AED': 'Dirham des EAU',
        'SAR': 'Riyal saoudien',
        'EGP': 'Livre égyptienne',
      },
      'es': {
        'TRY': 'Lira turca',
        'USD': 'Dólar estadounidense',
        'EUR': 'Euro',
        'GBP': 'Libra esterlina',
        'JPY': 'Yen japonés',
        'CHF': 'Franco suizo',
        'CAD': 'Dólar canadiense',
        'AUD': 'Dólar australiano',
        'CNY': 'Yuan chino',
        'INR': 'Rupia india',
        'KRW': 'Won surcoreano',
        'RUB': 'Rublo ruso',
        'BRL': 'Real brasileño',
        'MXN': 'Peso mexicano',
        'AED': 'Dirham de EAU',
        'SAR': 'Riyal saudí',
        'EGP': 'Libra egipcia',
      },
      'ar': {
        'TRY': 'الليرة التركية',
        'USD': 'الدولار الأمريكي',
        'EUR': 'اليورو',
        'GBP': 'الجنيه الإسترليني',
        'JPY': 'الين الياباني',
        'CHF': 'الفرنك السويسري',
        'CAD': 'الدولار الكندي',
        'AUD': 'الدولار الأسترالي',
        'CNY': 'اليوان الصيني',
        'INR': 'الروبية الهندية',
        'KRW': 'الوون الكوري الجنوبي',
        'RUB': 'الروبل الروسي',
        'BRL': 'الريال البرازيلي',
        'MXN': 'البيزو المكسيكي',
        'AED': 'درهم الإمارات',
        'SAR': 'الريال السعودي',
        'EGP': 'الجنيه المصري',
      },
    };

    return currencyNames[languageCode]?[currencyCode] ?? 
           getCurrencyByCode(currencyCode)?.name ?? 
           currencyCode;
  }
}