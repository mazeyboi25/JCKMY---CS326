import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://tionsns.pythonanywhere.com/api/verification/";

  // User Registration
  Future<Map<String, dynamic>?> registerUser(String email, String password, String username) async {
    final response = await http.post(
      Uri.parse('${baseUrl}register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'username': username,
      }),
    );

    return response.statusCode == 201 ? jsonDecode(response.body) : null;
  }

  // User Login
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return response.statusCode == 200 ? jsonDecode(response.body) : null;
  }

  // Verify Email Code
  Future<bool> verifyCode(String email, String code) async {
    final response = await http.post(
      Uri.parse('${baseUrl}verify/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'code': code,
      }),
    );

    return response.statusCode == 200;
  }
}