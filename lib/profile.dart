import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'log_in.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();  // Added password controller

  @override
  void initState() {
    super.initState();
    getProfileInfo();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();  // Dispose of password controller
    super.dispose();
  }

  Future<void> getProfileInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('user_token');

      if (token == null) {
        _navigateToLogin();
        return;
      }

      final response = await http.post(
        Uri.parse("https://tionsns.pythonanywhere.com/api/getinfo/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"token": token}),
      );
      print(token);

      // Debug print statements
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _emailController.text = data['email'] ?? '';
          _nameController.text = data['username'] ?? '';
        });
      } else {
        _showMessage("Failed to load profile info", isError: true);
      }
    } catch (e) {
      print("Exception: $e"); // Also helpful for debugging
      _showMessage("An error occurred. Please try again.", isError: true);
    }
  }

  Future<void> updateProfileInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('user_token');

      if (token == null) {
        _navigateToLogin();
        return;
      }

      

      final response = await http.put(
        Uri.parse("https://tionsns.pythonanywhere.com/api/updateinfo/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "token": token,
          "username": _nameController.text,
          "password": _passwordController.text.isNotEmpty ? _passwordController.text : null,
        }),
      );


      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        _showMessage("Profile updated successfully");
      } else {
        final data = jsonDecode(response.body);
        _showMessage(data['message'] ?? "Update failed", isError: true);
      }
    } catch (e) {
      _showMessage("An error occurred. Please try again.", isError: true);
    }
  }

  Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('user_token');
      String? email = prefs.getString('user_email');

      if (token == null || email == null) {
        _navigateToLogin();
        return;
      }

      final response = await http.post(
        Uri.parse("https://tionsns.pythonanywhere.com/api/logout/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"email": email, "token": token}),
      );

      if (response.statusCode == 200) {
        await prefs.remove('user_token');
        await prefs.remove('user_email');
        _showMessage("Logout successful");
        _navigateToLogin();
      } else {
        final data = jsonDecode(response.body);
        _showMessage(data['message'] ?? "Logout failed", isError: true);
      }
    } catch (e) {
      _showMessage("An error occurred. Please try again.", isError: true);
    }
  }

  Future<void> deleteUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('user_token');

      if (token == null) {
        _navigateToLogin();
        return;
      }

      final response = await http.delete(
        Uri.parse("https://tionsns.pythonanywhere.com/api/deleteuser/"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        await prefs.clear();
        final data = jsonDecode(response.body);
        _showMessage(data['message']);
        _navigateToLogin();
      } else {
        _showMessage("Failed to delete user", isError: true);
      }
    } catch (e) {
      _showMessage("An error occurred. Please try again.", isError: true);
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF0B3D2E), width: 2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(-4, 4),
            blurRadius: 5,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          labelStyle: GoogleFonts.mulish(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0B3D2E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 3,
        onTap: (index) {
          if (index != 3) {
            // Replace this with actual navigation if needed
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: ''),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 14,
              child: Icon(Icons.person, color: Color(0xFF0B3D2E)),
            ),
            label: '',
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: -185,
            left: -60,
            child: _buildCircle(Colors.teal.shade900),
          ),
          Positioned(
            top: -185,
            right: -60,
            child: _buildCircle(const Color(0xFF0B3D2E)),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 70),
                _buildLogoHeader(),
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/Farmflow_logo.png'),
                ),
                const SizedBox(height: 26),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      _buildTextField(_nameController, "Username"),
                      const SizedBox(height: 15),
                      _buildTextField(_passwordController, "Password"),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _buildSaveButton(),
                const SizedBox(height: 20),
                _buildLogoutButton(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(Color color) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildLogoHeader() {
    return Column(
      children: [
        Image.asset(
          'assets/Farmflow_logo.png',
          width: 65,
          height: 65,
        ),
        const SizedBox(height: 2),
        Text(
          "FarmFlow",
          style: GoogleFonts.audiowide(
            fontSize: 38,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF02270A),
            shadows: [
              Shadow(
                offset: const Offset(-4, 4),
                blurRadius: 5,
                color: Colors.black.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: updateProfileInfo,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0B3D2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
        elevation: 5,
      ),
      child: Text(
        'SAVE',
        style: GoogleFonts.mulish(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return OutlinedButton.icon(
      onPressed: logout,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFF0B3D2E), width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 10),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      icon: SizedBox(
        width: 30,
        height: 30,
        child: Image.asset(
          'assets/Log_out.png',
          color: const Color(0xFF0B3D2E),
          fit: BoxFit.contain,
        ),
      ),
      label: Text(
        'LOG OUT',
        style: GoogleFonts.mulish(
          color: const Color(0xFF0B3D2E),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
