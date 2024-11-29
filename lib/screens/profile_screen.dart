import 'package:flutter/material.dart';
import 'changepw_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Fixed Header Section
          Container(
            color: const Color(0xFF4B61DD), // Blue background for header section
            padding: const EdgeInsets.only(top: 45, bottom: 20, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Polylingo',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.g_translate, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Greeting Section
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white, // White background for verification section
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Verify Profile For More Complete Access to Your Services',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Red button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/accountSecurities'); // Navigate to AccountSecuritiesScreen
                        },
                        child: const Text(
                          'Verify Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFF0F4FF), // Light blue background for the main content
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B61DD), // Blue text color
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildProfileOption(context, Icons.person, 'Personal Info'),
                    _buildProfileOption(context, Icons.security, 'Account Securities'),
                    _buildProfileOption(context, Icons.info, 'About'),
                    _buildProfileOption(context, Icons.lock, 'Change Password'),
                    const SizedBox(height: 30),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B61DD), // Blue text color
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildProfileOption(context, Icons.settings, 'Application Settings'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        if (title == 'Personal Info') {
          Navigator.pushNamed(context, '/personal');
        } else if (title == 'Account Securities') {
          Navigator.pushNamed(context, '/accountSecurities'); 
        } else if (title == 'About') {
          Navigator.pushNamed(context, '/about');
        } else if (title == 'Change Password') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChangePwScreen()),
          );
        } else if (title == 'Application Settings') {
          Navigator.pushNamed(context, '/appSettings'); // Navigate to the AppSetScreen
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
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
                  fontSize: 16,
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
}
