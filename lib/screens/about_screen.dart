import 'package:flutter/material.dart';
import 'package:polylingo/screens/faq_screen.dart';
import 'package:polylingo/screens/testi_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B61DD),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.g_translate, color: Colors.white),
            onPressed: () {
              // Implement language switch functionality if needed
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Frequently Asked Question Button
            _buildOptionButton(context, 'Frequently Asked Question'),
            const SizedBox(height: 15),
            // Testimony Button
            _buildOptionButton(context, 'Testimony'),
            const SizedBox(height: 30),
            // Contact Us Section
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFD6E4FF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  _buildContactInfo(
                    icon: Icons.location_on,
                    text: 'Jl. Indomie jadi laper blok JJ no. 23, Jakarta Utara, DKI Jakarta, 17700',
                  ),
                  const SizedBox(height: 10),
                  _buildContactInfo(
                    icon: Icons.phone,
                    text: '+62-85547834451',
                  ),
                  const SizedBox(height: 10), 
                  _buildContactInfo(
                    icon: Icons.chat,
                    text: '+62-81254247897',
                  ),
                  const SizedBox(height: 10),
                  _buildContactInfo(
                    icon: Icons.email,
                    text: 'loremipsum@gmail.com',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create option buttons
  Widget _buildOptionButton(BuildContext context, String title) {
  return GestureDetector(
    onTap: () {
      if (title == 'Frequently Asked Question') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FAQScreen()),
        );
      } else if (title == 'Testimony') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TestimonyScreen()),
        );
      }
      // Add more navigation if needed for other buttons in the future
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFD6E4FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4B61DD),
          ),
        ),
      ),
    ),
  );
}




  // Helper method to create contact info rows
  Widget _buildContactInfo({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
