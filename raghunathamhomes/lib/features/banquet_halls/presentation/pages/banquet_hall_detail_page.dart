import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/app_colors.dart';
import '../../domain/entities/banquet_hall_entity.dart';
import '../bloc/banquet_booking_bloc.dart';
import '../widgets/banquet_booking_sheet.dart';

class BanquetHallDetailPage extends StatelessWidget {
  final BanquetHallEntity hall;

  const BanquetHallDetailPage({super.key, required this.hall});

  void _openTopBookingPopup(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Booking',
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.only(top: 80, left: 16, right: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowStrong,
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: BlocProvider.value(
                value: context.read<BanquetBookingBloc>(),
                child: BanquetBookingSheet(hall: hall),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          hall.name,
          style: headingStyle
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _imageSlider(),
            const SizedBox(height: 20),
            _hallInfoCard(),
            const SizedBox(height: 20),
            _hallDescription(),
            const SizedBox(height: 20),
            _hallIdDisplay(),
            const SizedBox(height: 30),
            _bookNowButton(context),
          ],
        ),
      ),
    );
  }

  /// IMAGE SLIDER (fixed: Image.asset)
  Widget _imageSlider() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 220,
        child: hall.images.isEmpty
            ? Container(
                alignment: Alignment.center,
                color: AppColors.surfaceDark,
                child: Text("No Images Available", style: bodyText),
              )
            : PageView.builder(
                itemCount: hall.images.length,
                itemBuilder: (_, i) => Image.asset(
                  hall.images[i],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.surfaceDark,
                    alignment: Alignment.center,
                    child: Text("Image not found", style: bodyText),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _hallInfoCard() {
    return Card(
      elevation: 6,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hall.name, style: headingStyle.copyWith(fontSize: 28)),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.people, color: AppColors.primary),
                const SizedBox(width: 8),
                Text("Capacity: ${hall.capacity} guests", style: bodyText.copyWith(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.currency_rupee, color: AppColors.accentGold),
                const SizedBox(width: 6),
                Text(
                  "₹${hall.hourlyRate} / hour",
                  style: bodyText.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentGoldDark,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _hallDescription() {
    return Card(
      elevation: 4,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          hall.description,
          style: bodyText.copyWith(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }

  Widget _hallIdDisplay() {
    return Card(
      elevation: 3,
      color: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.tag, color: AppColors.primaryLight),
            const SizedBox(width: 10),
            Text(
              "Hall ID:  ${hall.id}",
              style: bodyText.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// BOOK NOW BUTTON (fixed: open from top)
  Widget _bookNowButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentGold,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () => _openTopBookingPopup(context),
        child: Text(
          "Book This Hall",
          style: GoogleFonts.playfairDisplay(
            color: AppColors.primaryDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
