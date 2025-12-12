// lib/data/repositories/banquet_booking_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raghunathamhomes/utlis/exceptions/server_exception.dart';
import '../../domain/entities/banquet_hall_entity.dart';
import '../../domain/entities/banquet_booking_entity.dart';
import '../../domain/repositories/banquet_booking_repository.dart';
import '../models/banquet_hall_model.dart';
import '../models/banquet_booking_model.dart';

class BanquetBookingRepositoryImpl implements BanquetBookingRepository {
  final FirebaseFirestore _firestore;

  BanquetBookingRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _hallsRef => _firestore.collection('banquet_halls');
  CollectionReference get _bookingsRef =>
      _firestore.collection('banquet_bookings');

  @override
  Future<List<BanquetHallEntity>> getBanquetHalls() async {
    try {
      final snap = await _hallsRef.get();
      return snap.docs.map((d) => BanquetHallModel.fromDoc(d)).toList();
    } on FirebaseException catch (e, st) {
      throw ServerException(
        e.message ?? 'Failed to load halls',
        code: e.code,
        stackTrace: st,
      );
    }
  }

  @override
  Future<BanquetHallEntity> getBanquetHallById(String hallId) async {
    try {
      final doc = await _hallsRef.doc(hallId).get();
      if (!doc.exists) {
        throw ServerException('Hall not found', code: 'not-found');
      }
      return BanquetHallModel.fromDoc(doc);
    } on ServerException {
      rethrow;
    } on FirebaseException catch (e, st) {
      throw ServerException(
        e.message ?? 'Failed to load hall',
        code: e.code,
        stackTrace: st,
      );
    }
  }

  @override
  Future<String> createBooking(BanquetBookingEntity booking) async {
    try {
      final newRef = _bookingsRef.doc();
      await _firestore.runTransaction((tx) async {
        final existingSnap = await _bookingsRef
            .where('hallId', isEqualTo: booking.hallId)
            .where('status', whereIn: ['pending', 'confirmed'])
            .get();

        for (final d in existingSnap.docs) {
          final existing = BanquetBookingModel.fromDoc(d);
          final overlap = booking.start.isBefore(existing.end) &&
              booking.end.isAfter(existing.start);
          if (overlap) {
            throw const ServerException(
              'Selected slot conflicts with an existing booking',
              code: 'conflict',
            );
          }
        }

        final model = BanquetBookingModel(
          id: newRef.id,
          hallId: booking.hallId,
          userId: booking.userId,
          start: booking.start,
          end: booking.end,
          guestsCount: booking.guestsCount,
          status: booking.status,
          amount: booking.amount,
          eventTitle: booking.eventTitle,
          eventType: booking.eventType,
          eventNotes: booking.eventNotes,
          createdAt: DateTime.now(),
        );

        tx.set(newRef, model.toMap());
      });

      return newRef.id;
    } on ServerException {
      rethrow;
    } on FirebaseException catch (e, st) {
      throw ServerException(
        e.message ?? 'Failed to create booking',
        code: e.code,
        stackTrace: st,
      );
    }
  }

  @override
  Future<List<BanquetBookingEntity>> getUserBookings(String userId) async {
    try {
      final snap = await _bookingsRef
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snap.docs.map((d) => BanquetBookingModel.fromDoc(d)).toList();
    } on FirebaseException catch (e, st) {
      throw ServerException(
        e.message ?? 'Failed to load user bookings',
        code: e.code,
        stackTrace: st,
      );
    }
  }

  @override
  Future<List<BanquetBookingEntity>> getHallBookingsInRange(
    String hallId,
    DateTime from,
    DateTime to,
  ) async {
    try {
      final snap = await _bookingsRef
          .where('hallId', isEqualTo: hallId)
          .where('status', whereIn: ['pending', 'confirmed'])
          .get();
      final all = snap.docs.map((d) => BanquetBookingModel.fromDoc(d)).toList();
      return all.where((b) => b.start.isBefore(to) && b.end.isAfter(from)).toList();
    } on FirebaseException catch (e, st) {
      throw ServerException(
        e.message ?? 'Failed to load hall bookings',
        code: e.code,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> cancelBooking({
    required String bookingId,
    required String userId,
  }) async {
    try {
      final docRef = _bookingsRef.doc(bookingId);
      await _firestore.runTransaction((tx) async {
        final snap = await tx.get(docRef);
        if (!snap.exists) {
          throw const ServerException('Booking not found', code: 'not-found');
        }
        final booking = BanquetBookingModel.fromDoc(snap);
        if (booking.userId != userId) {
          throw const ServerException('Not authorized', code: 'unauthorized');
        }
        if (booking.status == BanquetBookingStatus.cancelled ||
            booking.status == BanquetBookingStatus.refunded) {
          throw const ServerException(
            'Already cancelled or refunded',
            code: 'already-updated',
          );
        }
        tx.update(docRef, {
          'status': BanquetBookingStatus.cancelled.name,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } on ServerException {
      rethrow;
    } on FirebaseException catch (e, st) {
      throw ServerException(
        e.message ?? 'Failed to cancel booking',
        code: e.code,
        stackTrace: st,
      );
    }
  }
}
