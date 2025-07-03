// ignore_for_file: unused_import, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart';
import '../services/candle_api_service.dart';
import '../screens/add_chips_screen.dart';
import '../models/crypto_coin.dart';
import 'package:fl_chart/fl_chart.dart';

class CoinDetailsScreen extends StatefulWidget {
  final CryptoCoin coin;

  const CoinDetailsScreen({Key? key, required this.coin}) : super(key: key);

  @override
  State<CoinDetailsScreen> createState() => _CoinDetailsScreenState();
}

class _CoinDetailsScreenState extends State<CoinDetailsScreen> {
  final CandleApiService _apiService = CandleApiService();
  CryptoGraphData? _graphData;
  String _selectedTimeframe = '24h';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGraphData();
  }

  Future<void> _loadGraphData() async {
    try {
      setState(() => _isLoading = true);
      final data = await _apiService.getCryptoGraph(
        symbol: widget.coin.symbol,
        type: _getTimeframeType(_selectedTimeframe),
      );
      setState(() {
        _graphData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error
    }
  }

  String _getTimeframeType(String timeframe) {
    switch (timeframe) {
      case '24h':
        return 'Day';
      case '7d':
        return 'Week';
      case '30d':
        return 'Month';
      case '90d':
        return 'Quarter';
      case '1y':
        return 'Year';
      case 'All':
        return 'All';
      default:
        return 'Week';
    }
  }

  List<FlSpot> _getSpots() {
    if (_graphData == null) return [];
    return _graphData!.candles.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.close,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isPositiveChange = widget.coin.changePct >= 0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1C1C1E),
              Color(0xFF2C2C2E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    SizedBox(width: 16),
                    Image.network(
                      widget.coin.icon,
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${widget.coin.name} ${widget.coin.symbol}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.star_border, color: Colors.white),
                      onPressed: () {
                        // TODO: Implement favorite functionality
                      },
                    ),
                  ],
                ),
              ),
              // Price and Change
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price Per Unit',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '\$${widget.coin.rate.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${isPositiveChange ? '+' : ''}${widget.coin.changePct.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: isPositiveChange ? Color(0xFF00BFB3) : Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Graph
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _graphData == null
                        ? Center(
                            child: Text(
                              'Failed to load graph data',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(show: false),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: _getSpots(),
                                    isCurved: true,
                                    color: Color(0xFF00BFB3),
                                    barWidth: 2,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: Color(0xFF00BFB3).withOpacity(0.1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
              ),
              // Timeframe Buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    '24h',
                    '7d',
                    '30d',
                    '90d',
                    '1y',
                    'All',
                  ].map((timeframe) {
                    final isSelected = timeframe == _selectedTimeframe;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedTimeframe = timeframe);
                        _loadGraphData();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(0xFF00BFB3)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          timeframe,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Overview
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overview',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildOverviewItem(
                          'High',
                          '\$${_graphData?.candles.first.high.toStringAsFixed(1) ?? '0.0'} M',
                          Colors.green,
                        ),
                        _buildOverviewItem(
                          'Mkt Cap',
                          '\$${widget.coin.marketCap.toStringAsFixed(1)} T',
                          Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildOverviewItem(
                          'Low',
                          '\$${_graphData?.candles.first.low.toStringAsFixed(1) ?? '0.0'} M',
                          Colors.red,
                        ),
                        _buildOverviewItem(
                          'Percentage',
                          '\$${widget.coin.changePct.toStringAsFixed(2)}',
                          Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildOverviewItem(
                          'Open',
                          '\$${_graphData?.candles.first.open.toStringAsFixed(1) ?? '0.0'} M',
                          Colors.white,
                        ),
                        _buildOverviewItem(
                          'Mkt Dominance',
                          '46%',
                          Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Add Chips Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement add chips functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00BFB3),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Add chips',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewItem(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
} 