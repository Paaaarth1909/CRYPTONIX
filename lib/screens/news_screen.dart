import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'News Feed',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 10, // Will be replaced with actual news data length
        itemBuilder: (context, index) {
          return NewsCard();
        },
      ),
    );
  }
}

class NewsCard extends StatefulWidget {
  const NewsCard({Key? key}) : super(key: key);

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool isFollowing = false;
  bool isOptionsSheetOpen = false;

  void _toggleOptionsBottomSheet(BuildContext context) {
    if (isOptionsSheetOpen) {
      Navigator.pop(context);
      isOptionsSheetOpen = false;
    } else {
      isOptionsSheetOpen = true;
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionItem(
                icon: Icons.share_outlined,
                label: 'Share',
                onTap: () {
                  Navigator.pop(context);
                  isOptionsSheetOpen = false;
                  _shareNews();
                },
              ),
              _buildOptionItem(
                icon: Icons.person_remove_outlined,
                label: 'Unfollow Binance',
                onTap: () {
                  Navigator.pop(context);
                  isOptionsSheetOpen = false;
                  setState(() {
                    isFollowing = false;
                  });
                },
              ),
              _buildOptionItem(
                icon: Icons.bookmark_border_outlined,
                label: 'Save',
                onTap: () {
                  Navigator.pop(context);
                  isOptionsSheetOpen = false;
                  _saveNews();
                },
              ),
              _buildOptionItem(
                icon: Icons.open_in_browser,
                label: 'Open in browser',
                onTap: () {
                  Navigator.pop(context);
                  isOptionsSheetOpen = false;
                  _openInBrowser();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ).then((_) {
        // This callback is called when the bottom sheet is dismissed
        isOptionsSheetOpen = false;
      });
    }
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareNews() async {
    try {
      await Share.share(
        'Check out this news from Binance Marketplace!\nhttps://binance.com/marketplace',
        subject: 'Binance Marketplace News',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not share news')),
      );
    }
  }

  void _saveNews() {
    // Implement save functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('News saved successfully'),
        backgroundColor: Color(0xFF1E3A2B),
      ),
    );
  }

  void _openInBrowser() async {
    final Uri url = Uri.parse('https://binance.com/marketplace');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open browser')),
      );
    }
  }

  void _showFollowingNotification(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: const Color(0xFF1E3A2B),
      duration: const Duration(seconds: 3),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Following is success!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Its goal is to show people the stories they care\nabout most, every time they visit.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: const Text(
              'See more',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void _toggleFollow(BuildContext context) {
    setState(() {
      isFollowing = !isFollowing;
    });
    if (isFollowing) {
      _showFollowingNotification(context);
    }
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailScreen(
          title: 'Binance Marketplace, The Super App for Crypto!',
          content: '''Access your favorite businesses right at your fingertips via the Binance app. Binance Marketplace is a platform that makes spending crypto easy and rewarding.

Featuring over 16 merchants and mini apps, Binance Marketplace is a one-stop shop for all your crypto payment needs and more.

Discover exclusive offers when you pay for hotel stays, rideshare services, shopping, dining, and more with Binance Pay via Binance Marketplace.

What Can You Do on Marketplace?

On Binance Marketplace, you can make purchases, book hotel stays and experiences with crypto, participate in Binance Launchpad, and even earn rewards with Liquid Swap. You can also access the Binance DeFi Wallet, NFT Marketplace, and Binance Live via the Binance Marketplace.

There are also mini games within the app that you can play with friends and that offer you a chance to win prizes. Need to top up your phone credit? Do it from anywhere you please with the [Mobile Top-Up] feature on Binance Marketplace and earn cashback while you're at it.''',
          authorName: 'Binance',
          timeAgo: '6m ago',
          authorImage: 'assets/images/logo.png',
          newsImage: 'assets/images/logo.png',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 0.5,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Binance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Satellites',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _toggleFollow(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing ? const Color(0xFF00BFB3) : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: isFollowing ? BorderSide.none : const BorderSide(color: Color(0xFF00BFB3)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                  child: Text(
                    isFollowing ? 'Following' : 'Follow',
                    style: TextStyle(
                      color: isFollowing ? Colors.black : const Color(0xFF00BFB3),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                  onPressed: () => _toggleOptionsBottomSheet(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Binance Expands Account Statement Function. With our VIP and institutional clients in mind, we\'ve upgraded the account statement function...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[900],
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                'Liked by Huoqie and others 1,900',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text(
                '150 responses',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 