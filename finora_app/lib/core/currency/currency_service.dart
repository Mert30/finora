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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => '$code ($symbol)';

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'symbol': symbol,
        'flag': flag,
        'decimalPlaces': decimalPlaces,
        'symbolAtStart': symbolAtStart,
      };

  static Currency fromJson(Map<String, dynamic> json) => Currency(
        code: json['code'],
        name: json['name'],
        symbol: json['symbol'],
        flag: json['flag'],
        decimalPlaces: json['decimalPlaces'] ?? 2,
        symbolAtStart: json['symbolAtStart'] ?? true,
      );
}

class CurrencyService {
  static Currency _currentCurrency = const Currency(
    code: 'TRY',
    name: 'Turkish Lira',
    symbol: '₺',
    flag: '🇹🇷',
    decimalPlaces: 2,
    symbolAtStart: false,
  );

  static Currency get currentCurrency => _currentCurrency;

  static const List<Currency> supportedCurrencies = [
    // Turkish Lira
    Currency(
      code: 'TRY',
      name: 'Turkish Lira',
      symbol: '₺',
      flag: '🇹🇷',
      decimalPlaces: 2,
      symbolAtStart: false,
    ),
    
    // US Dollar
    Currency(
      code: 'USD',
      name: 'US Dollar',
      symbol: '\$',
      flag: '🇺🇸',
      decimalPlaces: 2,
      symbolAtStart: true,
    ),
    
    // Euro
    Currency(
      code: 'EUR',
      name: 'Euro',
      symbol: '€',
      flag: '🇪🇺',
      decimalPlaces: 2,
      symbolAtStart: false,
    ),
    
    // British Pound
    Currency(
      code: 'GBP',
      name: 'British Pound',
      symbol: '£',
      flag: '🇬🇧',
      decimalPlaces: 2,
      symbolAtStart: true,
    ),
    
    // Japanese Yen
    Currency(
      code: 'JPY',
      name: 'Japanese Yen',
      symbol: '¥',
      flag: '🇯🇵',
      decimalPlaces: 0,
      symbolAtStart: true,
    ),
    
    // Swiss Franc
    Currency(
      code: 'CHF',
      name: 'Swiss Franc',
      symbol: 'Fr',
      flag: '🇨🇭',
      decimalPlaces: 2,
      symbolAtStart: false,
    ),
    
    // Canadian Dollar
    Currency(
      code: 'CAD',
      name: 'Canadian Dollar',
      symbol: 'C\$',
      flag: '🇨🇦',
      decimalPlaces: 2,
      symbolAtStart: true,
    ),
    
    // Australian Dollar
    Currency(
      code: 'AUD',
      name: 'Australian Dollar',
      symbol: 'A\$',
      flag: '🇦🇺',
      decimalPlaces: 2,
      symbolAtStart: true,
    ),
    
    // Chinese Yuan
    Currency(
      code: 'CNY',
      name: 'Chinese Yuan',
      symbol: '¥',
      flag: '🇨🇳',
      decimalPlaces: 2,
      symbolAtStart: true,
    ),
    
    // Indian Rupee
    Currency(
      code: 'INR',
      name: 'Indian Rupee',
      symbol: '₹',
      flag: '🇮🇳',
      decimalPlaces: 2,
      symbolAtStart: true,
    ),
    
    // Russian Ruble
    Currency(
      code: 'RUB',
      name: 'Russian Ruble',
      symbol: '₽',
      flag: '🇷🇺',
      decimalPlaces: 2,
      symbolAtStart: false,
    ),
    
    // Korean Won
    Currency(
      code: 'KRW',
      name: 'Korean Won',
      symbol: '₩',
      flag: '🇰🇷',
      decimalPlaces: 0,
      symbolAtStart: true,
    ),
    
    // Brazilian Real
    Currency(
      code: 'BRL',
      name: 'Brazilian Real',
      symbol: 'R\$',
      flag: '🇧🇷',
      decimalPlaces: 2,
      symbolAtStart: true,
    ),
    
    // Mexican Peso
    Currency(
      code: 'MXN',
      name: 'Mexican Peso',
      symbol: '\$',
      flag: '🇲🇽',
      decimalPlaces: 2,
      symbolAtStart: true,
    ),
    
    // South African Rand
    Currency(
      code: 'ZAR',
      name: 'South African Rand',
      symbol: 'R',
      flag: '🇿🇦',
      decimalPlaces: 2,
      symbolAtStart: true,
    ),
    
    // Saudi Riyal
    Currency(
      code: 'SAR',
      name: 'Saudi Riyal',
      symbol: '﷼',
      flag: '🇸🇦',
      decimalPlaces: 2,
      symbolAtStart: false,
    ),
    
    // UAE Dirham
    Currency(
      code: 'AED',
      name: 'UAE Dirham',
      symbol: 'د.إ',
      flag: '🇦🇪',
      decimalPlaces: 2,
      symbolAtStart: false,
    ),
  ];

  // Mock exchange rates for demonstration
  static const Map<String, double> _exchangeRates = {
    'TRY': 1.0,      // Base currency
    'USD': 0.037,    // 1 TRY = 0.037 USD
    'EUR': 0.034,    // 1 TRY = 0.034 EUR
    'GBP': 0.029,    // 1 TRY = 0.029 GBP
    'JPY': 5.42,     // 1 TRY = 5.42 JPY
    'CHF': 0.033,    // 1 TRY = 0.033 CHF
    'CAD': 0.051,    // 1 TRY = 0.051 CAD
    'AUD': 0.057,    // 1 TRY = 0.057 AUD
    'CNY': 0.269,    // 1 TRY = 0.269 CNY
    'INR': 3.09,     // 1 TRY = 3.09 INR
    'RUB': 3.42,     // 1 TRY = 3.42 RUB
    'KRW': 49.8,     // 1 TRY = 49.8 KRW
    'BRL': 0.189,    // 1 TRY = 0.189 BRL
    'MXN': 0.751,    // 1 TRY = 0.751 MXN
    'ZAR': 0.675,    // 1 TRY = 0.675 ZAR
    'SAR': 0.139,    // 1 TRY = 0.139 SAR
    'AED': 0.136,    // 1 TRY = 0.136 AED
  };

  /// Set the current currency
  static void setCurrency(Currency currency) {
    _currentCurrency = currency;
    // TODO: Save to SharedPreferences
  }

  /// Get currency by code
  static Currency? getCurrencyByCode(String code) {
    try {
      return supportedCurrencies.firstWhere(
        (currency) => currency.code.toUpperCase() == code.toUpperCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Format amount with current currency
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

  /// Format amount with currency code
  static String formatAmountWithCode(double amount, {Currency? currency}) {
    final curr = currency ?? _currentCurrency;
    final formattedAmount = formatAmount(amount, currency: curr);
    return '$formattedAmount ${curr.code}';
  }

  /// Convert amount between currencies
  static double convertAmount(
    double amount,
    Currency fromCurrency,
    Currency toCurrency,
  ) {
    if (fromCurrency.code == toCurrency.code) return amount;

    // Convert to base currency (TRY) first
    final baseAmount = amount / (_exchangeRates[fromCurrency.code] ?? 1.0);
    
    // Convert from base to target currency
    final targetRate = _exchangeRates[toCurrency.code] ?? 1.0;
    return baseAmount * targetRate;
  }

  /// Get exchange rate between two currencies
  static double getExchangeRate(Currency fromCurrency, Currency toCurrency) {
    if (fromCurrency.code == toCurrency.code) return 1.0;
    
    final fromRate = _exchangeRates[fromCurrency.code] ?? 1.0;
    final toRate = _exchangeRates[toCurrency.code] ?? 1.0;
    
    return toRate / fromRate;
  }

  /// Get locale string for currency formatting
  static String _getLocaleForCurrency(Currency currency) {
    switch (currency.code) {
      case 'TRY':
        return 'tr_TR';
      case 'USD':
      case 'CAD':
      case 'MXN':
        return 'en_US';
      case 'EUR':
        return 'en_EU';
      case 'GBP':
        return 'en_GB';
      case 'JPY':
        return 'ja_JP';
      case 'CHF':
        return 'de_CH';
      case 'AUD':
        return 'en_AU';
      case 'CNY':
        return 'zh_CN';
      case 'INR':
        return 'hi_IN';
      case 'RUB':
        return 'ru_RU';
      case 'KRW':
        return 'ko_KR';
      case 'BRL':
        return 'pt_BR';
      case 'ZAR':
        return 'en_ZA';
      case 'SAR':
      case 'AED':
        return 'ar_SA';
      default:
        return 'en_US';
    }
  }

  /// Get currencies recommended for a specific language
  static List<Currency> getCurrenciesForLanguage(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'tr':
        return [
          getCurrencyByCode('TRY')!,
          getCurrencyByCode('USD')!,
          getCurrencyByCode('EUR')!,
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
          getCurrencyByCode('CAD')!,
        ];
      case 'es':
        return [
          getCurrencyByCode('EUR')!,
          getCurrencyByCode('MXN')!,
          getCurrencyByCode('USD')!,
        ];
      case 'ar':
        return [
          getCurrencyByCode('SAR')!,
          getCurrencyByCode('AED')!,
          getCurrencyByCode('USD')!,
        ];
      default:
        return [
          getCurrencyByCode('USD')!,
          getCurrencyByCode('EUR')!,
          getCurrencyByCode('GBP')!,
        ];
    }
  }

  /// Get localized currency name
  static String getCurrencyName(Currency currency, String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'tr':
        return _getTurkishCurrencyName(currency);
      case 'de':
        return _getGermanCurrencyName(currency);
      case 'fr':
        return _getFrenchCurrencyName(currency);
      case 'es':
        return _getSpanishCurrencyName(currency);
      case 'ar':
        return _getArabicCurrencyName(currency);
      default:
        return currency.name; // English is default
    }
  }

  static String _getTurkishCurrencyName(Currency currency) {
    switch (currency.code) {
      case 'TRY':
        return 'Türk Lirası';
      case 'USD':
        return 'Amerikan Doları';
      case 'EUR':
        return 'Euro';
      case 'GBP':
        return 'İngiliz Sterlini';
      case 'JPY':
        return 'Japon Yeni';
      case 'CHF':
        return 'İsviçre Frangı';
      case 'CAD':
        return 'Kanada Doları';
      case 'AUD':
        return 'Avustralya Doları';
      case 'CNY':
        return 'Çin Yuanı';
      case 'INR':
        return 'Hindistan Rupisi';
      case 'RUB':
        return 'Rus Rublesi';
      case 'KRW':
        return 'Güney Kore Wonu';
      case 'BRL':
        return 'Brezilya Reali';
      case 'MXN':
        return 'Meksika Pesosu';
      case 'ZAR':
        return 'Güney Afrika Randı';
      case 'SAR':
        return 'Suudi Arabistan Riyali';
      case 'AED':
        return 'BAE Dirhemi';
      default:
        return currency.name;
    }
  }

  static String _getGermanCurrencyName(Currency currency) {
    switch (currency.code) {
      case 'TRY':
        return 'Türkische Lira';
      case 'USD':
        return 'US-Dollar';
      case 'EUR':
        return 'Euro';
      case 'GBP':
        return 'Britisches Pfund';
      case 'JPY':
        return 'Japanischer Yen';
      case 'CHF':
        return 'Schweizer Franken';
      case 'CAD':
        return 'Kanadischer Dollar';
      case 'AUD':
        return 'Australischer Dollar';
      case 'CNY':
        return 'Chinesischer Yuan';
      case 'INR':
        return 'Indische Rupie';
      case 'RUB':
        return 'Russischer Rubel';
      case 'KRW':
        return 'Südkoreanischer Won';
      case 'BRL':
        return 'Brasilianischer Real';
      case 'MXN':
        return 'Mexikanischer Peso';
      case 'ZAR':
        return 'Südafrikanischer Rand';
      case 'SAR':
        return 'Saudi-Riyal';
      case 'AED':
        return 'VAE-Dirham';
      default:
        return currency.name;
    }
  }

  static String _getFrenchCurrencyName(Currency currency) {
    switch (currency.code) {
      case 'TRY':
        return 'Livre turque';
      case 'USD':
        return 'Dollar américain';
      case 'EUR':
        return 'Euro';
      case 'GBP':
        return 'Livre sterling';
      case 'JPY':
        return 'Yen japonais';
      case 'CHF':
        return 'Franc suisse';
      case 'CAD':
        return 'Dollar canadien';
      case 'AUD':
        return 'Dollar australien';
      case 'CNY':
        return 'Yuan chinois';
      case 'INR':
        return 'Roupie indienne';
      case 'RUB':
        return 'Rouble russe';
      case 'KRW':
        return 'Won sud-coréen';
      case 'BRL':
        return 'Real brésilien';
      case 'MXN':
        return 'Peso mexicain';
      case 'ZAR':
        return 'Rand sud-africain';
      case 'SAR':
        return 'Riyal saoudien';
      case 'AED':
        return 'Dirham des EAU';
      default:
        return currency.name;
    }
  }

  static String _getSpanishCurrencyName(Currency currency) {
    switch (currency.code) {
      case 'TRY':
        return 'Lira turca';
      case 'USD':
        return 'Dólar estadounidense';
      case 'EUR':
        return 'Euro';
      case 'GBP':
        return 'Libra esterlina';
      case 'JPY':
        return 'Yen japonés';
      case 'CHF':
        return 'Franco suizo';
      case 'CAD':
        return 'Dólar canadiense';
      case 'AUD':
        return 'Dólar australiano';
      case 'CNY':
        return 'Yuan chino';
      case 'INR':
        return 'Rupia india';
      case 'RUB':
        return 'Rublo ruso';
      case 'KRW':
        return 'Won surcoreano';
      case 'BRL':
        return 'Real brasileño';
      case 'MXN':
        return 'Peso mexicano';
      case 'ZAR':
        return 'Rand sudafricano';
      case 'SAR':
        return 'Riyal saudí';
      case 'AED':
        return 'Dirham de los EAU';
      default:
        return currency.name;
    }
  }

  static String _getArabicCurrencyName(Currency currency) {
    switch (currency.code) {
      case 'TRY':
        return 'الليرة التركية';
      case 'USD':
        return 'الدولار الأمريكي';
      case 'EUR':
        return 'اليورو';
      case 'GBP':
        return 'الجنيه الإسترليني';
      case 'JPY':
        return 'الين الياباني';
      case 'CHF':
        return 'الفرنك السويسري';
      case 'CAD':
        return 'الدولار الكندي';
      case 'AUD':
        return 'الدولار الأسترالي';
      case 'CNY':
        return 'اليوان الصيني';
      case 'INR':
        return 'الروبية الهندية';
      case 'RUB':
        return 'الروبل الروسي';
      case 'KRW':
        return 'الوون الكوري الجنوبي';
      case 'BRL':
        return 'الريال البرازيلي';
      case 'MXN':
        return 'البيزو المكسيكي';
      case 'ZAR':
        return 'الراند الجنوب أفريقي';
      case 'SAR':
        return 'الريال السعودي';
      case 'AED':
        return 'درهم الإمارات';
      default:
        return currency.name;
    }
  }

  /// Get all supported currency codes
  static List<String> get supportedCurrencyCodes =>
      supportedCurrencies.map((c) => c.code).toList();

  /// Check if currency is supported
  static bool isCurrencySupported(String code) =>
      supportedCurrencyCodes.contains(code.toUpperCase());

  /// Get popular currencies (most commonly used)
  static List<Currency> get popularCurrencies => [
        getCurrencyByCode('USD')!,
        getCurrencyByCode('EUR')!,
        getCurrencyByCode('GBP')!,
        getCurrencyByCode('JPY')!,
        getCurrencyByCode('CHF')!,
        getCurrencyByCode('CAD')!,
        getCurrencyByCode('AUD')!,
        getCurrencyByCode('TRY')!,
      ];

  /// Format amount for display without currency symbol
  static String formatAmountOnly(double amount, {Currency? currency}) {
    final curr = currency ?? _currentCurrency;
    final formatter = NumberFormat.currency(
      locale: _getLocaleForCurrency(curr),
      symbol: '',
      decimalDigits: curr.decimalPlaces,
    );

    return formatter.format(amount).trim();
  }

  /// Get compact format for large amounts (1K, 1M, etc.)
  static String formatAmountCompact(double amount, {Currency? currency}) {
    final curr = currency ?? _currentCurrency;
    final formatter = NumberFormat.compact(
      locale: _getLocaleForCurrency(curr),
    );

    final compactNumber = formatter.format(amount);
    
    if (curr.symbolAtStart) {
      return '${curr.symbol}$compactNumber';
    } else {
      return '$compactNumber ${curr.symbol}';
    }
  }
}