import 'package:candlesticks/candlesticks.dart';

class CandleApiService {
  Future<List<Candle>> getCandleData(String symbol, String interval) async {
    try {
      // Return sample candle data for now
      // TODO: Replace with your actual candle data API implementation
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
    } catch (e) {
      throw Exception('Failed to load candle data: $e');
    }
  }
} 