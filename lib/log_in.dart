import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'homescreen.dart';
import 'sign_up.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _showCircles = true; 
  final FocusNode _focusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
final FocusNode _passwordFocusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _emailFocusNode.addListener(_onFocusChange);
  _passwordFocusNode.addListener(_onFocusChange);
    _loadSavedCredentials();
    _emailController.addListener(() {
    });
  }

  void _onFocusChange() {
    setState(() {
      _showCircles = !(_emailFocusNode.hasFocus || _passwordFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _emailFocusNode.removeListener(_onFocusChange);
  _passwordFocusNode.removeListener(_onFocusChange);
    _focusNode.removeListener(_onFocusChange);
    _emailFocusNode.dispose();
  _passwordFocusNode.dispose();
    _focusNode.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('saved_email') ?? '';
      _passwordController.text = prefs.getString('saved_password') ?? '';
      _rememberMe = prefs.getBool('remember_me') ?? false;
    });
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('saved_email', _emailController.text);
      await prefs.setString('saved_password', _passwordController.text);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);
    }
  }

  Future<void> _login(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("Please fill in all fields.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse("https://tionsns.pythonanywhere.com/api/login/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _showMessage("Login Successful!");
        await Future.delayed(Duration(seconds: 0));
        await _saveCredentials();
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        _showError(responseData['message'] ?? "Invalid email or password.");
      }
    } catch (e) {
      _showError("An error occurred. Please try again.");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Colors.red,
    ));
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(-5, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          focusNode: _emailFocusNode,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.grey.shade300,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 13,
              offset: Offset(-5, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            labelText: "Password",
            filled: true,
            fillColor: Colors.grey.shade300,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            suffixIcon: IconButton(
              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
      ),
    );
  }


  @override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () {
      FocusScope.of(context).unfocus(); // Dismiss the keyboard when tapping outside
    },
    child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Decorative Circles
                Positioned(left: -100, top: -200, child: _decorativeCircle(340, Color.fromARGB(255, 7, 47, 33))),
                Positioned(top: -200, right: -80, child: _decorativeCircle(340, Color.fromARGB(255, 100, 137, 68))),
                Positioned(bottom: -170, left: -80, child: _decorativeCircle(300, Color.fromARGB(255, 100, 137, 68))),
                Positioned(right: -80, bottom: -180, child: _decorativeCircle(300, Color.fromARGB(255, 7, 47, 33))),

                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                        crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
                        children: [
                          // Logo & Title
                          Padding(
                            padding: const EdgeInsets.only(top: 16, left: 23),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/Farmflow_logo.png',
                                  height: 70,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                    "FarmFlow",
                                     style: GoogleFonts.audiowide(
                                     fontSize: 35,
                                     fontWeight: FontWeight.bold,
                                     color: const Color(0xFF02270A),
                                   shadows: [
                                          Shadow(
                                          offset: Offset(-4, 4), // Moves the shadow to the left
                                          blurRadius: 5, // Adjust blur for a softer effect
                                          color: Colors.black.withOpacity(0.3), // Adjust shadow color and opacity
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Form Fields
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center, // Center form fields
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildTextField(_emailController, "Email"),
                                _buildPasswordField(),

                                // Remember Me Checkbox
                                Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: _rememberMe,
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe = value ?? false;
                                          });
                                        },
                                        checkColor: Colors.black,
                                        activeColor: Colors.white,
                                      ),
                                      const Text(
                                        "Remember Me",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Login Button with Shadow
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25), 
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3), 
                                        offset: Offset(-5, 4), 
                                        blurRadius: 7,
                                        spreadRadius: 1, 
                                      ),
                                    ],
                                  ),
                                  child: SizedBox(
                                    width: 130,
                                    height: 45,
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : () => _login(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 2, 45, 11),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25), // Match shadow shape
                                          side: BorderSide(color: Colors.white, width: 2),
                                        ),
                                        elevation: 0, // Disable default elevation to avoid double shadows
                                      ),
                                      child: _isLoading
                                          ? const CircularProgressIndicator(color: Colors.white)
                                          : Text(
                                              "LOG IN",
                                              style: GoogleFonts.mulish(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),

                                // Signup Redirect
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                    );
                                  },
                                  child: const Text.rich(
                                    TextSpan(
                                      text: "Don't have an account? ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Sign Up",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                            decorationColor: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}


Widget _decorativeCircle(double size, Color color) {
  return _showCircles
      ? Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(74, 0, 0, 0),
                blurRadius: 17,
                offset: Offset(-2, -9),
              ),
            ],
          ),
        )
      : SizedBox(); // Add an alternative return value if _showCircles is false
}
}

