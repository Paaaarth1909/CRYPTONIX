// ignore_for_file: unused_import, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:cryptox_app/services/crypto_api_service.dart';
import 'package:cryptox_app/widgets/bottom_nav_bar.dart';

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
  final CryptoApiService _apiService = CryptoApiService();

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
      final data = await _apiService.getCandleData(widget.symbol, interval);
      setState(() {
        candles = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error
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
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
            SizedBox(width: 8),
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
            icon: Icon(Icons.star_border, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              const Color(0xFF1A1A1A),
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
                  Text(
                    'Price Per Unit',
                    style: const TextStyle(
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
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
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
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: isLoading
                  ? Center(child: CircularProgressIndicator(color: const Color(0xFF00BFB3)))
                  : Candlesticks(
                      candles: candles,
                    ),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
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
                padding: EdgeInsets.all(16),
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
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0x80000000),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BFB3),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Add chips',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
      padding: EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            interval = text;
          });
          fetchCandles();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF00BFB3) : const Color(0x3300BFB3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildOverviewItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 