// lib/presentation/widgets/banquet_hall_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raghunathamhomes/constants/app_colors.dart';
import '../../domain/entities/banquet_hall_entity.dart';

class BanquetHallCard extends StatelessWidget {
  final BanquetHallEntity hall;
  final VoidCallback onBook;

  const BanquetHallCard({
    super.key,
    required this.hall,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hall.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${hall.capacity} Guests · ₹${hall.hourlyRate.toStringAsFixed(0)}/hr',
                    style:
                        GoogleFonts.inter(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hall.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentGoldDark,
                      foregroundColor: AppColors.textWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: onBook,
                    child: const Text('Book this hall'),
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
            child: SizedBox(
              width: 130,
              height: 150,
              child: Image.network(
                hall.images.isNotEmpty
                    ? hall.images.first
                    : 'https://picsum.photos/300/200?blur=2',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
