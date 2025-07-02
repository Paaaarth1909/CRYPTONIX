// ignore_for_file: unused_import, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart';
import '../services/candle_api_service.dart';
import '../screens/add_chips_screen.dart';

class CoinDetailsScreen extends StatefulWidget {
  final String coinName;
  final String symbol;
  final double currentPrice;
  final double priceChangePercentage;

  const CoinDetailsScreen({
    super.key,
    required this.coinName,
    required this.symbol,
    required this.currentPrice,
    required this.priceChangePercentage,
  });

  @override
  State<CoinDetailsScreen> createState() => _CoinDetailsScreenState();
}

class _CoinDetailsScreenState extends State<CoinDetailsScreen> {
  List<Candle> candles = [];
  bool isLoading = true;
  String interval = '24h';
  final CandleApiService _candleService = CandleApiService();

  @override
  void initState() {
    super.initState();
    fetchCandles();
  }

  Future<void> fetchCandles() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await _candleService.getCandleData(widget.symbol, interval);
      setState(() {
        candles = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading chart data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0x1A00BFB3),
              child: Text(
                widget.symbol[0],
                style: const TextStyle(
                  color: Color(0xFF00BFB3),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${widget.symbol} ${widget.coinName}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price Per Unit',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '\$${widget.currentPrice.toStringAsFixed(3)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.priceChangePercentage >= 0
                              ? const Color(0x33008000)
                              : const Color(0x33FF0000),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${widget.priceChangePercentage >= 0 ? '+' : ''}${widget.priceChangePercentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: widget.priceChangePercentage >= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 300,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF00BFB3)))
                  : Candlesticks(
                      candles: candles,
                    ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildIntervalButton('24h'),
                  _buildIntervalButton('7d'),
                  _buildIntervalButton('30d'),
                  _buildIntervalButton('90d'),
                  _buildIntervalButton('1y'),
                  _buildIntervalButton('All'),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildOverviewItem('High', '\$900.2M'),
                    _buildOverviewItem('Low', '\$650.7M'),
                    _buildOverviewItem('Open', '\$880.9M'),
                    _buildOverviewItem('Mkt Cap', '\$15,133.7T'),
                    _buildOverviewItem('Percentage', '\$593.70T'),
                    _buildOverviewItem('Mkt Dominance', '46%'),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0x80000000),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddChipsScreen(
                        coinName: widget.coinName,
                        symbol: widget.symbol,
                        currentPrice: widget.currentPrice,
                        priceChangePercentage: widget.priceChangePercentage,
                      ),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/add_chips_button.png',
                  width: double.infinity,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalButton(String text) {
    bool isSelected = interval == text;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            interval = text;
          });
          fetchCandles();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF00BFB3) : Colors.transparent,
          side: BorderSide(
            color: isSelected ? const Color(0xFF00BFB3) : Colors.grey,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 