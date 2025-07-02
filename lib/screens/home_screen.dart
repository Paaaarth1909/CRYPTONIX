import 'package:flutter/material.dart';
import '../services/crypto_api_service.dart';
import '../models/crypto_coin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CryptoApiService _apiService = CryptoApiService();
  List<CryptoCoin> _coins = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadCryptoData();
  }

  Future<void> _loadCryptoData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });
      final coins = await _apiService.getCryptoList();
      setState(() {
        _coins = coins;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Crypto Market',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _loadCryptoData,
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error.isNotEmpty
                      ? Center(
                          child: Text(
                            _error,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadCryptoData,
                          child: ListView.builder(
                            itemCount: _coins.length,
                            itemBuilder: (context, index) {
                              final coin = _coins[index];
                              final isPositiveChange = coin.changePct >= 0;
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                color: Colors.grey[900],
                                child: ListTile(
                                  leading: Image.network(
                                    coin.icon,
                                    width: 40,
                                    height: 40,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.currency_bitcoin, color: Colors.amber),
                                  ),
                                  title: Text(
                                    coin.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    coin.symbol,
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$${coin.rate.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${isPositiveChange ? '+' : ''}${coin.changePct.toStringAsFixed(2)}%',
                                        style: TextStyle(
                                          color: isPositiveChange
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    // Navigate to coin details screen
                                    // TODO: Implement navigation
                                  },
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
