// lib/presentation/widgets/banquet_hall_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raghunathamhomes/constants/app_colors.dart';
import '../../domain/entities/banquet_hall_entity.dart';

class BanquetHallCard extends StatelessWidget {
  final BanquetHallEntity hall;
  final VoidCallback onBook;
  final VoidCallback onViewDetails;

  const BanquetHallCard({
    super.key,
    required this.hall,
    required this.onBook,
    required this.onViewDetails,
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
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${hall.capacity} Guests · ₹${hall.hourlyRate}/hr',
                    style: bodyText,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hall.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: captionText,
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: onBook,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentGoldDark,
                        ),
                        child:Text('Book',style: buttonTextPrimary,),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: onViewDetails,
                        child:  Text('View Details',style: buttonTextDark,),
                      ),
                    ],
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
            child: Image.asset(
              hall.images.first,
              width: 120,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
