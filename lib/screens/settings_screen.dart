import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1C1C1E), // Dark background color
              Color(0xFF2C2C2E), // Slightly lighter dark color
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Settings options
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    _buildSettingItem(
                      icon: Icons.lock_outline,
                      title: 'Privacy Policy',
                      iconColor: Color(0xFF00BFB3),
                    ),
                    _buildSettingItem(
                      icon: Icons.star_outline,
                      title: 'Index',
                      iconColor: Color(0xFF00BFB3),
                    ),
                    _buildSettingItem(
                      icon: Icons.language,
                      title: 'Language',
                      trailing: Text(
                        'English',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      iconColor: Color(0xFF00BFB3),
                    ),
                    _buildSettingItem(
                      icon: Icons.logout,
                      title: 'Quit',
                      iconColor: Color(0xFF00BFB3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    required Color iconColor,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        trailing: trailing ?? Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
        onTap: () {
          // Handle tap for each setting
        },
      ),
    );
  }
} 