import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'sign_up_introscreen.dart';
import 'package:google_fonts/google_fonts.dart';

class VerificationScreen extends StatefulWidget {
  final String email;

  const VerificationScreen({super.key, required this.email});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isVerifying = false;
  bool _canResend = true;
  int _resendTimer = 0;
  Timer? _timer;

  Future<void> verifyCode() async {
    if (_codeController.text.trim().isEmpty) {
      _showMessage("Please enter the verification code", isError: true);
      return;
    }

    setState(() => _isVerifying = true);

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
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => IntroScreen2()),
            (route) => false,
          );
        });
      } else {
        _showMessage(responseData['message'] ?? "Invalid verification code", isError: true);
        _codeController.clear();
      }
    } catch (e) {
      _showMessage("An error occurred. Please try again.", isError: true);
    }

    setState(() => _isVerifying = false);
  }

  Future<void> _resendCode() async {
    setState(() {
      _canResend = false;
      _resendTimer = 5;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        timer.cancel();
        setState(() => _canResend = true);
      }
    });

    try {
      _showMessage("Sending a new code to ${widget.email}...");

      var response = await http.post(
        Uri.parse("https://tionsns.pythonanywhere.com/api/resend/"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode({"email": widget.email}),
      );

      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _showMessage(responseData['message'] ?? "Verification code resent to ${widget.email}.");
      } else {
        _showMessage(responseData['message'] ?? "Failed to resend code", isError: true);
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
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/VERIFICATION.png"),
          fit: BoxFit.cover, 
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/Farmflow_logo.png", height: 100), 
              const SizedBox(height: 0),
                   Text(
                   "Verification Code",
                    style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 2, 29, 9),
                    shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3), // Shadow color
                          offset: Offset(-3, 2), // Slight left and bottom shadow
                         blurRadius: 5, // Soft shadow effect
                         ),
                      ],
                    ),
                  ),
              const SizedBox(height: 5),
              Text(
                "Enter the verification code sent to ${widget.email}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 0, 0, 0)),
              ),
              const SizedBox(height: 20),
              Pinput(
                controller: _codeController,
                length: 6,
                keyboardType: TextInputType.number,
                showCursor: true,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 60,
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                                BoxShadow(
                                color: Colors.black.withOpacity(0.2), 
                                offset: Offset(-5, 6), 
                                blurRadius: 6,
                                spreadRadius: 1, 
                                  ),
                                ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), 
                      offset: Offset(-5, 4), 
                      blurRadius: 6,
                      spreadRadius: 1, 
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF02270A),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), 
                      side: BorderSide(color: Colors.white, width: 2),
                    ),
                    elevation: 0, 
                  ),
                  child: _isVerifying
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("VERIFY", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 13),
            GestureDetector(
                  onTap: _canResend ? _resendCode : null,
                  child: Text(
                    _canResend ? "Resend Code" : "Resend in $_resendTimer s",
                    style: GoogleFonts.mulish(fontWeight: FontWeight.bold, color: _canResend ? Colors.blue : Colors.grey, decoration: _canResend ? TextDecoration.underline : null),
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

