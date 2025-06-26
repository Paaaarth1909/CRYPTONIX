import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:candlesticks/candlesticks.dart';
import '../config/api_config.dart';

class CryptoApiService {
  // Using configuration from api_config.dart
  static final String _baseUrl = ApiConfig.baseUrl;
  static final String _apiKey = ApiConfig.apiKey;

  // Example endpoints
  static const String _coinsEndpoint = '/coins';
  static const String _candlesEndpoint = '/candles';

  // Fetch list of coins
  Future<List<Map<String, dynamic>>> getCoins() async {
    try {
      // TODO: Replace with your actual API call
      // This is just a sample implementation
      final response = await http.get(
        Uri.parse('$_baseUrl$_coinsEndpoint'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((coin) => coin as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load coins');
      }
    } catch (e) {
      // Return sample data for now
      return [
        {
          'name': 'Bitcoin',
          'symbol': 'BTC',
          'price': 853134.900,
          'priceChange': 10.2,
          'high': 900.2,
          'low': 650.7,
          'open': 880.9,
          'marketCap': 15133.7,
          'percentage': 593.70,
          'marketDominance': 46,
        },
        {
          'name': 'Ethereum',
          'symbol': 'ETH',
          'price': 32134.50,
          'priceChange': -2.5,
          'high': 400.2,
          'low': 350.7,
          'open': 380.9,
          'marketCap': 5133.7,
          'percentage': 293.70,
          'marketDominance': 26,
        },
      ];
    }
  }

  // Fetch candle data for a specific coin
  Future<List<Candle>> getCandleData(String symbol, String interval) async {
    try {
      // TODO: Replace with your actual API call
      // This is just a sample implementation
      final response = await http.get(
        Uri.parse('$_baseUrl$_candlesEndpoint/$symbol?interval=$interval'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((candle) {
          return Candle(
            date: DateTime.fromMillisecondsSinceEpoch(candle['timestamp']),
            high: candle['high'].toDouble(),
            low: candle['low'].toDouble(),
            open: candle['open'].toDouble(),
            close: candle['close'].toDouble(),
            volume: candle['volume'].toDouble(),
          );
        }).toList();
      } else {
        throw Exception('Failed to load candle data');
      }
    } catch (e) {
      // Return sample candle data for now
      return List.generate(
        30,
        (index) => Candle(
          date: DateTime.now().subtract(Duration(minutes: index * 15)),
          high: 853.34 + (index * 2),
          low: 850.34 - (index * 1),
          open: 851.34 + (index * 1.5),
          close: 852.34 + (index * 1.8),
          volume: 1234.56 + (index * 100),
        ),
      ).reversed.toList();
    }
  }
} 