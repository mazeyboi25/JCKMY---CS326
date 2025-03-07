import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'sign_up_introscreen.dart';

class VerificationScreen extends StatefulWidget {
  final String email;

  const VerificationScreen({super.key, required this.email});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isVerifying = false;
  bool _canResend = false;

  Future<void> verifyCode() async {
    if (_codeController.text.trim().isEmpty) {
      _showMessage("Please enter the verification code", isError: true);
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      var response = await http.post(
        Uri.parse("https://tionsns.pythonanywhere.com/api/verification/"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode({
          "email": widget.email,
          "code": _codeController.text.trim(),
        }),
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _showMessage("Verification successful! Redirecting...");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => IntroScreen2()),
          (route) => false,
        );
      } else {
        _showMessage(responseData['message'] ?? "Invalid verification code", isError: true);
        _codeController.clear();
      }
    } catch (e) {
      _showMessage("An error occurred. Please try again.", isError: true);
    }

    setState(() {
      _isVerifying = false;
    });
  }

  void _resendCode() {
    setState(() {
      _canResend = false;
    });
    Future.delayed(Duration(seconds: 30), () {
      setState(() {
        _canResend = true;
      });
    });
    _showMessage("A new verification code has been sent to ${widget.email}");
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"), // Change to your BG
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/Logo.png", height: 100), // Add your logo
              const SizedBox(height: 20),
              Text(
                'Enter the verification code sent to ${widget.email}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Pinput(
                controller: _codeController,
                length: 6,
                keyboardType: TextInputType.number,
                showCursor: true,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 50,
                  textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Grey input box
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isVerifying ? null : verifyCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800], // Dark grey button
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                ),
                child: _isVerifying
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Verify", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _canResend ? _resendCode : null,
                child: Text(
                  "Resend Code",
                  style: TextStyle(
                    color: _canResend ? Colors.blue : Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
