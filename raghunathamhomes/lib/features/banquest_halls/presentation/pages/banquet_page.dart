// lib/presentation/pages/banquet_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raghunathamhomes/constants/app_colors.dart';
import 'package:raghunathamhomes/features/banquest_halls/presentation/bloc/banquet_booking_bloc.dart';
import 'package:raghunathamhomes/features/banquest_halls/presentation/bloc/banquet_booking_event.dart';
import 'package:raghunathamhomes/features/banquest_halls/presentation/bloc/banquet_booking_state.dart';
import '../widgets/banquet_hall_card.dart';
import '../widgets/banquet_booking_sheet.dart';

class BanquetPage extends StatefulWidget {
  const BanquetPage({super.key});

  @override
  State<BanquetPage> createState() => _BanquetPageState();
}

class _BanquetPageState extends State<BanquetPage> {
  @override
  void initState() {
    super.initState();
    context.read<BanquetBookingBloc>().add(LoadBanquetHallsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          'Banquet Halls',
          style: GoogleFonts.playfairDisplay(
            color: AppColors.accentGold,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<BanquetBookingBloc, BanquetBookingState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.errorMessage != null) {
              return Center(child: Text(state.errorMessage!));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _heroCard(),
                  const SizedBox(height: 20),
                  ...state.halls.map(
                    (hall) => BanquetHallCard(
                      hall: hall,
                      onBook: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => BlocProvider.value(
                            value: context.read<BanquetBookingBloc>(),
                            child: BanquetBookingSheet(hall: hall),
                          ),
                        );
                      },
                      
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Your Bookings',
                      style: goldHeadingStyle.copyWith(fontSize: 22),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (state.bookings.isEmpty)
                    Text('No banquet bookings yet.', style: bodyText)
                  else
                    Column(
                      children: state.bookings
                          .map(
                            (b) => Card(
                              color: AppColors.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: ListTile(
                                title: Text(
                                  b.eventTitle?.isNotEmpty == true
                                      ? b.eventTitle!
                                      : 'Booking ${b.id}',
                                  style: bodyText.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                subtitle: Text(
                                  '${b.start} → ${b.end}\nStatus: ${b.status.name}',
                                  style: captionText,
                                ),
                                trailing: Text(
                                  '₹${b.amount.toStringAsFixed(0)}',
                                  style: bodyText.copyWith(
                                    color: AppColors.accentGoldDark,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _heroCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.royalGoldGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Host Unforgettable Events',
                  style: headingStyle.copyWith(
                    color: AppColors.textWhite,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Two luxurious banquet halls with 100-guest capacity each, perfect for weddings, receptions and corporate events.',
                  style: bodyText.copyWith(color: AppColors.textWhite),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 120,
              height: 110,
              child: Image.asset(
                'assets/logo2.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
