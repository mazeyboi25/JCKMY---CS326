import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_test/sign_up.dart';
import 'tap-button.dart';
import 'log_in.dart';


class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        children: [
          buildPage(
            title: "",
            description: "",
            imagePath: "assets/intro1.png",
            titleAlignment: Alignment.center,
            descriptionAlignment: Alignment.center,
            buttonAlignment: Alignment.bottomCenter,
          ),
          buildPage(
            title: "",
            description: "",
            imagePath: "assets/intro2.png",
            titleAlignment: Alignment.topLeft,
            descriptionAlignment: Alignment.center,
            buttonAlignment: Alignment.bottomLeft,
          ),
          buildPage(
            title: "",
            description: " ",
            imagePath: "assets/intro3.png",
            isLastPage: true,
            titleAlignment: Alignment.topLeft,
            descriptionAlignment: Alignment.center,
            buttonAlignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }

  Widget buildPage({
    required String title,
    required String description,
    required String imagePath,
    required Alignment titleAlignment,
    required Alignment descriptionAlignment,
    required Alignment buttonAlignment,
    bool isLastPage = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: titleAlignment,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: descriptionAlignment,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (isLastPage)
            Align(
              alignment: buttonAlignment,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TapButton(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LS()),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class LS extends StatelessWidget {
  const LS({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 300, 
              left: 0,
              right: screenWidth * -0.05, 
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "FarmFlow",
                  style: GoogleFonts.audiowide(
                    fontSize: screenWidth * 0.12, 
                    color: Color(0xFF02270A),
                    letterSpacing: 1.0,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            Positioned(
              bottom: screenHeight * 0.22, 
              left: screenWidth * 0.08,
              right: screenWidth * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton(context, "LOG IN", Color(0xFF02300C), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }),
                  _buildButton(context, "SIGN UP", Color(0xFF083727), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Color color, VoidCallback onPressed) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonPadding = EdgeInsets.symmetric(
      horizontal: screenWidth * 0.1,
      vertical: 13,
    );

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: Offset(-6, 6),
            blurRadius: 6.0,
          ),
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.white, width: 1),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.mulish(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
   );
  }
}
