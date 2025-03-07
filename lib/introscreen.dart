import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_test/sign_up.dart';
import 'tap-button.dart';
import 'log_in.dart';
import 'sign_up_introscreen.dart';


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
  return Scaffold(
    body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/bg.png"), // Background image
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 300, 
            left: 0,
            right: -22,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "FarmFlow",
                style: GoogleFonts.audiowide(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  " ",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 162, 
            left: 35,
            right: 33,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(-6, 6), // Left and below shadow
                        blurRadius: 6.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(30), // Match button shape
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 2, 48, 12),
                      padding: EdgeInsets.symmetric(horizontal: 45, vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(-6, 6), // Left and below shadow
                        blurRadius: 6.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(30), // Match button shape
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 8, 55, 39),
                      padding: EdgeInsets.symmetric(horizontal: 38, vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
