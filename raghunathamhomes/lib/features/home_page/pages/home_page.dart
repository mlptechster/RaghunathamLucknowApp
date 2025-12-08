import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raghunathamhomes/constants/app_colors.dart';
import 'package:raghunathamhomes/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:raghunathamhomes/features/authentication/presentation/bloc/auth_state.dart';
import 'package:raghunathamhomes/features/authentication/presentation/pages/auth_screen.dart';
import 'package:raghunathamhomes/features/home_page/widgets/home_drawer.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // We use a BlocConsumer to combine the builder (for loading overlay) 
    // and the listener (for navigation and errors).
    return BlocConsumer<AuthBloc, AuthState>(
      // 1. LISTENER: Handles side effects like navigation and showing SnackBars
      listener: (context, state) {
        // Clear previous SnackBars before showing a new one
        ScaffoldMessenger.of(context).hideCurrentSnackBar(); 

        // 1a. Handle Successful Sign-Out Navigation
        if (state.status == AuthStatus.unauthenticated) {
          // Navigate to AuthScreen and clear the entire navigation stack
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => const AuthScreen()),
            (Route<dynamic> route) => false,
          );
        }

        // 1b. Handle Error Message
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red.shade700,
            ),
          );
          // Note: The BLoC should ideally clear the errorMessage after the event is processed.
        }
      },
      
      // 2. BUILDER: Handles UI structure and displays the loading overlay
      builder: (context, state) {
        // Use a Stack to overlay the loading indicator on top of the main content
        return Stack(
          children: [
            // Main Content (Scaffold)
            Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                iconTheme: IconThemeData(color: AppColors.primary),
                backgroundColor: AppColors.background,
                centerTitle: true,
                // Replace 'headingStyle' with a direct style if the import is missing
                title: Text(
                  "Raghunatham Homes", 
                  style: headingStyle// Placeholder style
                ),
              ),
              drawer: const HomeDrawer(),
              body: const Center(
                 child: Text(
                    "Authenticated Home Content",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
              ),
            ),

            // 3. Loading Overlay
            if (state.isLoading)
              Container(
                color: Colors.black.withValues(alpha:0.5), // Semi-transparent overlay
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGold),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}