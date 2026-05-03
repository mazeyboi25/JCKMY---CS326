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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> logout(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('user_token');
      String? email = prefs.getString('user_email');

      if (token == null || email == null) {
        _navigateToLogin(context);
        return;
      }

      var response = await http.post(
        Uri.parse("https://tionsns.pythonanywhere.com/api/logout/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "email": email,
          "token": token,
        }),
      );

      if (response.statusCode == 200) {
        await prefs.remove('user_token');
        await prefs.remove('user_email');
        _showMessage(context, "Logout successful");
        _navigateToLogin(context);
      } else {
        var responseData = jsonDecode(response.body);
        _showMessage(context, responseData['message'] ?? "Logout failed", isError: true);
      }
    } catch (e) {
      print(e);
      _showMessage(context, "An error occurred. Please try again.", isError: true);
    }
  }

  Future<void> getProfileInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('user_token');

      if (token == null) {
        _navigateToLogin(context);
        return;
      }

      var response = await http.get(
        Uri.parse("https://tionsns.pythonanywhere.com/api/getinfo/"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        setState(() {
          _emailController.text = responseData['email'];
          _nameController.text = responseData['username'];
        });
      } else {
        _showMessage(context, "Failed to load profile info", isError: true);
      }
    } catch (e) {
      print(e);
      _showMessage(context, "An error occurred. Please try again.", isError: true);
    }
  }

  Future<void> updateProfileInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('user_token');

      if (token == null) {
        _navigateToLogin(context);
        return;
      }

      var response = await http.put(
        Uri.parse("https://tionsns.pythonanywhere.com/api/updateinfo/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "username": _nameController.text,
          "password": _phoneController.text.isNotEmpty ? _phoneController.text : null, // Example of optional fields
        }),
      );

      if (response.statusCode == 200) {
        _showMessage(context, "Profile updated successfully");
      } else {
        var responseData = jsonDecode(response.body);
        _showMessage(context, responseData['message'] ?? "Update failed", isError: true);
      }
    } catch (e) {
      print(e);
      _showMessage(context, "An error occurred. Please try again.", isError: true);
    }
  }

  Future<void> deleteUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('user_token');

      if (token == null) {
        _navigateToLogin(context);
        return;
      }

      var response = await http.delete(
        Uri.parse("https://tionsns.pythonanywhere.com/api/deleteuser/"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        _showMessage(context, responseData['message']);
        await prefs.remove('user_token');
        await prefs.remove('user_email');
        _navigateToLogin(context);
      } else {
        _showMessage(context, "Failed to delete user", isError: true);
      }
    } catch (e) {
      print(e);
      _showMessage(context, "An error occurred. Please try again.", isError: true);
    }
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showMessage(BuildContext context, String message, {bool isError = false}) {
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(-4, 4),
            blurRadius: 5,
          ),
        ],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0B3D2E), width: 2),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.mulish(
            fontSize: 16,
            color: Colors.black.withOpacity(0.6),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch profile info when the screen loads
    getProfileInfo();

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0B3D2E),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(235, 255, 255, 255),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: ''),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF0B3D2E)),
            ),
            label: '',
          ),
        ],
        onTap: (index) {
          // Ensure profile icon doesn't lead to login page
          if (index == 3) {
            // Profile icon clicked, stay on the profile screen
            return;
          }
        },
      ),
      body: Stack(
        children: [
          Positioned(
            top: -185,
            left: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 7, 49, 37),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -185,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Color(0xFF0B3D2E),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 70),
                Column(
                  children: [
                    Image.asset(
                      'assets/Farmflow_logo.png',
                      width: 65,
                      height: 65,
                      fit: BoxFit.contain,
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
                ),
                const SizedBox(height: 10),
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/Farmflow_logo.png'),
                ),
                const SizedBox(height: 26),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      _buildTextField(_nameController, "Full Name"),
                      const SizedBox(height: 15),
                      _buildTextField(_emailController, "Email"),
                      const SizedBox(height: 15),
                      _buildTextField(_phoneController, "Phone Number"),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
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
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () => logout(context),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF0B3D2E), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
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
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
