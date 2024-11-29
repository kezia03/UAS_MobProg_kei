import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  _SetNewPasswordScreenState createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

  Future<void> updatePassword() async {
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    final String newPassword = _newPasswordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    // Validasi input
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = "Both fields are required.";
        _isLoading = false;
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _errorMessage = "Passwords do not match.";
        _isLoading = false;
      });
      return;
    }

    if (newPassword.length < 8) {
      setState(() {
        _errorMessage = "Password must be at least 8 characters long.";
        _isLoading = false;
      });
      return;
    }

    try {
      // Ambil pengguna saat ini
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Perbarui password
        await user.updatePassword(newPassword);

        print("Password updated successfully for user: ${user.email}");

        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully!')),
        );

        // Redirect ke halaman login
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() {
          _errorMessage = "User not logged in. Please try again.";
        });
      }
    } catch (e) {
      print("Failed to update password: $e");
      setState(() {
        _errorMessage = "An unexpected error occurred: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F3),
      appBar: AppBar(
        title: const Text('Set New Password'),
        backgroundColor: const Color(0xFF4B61DD),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, // Panah back warna putih
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white, // Judul warna putih
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Heading Section
                const Column(
                  children: [
                    Icon(
                      Icons.lock_reset,
                      size: 100,
                      color: Color(0xFF4B61DD),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Set New Password',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B61DD),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Please enter your new password and confirm it below.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Input Fields Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // New Password Field
                      TextField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          labelStyle: const TextStyle(color: Color(0xFF4B61DD)),
                          filled: true,
                          fillColor: const Color(0xFF4B61DD).withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color(0xFF4B61DD),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Confirm Password Field
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: const TextStyle(color: Color(0xFF4B61DD)),
                          filled: true,
                          fillColor: const Color(0xFF4B61DD).withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xFF4B61DD),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Update Password Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : updatePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4B61DD),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Update Password',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      const SizedBox(height: 15),

                      // Error Message
                      if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
