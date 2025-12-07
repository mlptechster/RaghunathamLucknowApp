import 'package:flutter/material.dart';
import 'package:raghunathamhomes/constants/app_colors.dart';
import 'package:raghunathamhomes/features/home_page/widgets/home_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.overlayDark,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.accentGold),
        backgroundColor: AppColors.overlayDark,
        centerTitle: true,
        title: Text("Raghunatham Homes",
        style: headingStyle,
        ),
      ),
      drawer: HomeDrawer(),
    );
  }
}