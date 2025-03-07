import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TapButton extends StatelessWidget {
  final VoidCallback onTap;

  const TapButton({super.key, required this.onTap});

@override
Widget build(BuildContext context) {
  return Align(
    alignment: const Alignment(0, 1),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 300,
          height: 65,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 2, 43, 9).withOpacity(0.8),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(202, 0, 0, 0),
                Color(0xFF052419),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(35),
            border: Border.all( // Adding white border
              color: Colors.white,
              width: 2, // Adjust thickness
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            "Tap to continue",
            style: GoogleFonts.mulish(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 253, 253, 253),
            ),
          ),
        ),
      ),
    ),
  );
}
  }
