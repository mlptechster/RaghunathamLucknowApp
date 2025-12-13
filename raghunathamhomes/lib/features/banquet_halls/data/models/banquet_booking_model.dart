// lib/data/models/banquet_booking_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/banquet_booking_entity.dart';

class BanquetBookingModel extends BanquetBookingEntity {
  const BanquetBookingModel({
    required super.id,
    required super.hallId,
    required super.userId,
    required super.start,
    required super.end,
    required super.guestsCount,
    required super.status,
    required super.amount,
    super.eventTitle,
    super.eventType,
    super.eventNotes,
    required super.createdAt,
  });

  factory BanquetBookingModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final statusStr = (data['status'] ?? 'pending') as String;
    final status = BanquetBookingStatus.values.firstWhere(
      (e) => e.name == statusStr,
      orElse: () => BanquetBookingStatus.pending,
    );

    return BanquetBookingModel(
      id: doc.id,
      hallId: data['hallId'],
      userId: data['userId'],
      start: (data['start'] as Timestamp).toDate(),
      end: (data['end'] as Timestamp).toDate(),
      guestsCount: data['guestsCount'] ?? 0,
      status: status,
      amount: (data['amount'] ?? 0).toDouble(),
      eventTitle: data['eventTitle'],
      eventType: data['eventType'],
      eventNotes: data['eventNotes'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'hallId': hallId,
        'userId': userId,
        'start': Timestamp.fromDate(start),
        'end': Timestamp.fromDate(end),
        'guestsCount': guestsCount,
        'status': status.name,
        'amount': amount,
        'eventTitle': eventTitle,
        'eventType': eventType,
        'eventNotes': eventNotes,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': FieldValue.serverTimestamp(),
      };
}
