import 'package:flutter/material.dart';
import 'package:cryptox_app/widgets/bottom_nav_bar.dart';
import 'package:cryptox_app/screens/coin_details_screen.dart';
import 'package:cryptox_app/services/crypto_api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final CryptoApiService _apiService = CryptoApiService();
  List<Map<String, dynamic>> coins = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCoins();
  }

  Future<void> _loadCoins() async {
    try {
      final data = await _apiService.getCoins();
      setState(() {
        coins = data;
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildHomeContent() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: Color(0xFF00BFB3)));
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black,
            Color(0xFF1A1A1A),
          ],
        ),
      ),
      child: RefreshIndicator(
        color: Color(0xFF00BFB3),
        onRefresh: _loadCoins,
        child: ListView.builder(
          itemCount: coins.length,
          itemBuilder: (context, index) {
            final coin = coins[index];
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0x80000000),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0x33FFFFFF),
                  width: 1,
                ),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CoinDetailsScreen(
                        coinName: coin['name'],
                        symbol: coin['symbol'],
                        currentPrice: coin['price'],
                        priceChangePercentage: coin['priceChange'],
                      ),
                    ),
                  );
                },
                contentPadding: EdgeInsets.all(12),
                leading: CircleAvatar(
                  backgroundColor: const Color(0x3300BFB3),
                  child: Text(
                    coin['symbol'][0],
                    style: TextStyle(
                      color: Color(0xFF00BFB3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  coin['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  coin['symbol'],
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${coin['price'].toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: coin['priceChange'] >= 0
                            ? const Color(0x33008000)
                            : const Color(0x33FF0000),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${coin['priceChange'] >= 0 ? '+' : ''}${coin['priceChange']}%',
                        style: TextStyle(
                          color: coin['priceChange'] >= 0
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'CryptoX',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeContent(),
          Center(child: Text('Trending', style: TextStyle(color: Colors.white))),
          Center(child: Text('Explore', style: TextStyle(color: Colors.white))),
          Center(child: Text('Wallet', style: TextStyle(color: Colors.white))),
          Center(child: Text('Profile', style: TextStyle(color: Colors.white))),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
        ),
        child: CustomBottomNavBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
