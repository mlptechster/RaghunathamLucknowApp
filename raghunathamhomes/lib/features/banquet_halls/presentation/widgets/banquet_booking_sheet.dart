// lib/presentation/widgets/banquet_booking_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raghunathamhomes/constants/app_colors.dart';
import 'package:raghunathamhomes/features/banquet_halls/presentation/bloc/banquet_booking_bloc.dart';
import 'package:raghunathamhomes/features/banquet_halls/presentation/bloc/banquet_booking_event.dart';
import 'package:raghunathamhomes/features/banquet_halls/presentation/bloc/banquet_booking_state.dart';

import '../../domain/entities/banquet_booking_entity.dart';
import '../../domain/entities/banquet_hall_entity.dart';

class BanquetBookingSheet extends StatefulWidget {
  final BanquetHallEntity hall;
  const BanquetBookingSheet({super.key, required this.hall});

  @override
  State<BanquetBookingSheet> createState() => _BanquetBookingSheetState();
}

class _BanquetBookingSheetState extends State<BanquetBookingSheet> {
  final _formKey = GlobalKey<FormState>();

  DateTime? start;
  DateTime? end;

  final _eventTitleController = TextEditingController();
  final _eventTypeController = TextEditingController();
  final _eventNotesController = TextEditingController();
  final _guestsController = TextEditingController(text: '50');

  String? _dateError;

  @override
  void dispose() {
    _eventTitleController.dispose();
    _eventTypeController.dispose();
    _eventNotesController.dispose();
    _guestsController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      if (isStart) {
        start = selected;

        // If end exists but is now invalid, reset it.
        if (end != null && !end!.isAfter(start!)) {
          end = null;
        }
      } else {
        // If start exists and selected end is not after start, block it.
        if (start != null && !selected.isAfter(start!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('End time must be after start time'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        end = selected;
      }

      _dateError = _validateDateRange();
    });
  }

  String formatDateTime(DateTime? dt) {
    if (dt == null) return '--';
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  int _computedMinutes() {
    if (start == null || end == null) return 0;
    return end!.difference(start!).inMinutes;
  }

  int _computedHours() {
    final minutes = _computedMinutes();
    if (minutes < 60) return 0; // invalid for booking summary
    return (minutes / 60).ceil(); // billing by hour
  }

  double getTotalAmount() {
    return widget.hall.hourlyRate * _computedHours().toDouble();
  }

  int _guestsValue() => int.tryParse(_guestsController.text.trim()) ?? 0;

  String? _validateDateRange() {
    if (start == null || end == null) return 'Please select start and end time';
    final minutes = _computedMinutes();
    if (minutes < 60) return 'Minimum booking duration is 1 hour';
    return null;
  }

  // ---- Field validators (ALL FIELDS) ----

  String? _requiredText(String? v, {required String fieldName, int min = 2, int max = 60}) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return '$fieldName is required';
    if (value.length < min) return '$fieldName must be at least $min characters';
    if (value.length > max) return '$fieldName must be at most $max characters';
    return null;
  }

  String? _notesValidator(String? v, {int max = 250}) {
    final value = (v ?? '').trim();
    // Notes can be empty, but still validated for max length.
    if (value.length > max) return 'Notes must be at most $max characters';
    return null;
  }

  String? _guestsValidator(String? v) {
    final n = int.tryParse((v ?? '').trim());
    if (n == null) return 'Enter a valid number';
    if (n < 10) return 'Minimum 10 guests required';
    if (n > 100) return 'Maximum 100 guests allowed';
    return null;
  }

  void validateAndBook() {
    final isFormOk = _formKey.currentState?.validate() ?? false;

    final dateError = _validateDateRange();
    setState(() => _dateError = dateError);

    if (!isFormOk || dateError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(dateError ?? 'Please fix the highlighted errors'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to book a hall'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final booking = BanquetBookingEntity(
      id: '',
      hallId: widget.hall.id,
      userId: userId,
      start: start!,
      end: end!,
      guestsCount: _guestsValue(),
      status: BanquetBookingStatus.pending,
      amount: getTotalAmount(),
      eventTitle: _eventTitleController.text.trim(),
      eventType: _eventTypeController.text.trim(),
      eventNotes: _eventNotesController.text.trim(),
      createdAt: DateTime.now(),
    );

    context.read<BanquetBookingBloc>().add(CreateBanquetBookingEvent(booking));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BanquetBookingBloc, BanquetBookingState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
          );
        }
        if (state.bookingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking request submitted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.textMuted,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text('Book ${widget.hall.name}', style: goldHeadingStyle.copyWith(fontSize: 22)),
                const SizedBox(height: 16),

                // Event Title (required)
                TextFormField(
                  controller: _eventTitleController,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(labelText: 'Event Title'),
                  validator: (v) => _requiredText(v, fieldName: 'Event Title', min: 3, max: 50),
                ),
                const SizedBox(height: 8),

                // Event Type (required)
                TextFormField(
                  controller: _eventTypeController,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(labelText: 'Event Type'),
                  validator: (v) => _requiredText(v, fieldName: 'Event Type', min: 3, max: 30),
                ),
                const SizedBox(height: 8),

                // Notes (optional but validated)
                TextFormField(
                  controller: _eventNotesController,
                  textInputAction: TextInputAction.newline,
                  maxLines: 2,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(labelText: 'Notes (optional)'),
                  validator: _notesValidator,
                ),
                const SizedBox(height: 12),

                // Guests (required, 10..100)
                TextFormField(
                  controller: _guestsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Number of Guests (10 - 100)',
                  ),
                  validator: _guestsValidator,
                ),
                const SizedBox(height: 16),

                // Date pickers
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: Text('Start: ${formatDateTime(start)}'),
                  onTap: () => _pickDateTime(isStart: true),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: Text('End: ${formatDateTime(end)}'),
                  onTap: () => _pickDateTime(isStart: false),
                ),

                if (_dateError != null) ...[
                  const SizedBox(height: 6),
                  Text(_dateError!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 12),

                // Booking summary (only if valid range)
                if (_validateDateRange() == null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hours: ${_computedHours()}'),
                      Text('Total Amount: ₹${getTotalAmount().toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                    ],
                  ),

                // Confirm button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentGoldDark,
                      foregroundColor: AppColors.textWhite,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: validateAndBook,
                    child: Text('Confirm Booking',style: buttonTextPrimary,),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
