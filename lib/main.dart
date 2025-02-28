import 'package:flutter/material.dart';
import 'log-in.dart';
import 'sign-up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
    "/signup": (context) => SignUpScreen(),
    "/login": (context) => LoginScreen(),
      }
    );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut, // Bubble effect
    );

    // Navigate to Home Screen 
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), 
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/app_CP.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Image.asset(
              'assets/Logo.png',
              width: 300,
              height: 300,
            ),
          ),
        ),
      ),
    );
  }
}


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              top: 50, 
              left: 110,
              right: 0,
              child: Center(
                child: Text(
                  " Welcome \n             to \nFarmFlow",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontFamily: "Helvetica", 
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
              bottom: 100, // Adjust mid-bottom position
              left: 30,
              right: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 26, 104, 214), 
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => IntroScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 26, 104, 214),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


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
            imagePath: "assets/intro_pic1.png",
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
            title: "Get Started",
            description: " ",
            imagePath: "assets/app_CP.png",
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
                child: SwipeButton(
                  onSwipe: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
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


class SwipeButton extends StatelessWidget {
  final VoidCallback onSwipe;

  const SwipeButton({super.key, required this.onSwipe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0,1), // Adjust this value to move it higher or lower
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40), // Adjust this value to shift it up/down
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            onSwipe();
          },
          child: Container(
            width: 370,
            height: 73,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: const Color.fromARGB(195, 255, 255, 255)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  "Swipe to proceed to Sign-up   ",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 2, 3, 0),
                  ),
                ),
                Positioned(
                  right: 20,
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color.fromARGB(255, 0, 0, 0),
                    size: 22,
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