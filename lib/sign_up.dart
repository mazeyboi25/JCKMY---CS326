import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'verification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
      }),
    );

    var responseData = jsonDecode(response.body);
    print("Response Data: $responseData"); // Debugging

    if (response.statusCode == 201) {
      String? message = responseData["message"]; // Extract success message
      String? token = responseData["token"]; // Extract token

      if (token != null) {
        // Store email and token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email);
        await prefs.setString('user_token', token);
      }

      _showMessage(message ?? "User registered successfully. Check your email for verification.");
      
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => VerificationScreen(email: email)),
        );
      });
    } else {
      _showMessage(responseData['message'] ?? "Sign Up Failed", isError: true);
    }
  } catch (e) {
    print("Sign-up Error: $e"); // Debugging
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
    resizeToAvoidBottomInset: true, 
    body: SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual, 
      physics: const AlwaysScrollableScrollPhysics(), 
      child: Stack(
        children: [
          Container(
            color: Color(0xFF052419), 
            width: double.infinity,
            height: MediaQuery.of(context).size.height, 
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85, // Reduced width
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start, // Left-align text
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/Farmflow_logo.png', // Replace with actual logo path
                                height: 70,
                              ), 
                              const Text(
                                "Start your farming journey with us.",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 2),
                            ],
                          ),
                        ),
                        const SizedBox(height: 9),
                        Center( // Centered input fields
                          child: Column(
                            children: [
                              _buildTextField(_usernameController, "Username"),
                              _buildTextField(_emailController, "Email Address", TextInputType.emailAddress),
                              _buildTextField(_passwordController, "Password", TextInputType.text, _obscurePassword, true),
                              _buildTextField(_confirmPasswordController, "Confirm Password", TextInputType.text, _obscureConfirmPassword, true),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center( // Centered button
                          child: ElevatedButton(
                            onPressed: signUpUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                              foregroundColor: const Color(0xFF02270A),
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
            "SIGN UP",
            style: GoogleFonts.mulish(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
                          ),
                        ),
                        SizedBox(height: 70,)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Decorative Circles (Fixed Position)
          Positioned(left: 30, top: -190, right: -40, child: _decorativeCircle(300, const Color(0xFF14532D))),
          Positioned(top: -100, right: -130, child: _decorativeCircle(280, Color.fromARGB(255, 100, 137, 68))),
          Positioned(bottom: -140, left: -50, child: _decorativeCircle(270, const Color(0xFF14532D))),
          Positioned(right: 0, bottom: -230, left: 20, child: _decorativeCircle(300, Color.fromARGB(255, 100, 137, 68))),
        ],
      ),
    ),
  );
}


  Widget _buildTextField(TextEditingController controller, String label, [TextInputType keyboardType = TextInputType.text, bool obscureText = false, bool isPassword = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade300,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      if (controller == _passwordController) {
                        _obscurePassword = !_obscurePassword;
                      } else if (controller == _confirmPasswordController) {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      }
                    });
                  },
                )
              : null,
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

  Widget _decorativeCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(184, 0, 0, 0),
            blurRadius: 20,
            offset: Offset(-2,-9),
          ),
        ],
      ),
    );
  }
}
