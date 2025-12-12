// lib/presentation/widgets/banquet_booking_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raghunathamhomes/constants/app_colors.dart';
import 'package:raghunathamhomes/features/banquest_halls/presentation/bloc/banquet_booking_bloc.dart';
import 'package:raghunathamhomes/features/banquest_halls/presentation/bloc/banquet_booking_event.dart';

import '../../domain/entities/banquet_booking_entity.dart';
import '../../domain/entities/banquet_hall_entity.dart';

class BanquetBookingSheet extends StatefulWidget {
  final BanquetHallEntity hall;
  const BanquetBookingSheet({super.key, required this.hall});

  @override
  State<BanquetBookingSheet> createState() => _BanquetBookingSheetState();
}

class _BanquetBookingSheetState extends State<BanquetBookingSheet> {
  DateTime? start;
  DateTime? end;
  int guests = 1;
  final _eventTitleController = TextEditingController();
  final _eventTypeController = TextEditingController();
  final _eventNotesController = TextEditingController();

  @override
  void dispose() {
    _eventTitleController.dispose();
    _eventTypeController.dispose();
    _eventNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text('Book ${widget.hall.name}', style: goldHeadingStyle.copyWith(fontSize: 22)),
            const SizedBox(height: 12),

            // Date/time pickers, guest slider, and event fields as in previous message...
            // On submit:
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGoldDark,
                foregroundColor: AppColors.textWhite,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {
                if (start == null || end == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Select start and end time')),
                  );
                  return;
                }
                if (end!.isBefore(start!)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('End time must be after start')),
                  );
                  return;
                }
                final durationHours =
                    (end!.difference(start!).inMinutes / 60).ceil().toDouble();
                final amount = widget.hall.hourlyRate * durationHours;

                final booking = BanquetBookingEntity(
                  id: '',
                  hallId: widget.hall.id,
                  userId: userId,
                  start: start!,
                  end: end!,
                  guestsCount: guests,
                  status: BanquetBookingStatus.pending,
                  amount: amount,
                  eventTitle: _eventTitleController.text.trim(),
                  eventType: _eventTypeController.text.trim(),
                  eventNotes: _eventNotesController.text.trim(),
                  createdAt: DateTime.now(),
                );

                context
                    .read<BanquetBookingBloc>()
                    .add(CreateBanquetBookingEvent(booking));

                Navigator.of(context).pop();
              },
              child: const Text('Confirm booking request'),
            ),
          ],
        ),
      ),
    );
  }
}
