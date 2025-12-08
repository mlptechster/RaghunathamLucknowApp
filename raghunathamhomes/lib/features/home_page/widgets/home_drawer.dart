import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raghunathamhomes/constants/app_colors.dart';
import 'package:raghunathamhomes/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:raghunathamhomes/features/authentication/presentation/bloc/auth_event.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.72, 
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.overlayDark,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.overlayDark,
              blurRadius: 100,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 18),
              color: AppColors.shadowStrong,
              child: ListView(
                children: [

                  // -------------------------
                  // 1. Profile Header
                  // -------------------------
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.accentGold,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome", 
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text("User Name",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 35),

                  // -------------------------
                  // MENU GROUP 1
                  // -------------------------
                  DrawerItem(title: "My Profile", icon: Icons.person_outline, onTap: () {  },),
                  DrawerItem(title: "LDA Bylaws", icon: Icons.book_outlined, onTap: () {  },),
                  DrawerItem(title: "Agreement", icon: Icons.description_outlined, onTap: () {  },),
                  DrawerItem(title: "Feedback", icon: Icons.feedback_outlined, onTap: () {  },),

                  const SizedBox(height: 18),

                  // -------------------------
                  // MENU GROUP 2
                  // -------------------------
                  DrawerItem(title: "Broker Charges", icon: Icons.currency_rupee, onTap: () {  },),
                  DrawerItem(title: "Trust", icon: Icons.shield_outlined, onTap: () {  },),

                  const SizedBox(height: 18),

                  // -------------------------
                  // MENU GROUP 3
                  // -------------------------
                  DrawerItem(title: "Settings", icon: Icons.settings_outlined, onTap: () {  },),
                  DrawerItem(title: "Refund and Earn", icon: Icons.wallet_outlined, onTap: () {  },),

                  const SizedBox(height: 18),

                  // -------------------------
                  // MENU GROUP 4
                  // -------------------------
                  DrawerItem(title: "Earn Money", icon: Icons.attach_money, onTap: () {  },),
                  DrawerItem(title: "Sell Your Property", icon: Icons.sell_outlined, onTap: () {  },),
                  DrawerItem(title: "Circle Rates", icon: Icons.location_on_outlined, onTap: () {  },),

                  const SizedBox(height: 18),

                  // -------------------------
                  // MENU GROUP 5
                  // -------------------------
                  DrawerItem(title: "Registry Loss", icon: Icons.error_outline, onTap: () {  },),
                  DrawerItem(title: "Consult", icon: Icons.support_agent_outlined, onTap: () {  },),
                  DrawerItem(title: "Personal Advisor", icon: Icons.person_search_outlined, onTap: () {  },),

                  const SizedBox(height: 18),

                  // -------------------------
                  // MENU GROUP 6
                  // -------------------------
                  DrawerItem(title: "Lease a Property", icon: Icons.real_estate_agent_outlined, onTap: () {  },),
                  DrawerItem(title: "Rent a Banquet", icon: Icons.celebration_outlined, onTap: () {  },),
                  DrawerItem(title: "PGs & Hotel Rooms", icon: Icons.hotel_outlined, onTap: () {  },),
                  DrawerItem(title: "LogOut",icon: Icons.logout_outlined,onTap:(){
                    context.read<AuthBloc>().add(AuthSignOutRequested());
                    Navigator.pop(context);
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Reusable drawer menu item widget
class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Icon(icon, color: AppColors.accentGold, size: 22),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}