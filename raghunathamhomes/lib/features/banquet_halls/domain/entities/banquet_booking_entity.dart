// lib/domain/entities/banquet_booking_entity.dart
enum BanquetBookingStatus { pending, confirmed, cancelled, refunded , rejected }

class BanquetBookingEntity {
  final String id;         // booking id
  final String hallId;     // ref to BanquetHallEntity.id
  final String userId;
  final DateTime start;
  final DateTime end;
  final int guestsCount;
  final BanquetBookingStatus status;
  final double amount;
  final String? eventTitle;       // e.g. "Wedding Reception"
  final String? eventType;        // e.g. "Wedding"
  final String? eventNotes;       // special requirements
  final DateTime createdAt;

  const BanquetBookingEntity({
    required this.id,
    required this.hallId,
    required this.userId,
    required this.start,
    required this.end,
    required this.guestsCount,
    required this.status,
    required this.amount,
    this.eventTitle,
    this.eventType,
    this.eventNotes,
    required this.createdAt,
  });
}
