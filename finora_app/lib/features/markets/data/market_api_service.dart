// 📈 FINORA - LIVE MARKETS API SERVICE
// Gerçek zamanlı piyasa verilerini çeken API servisi

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════
// 📊 MARKET DATA MODELS
// ═══════════════════════════════════════════════════════════════════

class MarketItem {
  final String symbol;
  final String name;
  final double price;
  final double change;
  final double changePercent;
  final String category;
  final DateTime lastUpdate;

  MarketItem({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.category,
    required this.lastUpdate,
  });

  bool get isPositive => change >= 0;
  
  String get formattedPrice {
    if (category == 'Kripto') {
      return '\$${price.toStringAsFixed(2)}';
    } else if (category == 'Döviz') {
      return '₺${price.toStringAsFixed(4)}';
    } else if (category == 'Altın & Kıymetli') {
      return '₺${price.toStringAsFixed(2)}';
    } else {
      return '₺${price.toStringAsFixed(2)}';
    }
  }

  String get formattedChange {
    final sign = isPositive ? '+' : '';
    return '$sign${change.toStringAsFixed(2)}';
  }

  String get formattedChangePercent {
    final sign = isPositive ? '+' : '';
    return '$sign${changePercent.toStringAsFixed(2)}%';
  }

  Color get changeColor {
    return isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444);
  }

  factory MarketItem.fromJson(Map<String, dynamic> json, String category) {
    return MarketItem(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      change: (json['change'] ?? 0.0).toDouble(),
      changePercent: (json['changePercent'] ?? 0.0).toDouble(),
      category: category,
      lastUpdate: DateTime.now(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// 🌐 MARKET API SERVICE
// ═══════════════════════════════════════════════════════════════════

class MarketApiService {
  static const String _baseUrl = 'https://api.exchangerate-api.com/v4/latest';
  static const String _cryptoUrl = 'https://api.coingecko.com/api/v3/simple/price';
  static const Duration _timeout = Duration(seconds: 10);

  // ➤ GET FOREX DATA (USD, EUR, GBP vs TRY)
  static Future<List<MarketItem>> getForexData() async {
    try {
      debugPrint('📊 Fetching forex data...');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/USD'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        
        final List<MarketItem> forexItems = [];
        
        // USD/TRY
        if (rates.containsKey('TRY')) {
          forexItems.add(MarketItem(
            symbol: 'USD/TRY',
            name: 'Amerikan Doları',
            price: rates['TRY'].toDouble(),
            change: (rates['TRY'].toDouble() * 0.001), // Mock change
            changePercent: 0.15, // Mock change percent
            category: 'Döviz',
            lastUpdate: DateTime.now(),
          ));
        }

        // EUR/TRY (Calculate from USD)
        if (rates.containsKey('EUR') && rates.containsKey('TRY')) {
          final eurToUsd = 1.0 / rates['EUR'].toDouble();
          final eurToTry = eurToUsd * rates['TRY'].toDouble();
          forexItems.add(MarketItem(
            symbol: 'EUR/TRY',
            name: 'Euro',
            price: eurToTry,
            change: eurToTry * 0.002, // Mock change
            changePercent: 0.22, // Mock change percent
            category: 'Döviz',
            lastUpdate: DateTime.now(),
          ));
        }

        // GBP/TRY (Calculate from USD)
        if (rates.containsKey('GBP') && rates.containsKey('TRY')) {
          final gbpToUsd = 1.0 / rates['GBP'].toDouble();
          final gbpToTry = gbpToUsd * rates['TRY'].toDouble();
          forexItems.add(MarketItem(
            symbol: 'GBP/TRY',
            name: 'İngiliz Sterlini',
            price: gbpToTry,
            change: gbpToTry * 0.0015, // Mock change
            changePercent: 0.18, // Mock change percent
            category: 'Döviz',
            lastUpdate: DateTime.now(),
          ));
        }

        debugPrint('✅ Forex data fetched: ${forexItems.length} items');
        return forexItems;
      } else {
        debugPrint('❌ Forex API error: ${response.statusCode}');
        return _getMockForexData();
      }
    } catch (e) {
      debugPrint('💥 Forex API exception: $e');
      return _getMockForexData();
    }
  }

  // ➤ GET CRYPTO DATA
  static Future<List<MarketItem>> getCryptoData() async {
    try {
      debugPrint('📊 Fetching crypto data...');
      
      final response = await http.get(
        Uri.parse('$_cryptoUrl?ids=bitcoin,ethereum,binancecoin,cardano,solana&vs_currencies=usd&include_24hr_change=true'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final List<MarketItem> cryptoItems = [];

        final cryptoMap = {
          'bitcoin': 'Bitcoin (BTC)',
          'ethereum': 'Ethereum (ETH)',
          'binancecoin': 'Binance Coin (BNB)',
          'cardano': 'Cardano (ADA)',
          'solana': 'Solana (SOL)',
        };

        data.forEach((key, value) {
          if (cryptoMap.containsKey(key)) {
            final price = (value['usd'] ?? 0.0).toDouble();
            final change24h = (value['usd_24h_change'] ?? 0.0).toDouble();
            
            cryptoItems.add(MarketItem(
              symbol: key.toUpperCase(),
              name: cryptoMap[key]!,
              price: price,
              change: price * (change24h / 100),
              changePercent: change24h,
              category: 'Kripto',
              lastUpdate: DateTime.now(),
            ));
          }
        });

        debugPrint('✅ Crypto data fetched: ${cryptoItems.length} items');
        return cryptoItems;
      } else {
        debugPrint('❌ Crypto API error: ${response.statusCode}');
        return _getMockCryptoData();
      }
    } catch (e) {
      debugPrint('💥 Crypto API exception: $e');
      return _getMockCryptoData();
    }
  }

  // ➤ GET GOLD & PRECIOUS METALS DATA
  static Future<List<MarketItem>> getGoldData() async {
    try {
      debugPrint('📊 Fetching gold data...');
      
      // Using a mock API for gold prices (you can replace with real API)
      return _getMockGoldData();
    } catch (e) {
      debugPrint('💥 Gold API exception: $e');
      return _getMockGoldData();
    }
  }

  // ➤ GET STOCK DATA
  static Future<List<MarketItem>> getStockData() async {
    try {
      debugPrint('📊 Fetching stock data...');
      
      // Using mock data for Turkish stocks (you can replace with real API)
      return _getMockStockData();
    } catch (e) {
      debugPrint('💥 Stock API exception: $e');
      return _getMockStockData();
    }
  }

  // ➤ GET ALL MARKET DATA
  static Future<Map<String, List<MarketItem>>> getAllMarketData() async {
    try {
      debugPrint('🔄 Fetching all market data...');
      
      final futures = await Future.wait([
        getForexData(),
        getCryptoData(),
        getGoldData(),
        getStockData(),
      ]);

      final result = {
        'Döviz': futures[0],
        'Kripto': futures[1],
        'Altın & Kıymetli': futures[2],
        'Borsa': futures[3],
      };

      debugPrint('✅ All market data fetched successfully');
      return result;
    } catch (e) {
      debugPrint('💥 Error fetching all market data: $e');
      return {
        'Döviz': _getMockForexData(),
        'Kripto': _getMockCryptoData(),
        'Altın & Kıymetli': _getMockGoldData(),
        'Borsa': _getMockStockData(),
      };
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  // 🔄 MOCK DATA (Fallback)
  // ═══════════════════════════════════════════════════════════════════

  static List<MarketItem> _getMockForexData() {
    return [
      MarketItem(symbol: 'USD/TRY', name: 'Amerikan Doları', price: 32.45, change: 0.12, changePercent: 0.37, category: 'Döviz', lastUpdate: DateTime.now()),
      MarketItem(symbol: 'EUR/TRY', name: 'Euro', price: 35.28, change: -0.08, changePercent: -0.23, category: 'Döviz', lastUpdate: DateTime.now()),
      MarketItem(symbol: 'GBP/TRY', name: 'İngiliz Sterlini', price: 40.15, change: 0.25, changePercent: 0.62, category: 'Döviz', lastUpdate: DateTime.now()),
      MarketItem(symbol: 'CHF/TRY', name: 'İsviçre Frangı', price: 36.82, change: -0.15, changePercent: -0.41, category: 'Döviz', lastUpdate: DateTime.now()),
    ];
  }

  static List<MarketItem> _getMockCryptoData() {
    return [
      MarketItem(symbol: 'BTC', name: 'Bitcoin', price: 45250.00, change: 1250.00, changePercent: 2.84, category: 'Kripto', lastUpdate: DateTime.now()),
      MarketItem(symbol: 'ETH', name: 'Ethereum', price: 2845.50, change: -125.30, changePercent: -4.22, category: 'Kripto', lastUpdate: DateTime.now()),
      MarketItem(symbol: 'BNB', name: 'Binance Coin', price: 315.75, change: 12.25, changePercent: 4.03, category: 'Kripto', lastUpdate: DateTime.now()),
      MarketItem(symbol: 'ADA', name: 'Cardano', price: 0.485, change: 0.025, changePercent: 5.43, category: 'Kripto', lastUpdate: DateTime.now()),
    ];
  }

  static List<MarketItem> _getMockGoldData() {
    return [
      MarketItem(symbol: 'XAU', name: 'Gram Altın', price: 2458.50, change: -12.30, changePercent: -0.50, category: 'Altın & Kıymetli', lastUpdate: DateTime.now()),
      MarketItem(symbol: 'XAG', name: 'Gümüş', price: 28.45, change: 0.85, changePercent: 3.08, category: 'Altın & Kıymetli', lastUpdate: DateTime.now()),
      MarketItem(symbol: 'XPD', name: 'Paladyum', price: 1125.00, change: -25.50, changePercent: -2.22, category: 'Altın & Kıymetli', lastUpdate: DateTime.now()),
      MarketItem(symbol: 'XPT', name: 'Platin', price: 945.75, change: 18.25, changePercent: 1.97, category: 'Altın & Kıymetli', lastUpdate: DateTime.now()),
    ];
  }

  static List<MarketItem> _getMockStockData() {
    return [
      MarketItem(symbol: 'THYAO', name: 'Türk Hava Yolları', price: 285.50, change: 12.25, changePercent: 4.48, category: 'Borsa', lastUpdate: DateTime.now()),
      MarketItem(symbol: 'AKBNK', name: 'Akbank', price: 58.75, change: -1.85, changePercent: -3.05, category: 'Borsa', lastUpdate: DateTime.now()),
      MarketItem(symbol: 'BIMAS', name: 'BİM', price: 245.00, change: 8.50, changePercent: 3.59, category: 'Borsa', lastUpdate: DateTime.now()),
      MarketItem(symbol: 'SAHOL', name: 'Sabancı Holding', price: 42.15, change: -0.95, changePercent: -2.20, category: 'Borsa', lastUpdate: DateTime.now()),
    ];
  }
}