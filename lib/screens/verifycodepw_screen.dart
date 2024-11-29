import 'package:flutter/material.dart';
import 'dart:async';
import 'services/email_otp.dart';

class VerifyCodePWScreen extends StatefulWidget {
  final String email;

  const VerifyCodePWScreen({Key? key, required this.email}) : super(key: key);

  @override
  _VerifyCodePWScreenState createState() => _VerifyCodePWScreenState();
}

class _VerifyCodePWScreenState extends State<VerifyCodePWScreen> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<String> _otpDigits = List.filled(6, '');
  String _errorMessage = '';
  bool _isLoading = false;
  bool _canResendOtp = true;
  int _resendCountdown = 300;
  late Timer _timer = Timer(const Duration(seconds: 0), () {});

  @override
  void dispose() {
    if (_timer.isActive) _timer.cancel();
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _canResendOtp = false;
      _resendCountdown = 300;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown == 0) {
        timer.cancel();
        setState(() {
          _canResendOtp = true;
        });
      } else {
        setState(() {
          _resendCountdown--;
        });
      }
    });
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      bool otpSent = await EmailOTP.sendOTP(email: widget.email);
      if (otpSent) {
        _startResendTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP has been resent successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to resend OTP. Please try again.';
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

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      String otp = _otpDigits.join();
      if (otp.isEmpty || otp.length < 6) {
        setState(() {
          _errorMessage = 'Please enter the complete OTP.';
        });
        return;
      }

      bool isValid = EmailOTP.verifyOTP(otp: otp);
      if (isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP Verified Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/set-new-password');
      } else {
        setState(() {
          _errorMessage = 'Invalid OTP. Please try again.';
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
        title: const Text('Verify OTP'),
        backgroundColor: const Color(0xFF4B61DD),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, // Panah back warna putih
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white, // Teks header warna putih
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon or Logo
            const Icon(
              Icons.lock_open,
              size: 100,
              color: Color(0xFF4B61DD),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Enter the verification code sent to your email.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 50,
                  child: TextField(
                    focusNode: _focusNodes[index],
                    onChanged: (value) {
                      setState(() {
                        _otpDigits[index] = value;
                      });
                      if (value.isNotEmpty && index < _focusNodes.length - 1) {
                        _focusNodes[index + 1].requestFocus();
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    buildCounter: (context,
                            {required currentLength,
                            required isFocused,
                            maxLength}) =>
                        null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Verify Button
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtp,
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
                      'Verify',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
            const SizedBox(height: 20),

            // Resend OTP Button
            TextButton(
              onPressed: _canResendOtp && !_isLoading ? _resendOtp : null,
              child: Text(
                _canResendOtp
                    ? 'Resend OTP'
                    : 'Resend in ${_resendCountdown ~/ 60}:${_resendCountdown % 60}',
                style: TextStyle(
                  color: _canResendOtp ? const Color(0xFF4B61DD) : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Error Message
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
