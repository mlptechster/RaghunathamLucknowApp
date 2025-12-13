import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:raghunathamhomes/constants/app_colors.dart';
import 'package:raghunathamhomes/features/banquet_halls/domain/entities/banquet_booking_entity.dart';
import 'package:raghunathamhomes/features/banquet_halls/presentation/bloc/banquet_booking_bloc.dart';
import 'package:raghunathamhomes/features/banquet_halls/presentation/bloc/banquet_booking_event.dart';
import 'package:raghunathamhomes/features/banquet_halls/presentation/bloc/banquet_booking_state.dart';
import 'package:raghunathamhomes/features/banquet_halls/presentation/pages/banquet_hall_detail_page.dart';
import 'package:raghunathamhomes/features/banquet_halls/presentation/widgets/static_banquet.dart';

import '../widgets/banquet_booking_sheet.dart';
import '../widgets/banquet_hall_card.dart';

class BanquetPage extends StatefulWidget {
  const BanquetPage({super.key});

  @override
  State<BanquetPage> createState() => _BanquetPageState();
}

class _BanquetPageState extends State<BanquetPage> {
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  void _loadAll() {
    context.read<BanquetBookingBloc>().add(LoadBanquetHallsEvent());
    final uid = _uid;
    if (uid != null) {
      context.read<BanquetBookingBloc>().add(LoadUserBanquetBookingsEvent(uid));
    }
  }

  Future<void> _onRefresh() async {
    _loadAll();
    await Future.delayed(const Duration(milliseconds: 350));
  }

  void _openBookingSheetTop(BuildContext context, hall) {
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
                borderRadius: BorderRadius.circular(18),
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
          position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  void _openBookingDetailsTop(BuildContext context, BanquetBookingEntity b) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Booking Details',
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.only(top: 80, left: 16, right: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowStrong,
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: _BookingDetailsCard(booking: b),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 280),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Banquet Halls', style: headingStyle.copyWith(fontSize: 24)),
      ),
      body: BlocBuilder<BanquetBookingBloc, BanquetBookingState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.accentGoldDark,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), // important for RefreshIndicator [web:86][web:90]
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _heroCard(),
                  const SizedBox(height: 20),

                  // Static halls
                  ...StaticBanquetHalls.halls.map(
                    (hall) => BanquetHallCard(
                      hall: hall,
                      onBook: () => _openBookingSheetTop(context, hall),
                      onViewDetails: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => BanquetHallDetailPage(hall: hall)),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Your Bookings', style: goldHeadingStyle.copyWith(fontSize: 22)),
                  ),
                  const SizedBox(height: 10),

                  if (_uid == null)
                    _emptyLuxuryBox(
                      title: 'Login required',
                      subtitle: 'Please login to view your bookings.',
                    )
                  else if (state.loading && state.bookings.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: CircularProgressIndicator(color: AppColors.accentGoldDark),
                    )
                  else if (state.bookings.isEmpty)
                    _emptyLuxuryBox(
                      title: 'No banquet bookings yet',
                      subtitle: 'Tap “Book” on any hall to create your first request.',
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.bookings.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final b = state.bookings[i];
                        return _BookingLuxuryTile(
                          booking: b,
                          onTap: () => _openBookingDetailsTop(context, b),
                        );
                      },
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _heroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.royalGoldGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: AppColors.shadowStrong, blurRadius: 18, spreadRadius: 2),
        ],
      ),
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
            'Two premium banquet halls · 100 guests each',
            style: bodyText.copyWith(color: AppColors.textWhite.withValues(alpha:0.92)),
          ),
        ],
      ),
    );
  }

  Widget _emptyLuxuryBox({required String title, required String subtitle}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surfaceDark),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 14, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: headingStyle.copyWith(fontSize: 18)),
          const SizedBox(height: 6),
          Text(subtitle, style: bodyText),
        ],
      ),
    );
  }
}

class _BookingLuxuryTile extends StatelessWidget {
  final BanquetBookingEntity booking;
  final VoidCallback onTap;

  const _BookingLuxuryTile({
    required this.booking,
    required this.onTap,
  });

  String _fmt(DateTime dt) => DateFormat('dd MMM yyyy, hh:mm a').format(dt);

  int _hours(DateTime start, DateTime end) {
    final minutes = end.difference(start).inMinutes;
    if (minutes <= 0) return 0;
    return (minutes / 60).ceil();
  }

  String _safe(String? v, {String fallback = '—'}) {
    final s = (v ?? '').trim();
    return s.isEmpty ? fallback : s;
  }

  Color _statusFg(BanquetBookingStatus status) {
    switch (status) {
      case BanquetBookingStatus.pending:
        return AppColors.accentGoldDark;
      case BanquetBookingStatus.confirmed:
        return Colors.green.shade700;
      case BanquetBookingStatus.rejected:
        return Colors.red.shade700;
      case BanquetBookingStatus.cancelled:
        return Colors.grey.shade700;
      case BanquetBookingStatus.refunded:
        return Colors.blue.shade700;
    }
  }

  Color _statusBg(BanquetBookingStatus status) => _statusFg(status).withValues(alpha:0.12);

  IconData _statusIcon(BanquetBookingStatus status) {
    switch (status) {
      case BanquetBookingStatus.pending:
        return Icons.hourglass_bottom_rounded;
      case BanquetBookingStatus.confirmed:
        return Icons.verified_rounded;
      case BanquetBookingStatus.rejected:
        return Icons.cancel_rounded;
      case BanquetBookingStatus.cancelled:
        return Icons.remove_circle_rounded;
      case BanquetBookingStatus.refunded:
        return Icons.currency_rupee_rounded;
    }
  }




  @override
  Widget build(BuildContext context) {
    final title = _safe(booking.eventTitle, fallback: 'Booking');
    final type = _safe(booking.eventType, fallback: 'Event');
    final duration = _hours(booking.start, booking.end);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.surfaceDark),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 14, spreadRadius: 1),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // left badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accentGoldDark,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.event_rounded, color: AppColors.textWhite),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: headingStyle.copyWith(fontSize: 18, color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text('$type • Guests: ${booking.guestsCount}', style: bodyText),
                  const SizedBox(height: 2),
                  Text('${_fmt(booking.start)} → ${_fmt(booking.end)}', style: captionText),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                          color: _statusBg(booking.status),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: _statusFg(booking.status).withValues(alpha:0.25)),
                        ),
                        child: Row(
                          children: [
                            Icon(_statusIcon(booking.status), size: 15, color: _statusFg(booking.status)),
                            const SizedBox(width: 6),
                            Text(
                              booking.status.name.toUpperCase(),
                              style: bodyText.copyWith(
                                color: _statusFg(booking.status),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '₹${booking.amount.toStringAsFixed(2)}',
                        style: headingStyle.copyWith(fontSize: 16, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Duration: $duration hour(s)', style: captionText),
                ],
              ),
            ),

            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: AppColors.textMuted.withValues(alpha:0.9)),
          ],
        ),
      ),
    );
  }
}

class _BookingDetailsCard extends StatelessWidget {
  final BanquetBookingEntity booking;
  const _BookingDetailsCard({required this.booking});

  String _fmt(DateTime dt) => DateFormat('dd MMM yyyy, hh:mm a').format(dt);

  int _hours(DateTime start, DateTime end) {
    final minutes = end.difference(start).inMinutes;
    if (minutes <= 0) return 0;
    return (minutes / 60).ceil();
  }

  String _safe(String? v, {String fallback = '—'}) {
    final s = (v ?? '').trim();
    return s.isEmpty ? fallback : s;
  }

  Color _statusFg(BanquetBookingStatus status) {
    switch (status) {
      case BanquetBookingStatus.pending:
        return AppColors.accentGoldDark;
      case BanquetBookingStatus.confirmed:
        return Colors.green.shade700;
      case BanquetBookingStatus.rejected:
        return Colors.red.shade700;
      case BanquetBookingStatus.cancelled:
        return Colors.grey.shade700;
      case BanquetBookingStatus.refunded:
        return Colors.blue.shade700;
    }
  }

  Color _statusBg(BanquetBookingStatus status) =>
      _statusFg(status).withValues(alpha:0.12);

  IconData _statusIcon(BanquetBookingStatus status) {
    switch (status) {
      case BanquetBookingStatus.pending:
        return Icons.hourglass_bottom_rounded;
      case BanquetBookingStatus.confirmed:
        return Icons.verified_rounded;
      case BanquetBookingStatus.rejected:
        return Icons.cancel_rounded;
      case BanquetBookingStatus.cancelled:
        return Icons.remove_circle_rounded;
      case BanquetBookingStatus.refunded:
        return Icons.currency_rupee_rounded;
    }
  }

  bool get _canCancel =>
      booking.status == BanquetBookingStatus.pending ||
      booking.status == BanquetBookingStatus.confirmed;

  Future<void> _confirmAndCancel(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Cancel booking?'),
          content: const Text(
              'This will cancel your booking request for this time slot.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Yes, cancel'),
            ),
          ],
        );
      },
    );

    if (shouldCancel != true) return;

    context
        .read<BanquetBookingBloc>()
        .add(CancelBanquetBookingEvent(booking.id, userId));

    Navigator.pop(context); // close the top popup after cancelling
  }

  @override
  Widget build(BuildContext context) {
    final title = _safe(booking.eventTitle, fallback: 'Booking');
    final type = _safe(booking.eventType);
    final notes = _safe(booking.eventNotes);
    final duration = _hours(booking.start, booking.end);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: goldHeadingStyle.copyWith(fontSize: 22),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: _statusBg(booking.status),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: _statusFg(booking.status).withValues(alpha:0.25),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _statusIcon(booking.status),
                    size: 16,
                    color: _statusFg(booking.status),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    booking.status.name.toUpperCase(),
                    style: bodyText.copyWith(
                      color: _statusFg(booking.status),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Text('Booking details', style: headingStyle.copyWith(fontSize: 16)),
        const SizedBox(height: 10),
        _row('Event type', type),
        _row('Guests', '${booking.guestsCount}'),
        _row('Start', _fmt(booking.start)),
        _row('End', _fmt(booking.end)),
        _row('Duration', '$duration hour(s)'),
        _row('Amount', '₹${booking.amount.toStringAsFixed(2)}'),

        const SizedBox(height: 14),
        Text('Notes', style: headingStyle.copyWith(fontSize: 16)),
        const SizedBox(height: 6),
        Text(notes, style: bodyText),

        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textWhite,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
            if (_canCancel) ...[
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => _confirmAndCancel(context),
                  icon: const Icon(Icons.cancel_rounded, size: 18),
                  label: const Text('Cancel'),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 96, child: Text(label, style: captionText)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: bodyText.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
