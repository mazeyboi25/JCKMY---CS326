import 'package:flutter/material.dart';
import 'profile.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FarmFlow',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activeScreen = "Home"; // Default screen

  /// Returns the appropriate screen widget
  Widget _getScreenBody() {
    switch (activeScreen) {
      case "Messages":
        return const MessagesScreen();
      case "Locations":
        return const LocationsScreen();
      case "Profile":
        return const ProfileScreen();
      default:
        return const Center(
          child: Text(
            "Home Screen",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        );
    }
  }

  void _handleFloat(String label) {
    if (mounted) {
      setState(() {
        activeScreen = label;
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        /// Background Rounded Header (Only on Home Screen)
        if (activeScreen == "Home")
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
              child: Container(
                height: 114, // Adjusted for better spacing
                color: const Color(0xFF02270A),
                child: Padding(
                  padding: const EdgeInsets.only(left: 0, top: 14), // Moves everything left
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          /// Logo positioned further to the left
                          Padding(
                            padding: const EdgeInsets.only(left: 0), // Adjust as needed
                            child: Image.asset(
                              'assets/Logo.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Text(
                            "FarmFlow",
                            style: GoogleFonts.audiowide(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightGreenAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        /// Dynamic Content (Changes when an icon is tapped)
        Positioned.fill(child: _getScreenBody()),

        /// Full-width bottom ribbon (No Expansion)
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 73,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF02270A),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingIconButton(
                  assetPath: 'assets/Home.png',
                  label: "Home",
                  onFloat: _handleFloat,
                ),
                FloatingIconButton(
                  assetPath: 'assets/Chat Bubble.png',
                  label: "Messages",
                  onFloat: _handleFloat,
                ),
                FloatingIconButton(
                  assetPath: 'assets/Location.png',
                  label: "Locations",
                  onFloat: _handleFloat,
                ),
                FloatingIconButton(
                  assetPath: 'assets/Male User.png',
                  label: "Profile",
                  onFloat: _handleFloat,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
  }


class FloatingIconButton extends StatefulWidget {
  final String assetPath;
  final String label;
  final Function(String) onFloat; // Notify HomeScreen

  const FloatingIconButton({
    super.key,
    required this.assetPath,
    required this.label,
    required this.onFloat,
  });

  @override
  _FloatingIconButtonState createState() => _FloatingIconButtonState();
}

class _FloatingIconButtonState extends State<FloatingIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _translateAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _translateAnimation = Tween<double>(begin: 0, end: -15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  void _onTap() {
    setState(() {
      _isPressed = true;
    });

    widget.onFloat(widget.label); // Notify HomeScreen

    _controller.forward().then((_) {
      if (mounted) {
        _controller.reverse().then((_) {
          setState(() {
            _isPressed = false;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _translateAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_isPressed)
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 229, 234, 229),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                        ),

                      /// Icon Image
                      Image.asset(
                        widget.assetPath,
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.label,
                    style: const TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Messages Screen",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class LocationsScreen extends StatelessWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Locations Screen",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}

