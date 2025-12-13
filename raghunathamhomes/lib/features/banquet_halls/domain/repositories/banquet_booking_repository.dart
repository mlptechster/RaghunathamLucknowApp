// lib/domain/repositories/banquet_booking_repository.dart
import '../entities/banquet_hall_entity.dart';
import '../entities/banquet_booking_entity.dart';

abstract class BanquetBookingRepository {
  // Halls
  Future<List<BanquetHallEntity>> getBanquetHalls();
  Future<BanquetHallEntity> getBanquetHallById(String hallId);

  // Bookings
  Future<String> createBooking(BanquetBookingEntity booking);
  Future<List<BanquetBookingEntity>> getUserBookings(String userId);
  Future<List<BanquetBookingEntity>> getHallBookingsInRange(
    String hallId,
    DateTime from,
    DateTime to,
  );
  Future<void> cancelBooking({
    required String bookingId,
    required String userId,
  });
}
