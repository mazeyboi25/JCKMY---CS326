import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'homescreen.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> signUpUser() async {
    if (!_formKey.currentState!.validate()) return;

    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      _showMessage("Passwords do not match", isError: true);
      return;
    }

    try {
      var response = await http.post(
        Uri.parse("https://tionsns.pythonanywhere.com/api/register/"),
        headers: {"Content-Type": "application/json",
        "Accept" : "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _showMessage("Verification email sent. Check your inbox.");
        
        // ✅ Automatically navigate to VerificationScreen with email
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VerificationScreen(email: email)),
        );
      } else {
        _showMessage(responseData['message'] ?? "Sign Up Failed", isError: true);
      }
    } catch (e) {
      _showMessage("An error occurred. Please try again.", isError: true);
    }
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/sign-up_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Card(
                color: Colors.white.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                elevation: 5,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Sans-serif",
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(_usernameController, "Username"),
                        _buildTextField(_emailController, "Email Address", TextInputType.emailAddress),
                        _buildTextField(_passwordController, "Password", TextInputType.text, true),
                        _buildTextField(_confirmPasswordController, "Confirm Password", TextInputType.text, true),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: signUpUser,
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, [TextInputType keyboardType = TextInputType.text, bool obscureText = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.3),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label is required";
          }
          return null;
        },
      ),
    );
  }
}

// ✅ VERIFICATION SCREEN ✅
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
