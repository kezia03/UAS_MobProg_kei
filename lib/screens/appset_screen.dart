import 'package:flutter/material.dart';

class AppSetScreen extends StatefulWidget {
  const AppSetScreen({super.key});

  @override
  _AppSetScreenState createState() => _AppSetScreenState();
}

class _AppSetScreenState extends State<AppSetScreen> {
  bool isDarkMode = false; // To track dark mode toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B61DD),
        title: const Text(
          'Application Setting',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.g_translate, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingOption(
              icon: Icons.language,
              title: 'Language',
              onTap: () {
                // Navigate to language settings screen if you have one
              },
            ),
            const SizedBox(height: 15),
            _buildDarkModeOption(),
            const SizedBox(height: 15),
            _buildSettingOption(
              icon: Icons.logout,
              title: 'Logout App',
              onTap: () {
                // Navigate back to the login screen and clear the navigation history
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (Route<dynamic> route) => false, // This removes all previous routes
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget for a general setting option
  Widget _buildSettingOption({required IconData icon, required String title, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFD6E4FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF4B61DD)),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B61DD),
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF4B61DD)),
          ],
        ),
      ),
    );
  }

  // Widget for the dark mode toggle
  Widget _buildDarkModeOption() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFD6E4FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.dark_mode, color: Color(0xFF4B61DD)),
          const SizedBox(width: 15),
          const Expanded(
            child: Text(
              'Dark Mode',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B61DD),
              ),
            ),
          ),
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
            },
            activeColor: const Color(0xFF4B61DD),
          ),
        ],
      ),
    );
  }
}
