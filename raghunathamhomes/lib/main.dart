import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // IMPORTANT: Import the package
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Figma Gold Color
    const Color figmaGold = Color(0xFFD4AF37);
    const Color darkBackground = Color(0xFF1E1E1E);

    // Define the base theme
    final baseTheme = ThemeData.dark().copyWith(
      primaryColor: figmaGold,
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
      ),
      useMaterial3: true,
    );

    // 1. Set Inter as the default font for the entire TextTheme
    // 2. Use copyWith to manually override the specific heading styles with Playfair Display
    final textTheme = GoogleFonts.interTextTheme(baseTheme.textTheme).copyWith(
      // Headings and Titles (Playfair Display)
      displayLarge: GoogleFonts.playfairDisplayTextTheme(baseTheme.textTheme).displayLarge?.copyWith(fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.playfairDisplayTextTheme(baseTheme.textTheme).displayMedium?.copyWith(fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.playfairDisplayTextTheme(baseTheme.textTheme).displaySmall?.copyWith(fontWeight: FontWeight.bold),
      headlineLarge: GoogleFonts.playfairDisplayTextTheme(baseTheme.textTheme).headlineLarge?.copyWith(fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.playfairDisplayTextTheme(baseTheme.textTheme).headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      headlineSmall: GoogleFonts.playfairDisplayTextTheme(baseTheme.textTheme).headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.playfairDisplayTextTheme(baseTheme.textTheme).titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );


    return MaterialApp(
      title: 'Raghunantham Premium Living',
      theme: baseTheme.copyWith(
        textTheme: textTheme,
      ),
      home: HomePage(),
    );
  }
}