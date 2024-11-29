import 'package:flutter/material.dart';

class ChangePwScreen extends StatelessWidget {
  const ChangePwScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B61DD), // Blue background for AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: const Align(
          alignment: Alignment.centerLeft, // Align title to the left
          child: Text(
            'Change Password',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
          ),
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
          children: [
            const SizedBox(height: 20),
            _buildPasswordField('Current Password'),
            const SizedBox(height: 20),
            _buildPasswordField('New Password'),
            const SizedBox(height: 20),
            _buildPasswordField('Confirm Password'),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Red button color
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Handle change password logic
              },
              child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20), // Add horizontal padding to the text
              child: Text(
                'Change New Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
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

  // Method to create a password text field
  Widget _buildPasswordField(String hintText) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFD6E4FF), // Light blue background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
