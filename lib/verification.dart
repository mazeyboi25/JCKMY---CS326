import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'homescreen.dart';


class VerificationScreen extends StatefulWidget {
  final String email;
  
  const VerificationScreen({super.key, required this.email});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isVerifying = false;

  Future<void> verifyCode() async {
    setState(() {
      _isVerifying = true;
    });

    try {
      var response = await http.post(
        Uri.parse("https://tionsns.pythonanywhere.com/api/verification/"),
        headers: {"Content-Type": "application/json",
        "Accept" : "application/json" },
        body: jsonEncode({
          "email": widget.email,
          "code": _codeController.text.trim(),
        }),
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _showMessage("Verification successful! Redirecting...");

        //Navigate to the dashboard or home screen
       Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(builder: (context) => HomeScreen()),
  (route) => false,
);
      } else {
        _showMessage(responseData['message'] ?? "Invalid verification code", isError: true);
      }
    } catch (e) {
      _showMessage("An error occurred. Please try again.", isError: true);
    }

    setState(() {
      _isVerifying = false;
    });
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
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the verification code sent to ${widget.email}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Verification Code",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isVerifying ? null : verifyCode,
              child: _isVerifying
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}
