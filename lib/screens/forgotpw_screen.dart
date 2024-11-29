import 'package:flutter/material.dart';
import 'services/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _errorMessage = '';
  String _successMessage = '';
  bool _isLoading = false;

  // Validasi format email
  bool _isValidEmail(String email) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  // Validasi apakah email terdaftar
  Future<bool> _isEmailRegistered(String email) async {
    try {
      List<String> methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      return false; // Jika error, anggap email tidak terdaftar
    }
  }

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    final email = _emailController.text.trim();

    // Validasi format email
    if (!_isValidEmail(email)) {
      setState(() {
        _errorMessage = 'Invalid email format. Please enter a valid email.';
      });
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Validasi apakah email terdaftar
    bool isRegistered = await _isEmailRegistered(email);
    if (!isRegistered) {
      setState(() {
        _errorMessage = 'This email is not registered.';
      });
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Kirim OTP jika validasi berhasil
    try {
      bool otpSent = await EmailOTP.sendOTP(email: email);

      if (otpSent) {
        setState(() {
          _successMessage =
              'OTP has been sent to $email. Please check your email.';
        });

        // Navigate ke screen verifikasi OTP
        Navigator.pushNamed(context, '/verify-code', arguments: {
          'email': email,
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to send OTP. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
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
        title: const Text('Forgot Password'),
        backgroundColor: const Color(0xFF4B61DD),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, // Arrow Back menjadi putih
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white, // Teks "Forgot Password" menjadi putih
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon or Logo
                Icon(
                  Icons.lock_reset,
                  size: 100,
                  color: const Color(0xFF4B61DD).withOpacity(0.8),
                ),
                const SizedBox(height: 20),

                // Title
                const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B61DD),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter your registered email address to receive an OTP.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // Email Input Field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Error or Success Message
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                if (_successMessage.isNotEmpty)
                  Text(
                    _successMessage,
                    style: const TextStyle(color: Colors.green),
                  ),
                const SizedBox(height: 20),

                // Send OTP Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B61DD),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Send OTP',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
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
