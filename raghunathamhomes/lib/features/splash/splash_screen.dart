import 'package:flutter/material.dart';
import 'package:raghunathamhomes/dependency_injection.dart';
import 'package:raghunathamhomes/features/authentication/domain/use_cases/get_current_user_use_case.dart';
import 'package:raghunathamhomes/features/authentication/presentation/pages/auth_screen.dart';
import 'package:raghunathamhomes/features/home_page/pages/home_page.dart';
import 'package:raghunathamhomes/utlis/transition/fade_route.dart';
import 'dart:math';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _revealAnimation;
  
  // Flag to ensure navigation happens only once after both checks pass
  bool _authCheckComplete = false;
  bool _animationComplete = false;

  // ⭐ Get the Use Case via Service Locator
  final GetCurrentUserUseCase _getCurrentUserUseCase = sl<GetCurrentUserUseCase>(); 

  @override
  void initState() {
    super.initState();
    
    // 1. Initialize Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800), 
    );

    _revealAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    // 2. Start Animation
    _controller.forward();

    // 3. Set Animation Listener
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationComplete = true;
        _navigateIfReady();
      }
    });

    // 4. Start Authentication Check
    _checkAuthStatus();
  }

  // ⭐ New Method to check authentication status
  void _checkAuthStatus() async {
    // Wait for the asynchronous authentication check
    final user = await _getCurrentUserUseCase.execute();
    
    // Determine the next screen based on the result
    final nextPage = user != null 
        ? const HomePage() 
        : const AuthScreen(); // Navigate to Login/Signup

    // Store the destination page and mark auth check as complete
    _destinationPage = nextPage;
    _authCheckComplete = true;

    // Attempt to navigate
    _navigateIfReady();
  }

  // Store the calculated destination page
  Widget? _destinationPage;

  // ⭐ New Navigation Method
  void _navigateIfReady() {
    // Only navigate if the animation is done AND the auth check is complete
    if (_animationComplete && _authCheckComplete && _destinationPage != null) {
      // Use pushReplacement to ensure the user cannot go back to the splash screen
      Navigator.pushReplacement(
        context, 
        FadeRoute(page: _destinationPage!),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Build method remains the same
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxRadius = sqrt(pow(size.width / 2, 2) + pow(size.height / 2, 2));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return ClipPath(
              clipper: CircleRevealClipper(
                radius: _revealAnimation.value * maxRadius,
                center: Offset(size.width / 2, size.height / 2),
              ),
              child: Image.asset(
                "assets/logo2.png",
                width: size.width * 0.7,
                fit: BoxFit.contain,
              ),
            );
          },
        ),
      ),
    );
  }
}

// Custom Clipper remains the same
class CircleRevealClipper extends CustomClipper<Path> {
  final double radius;
  final Offset center;

  CircleRevealClipper({required this.radius, required this.center});

  @override
  Path getClip(Size size) {
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(CircleRevealClipper oldClipper) {
    return oldClipper.radius != radius;
  }
}