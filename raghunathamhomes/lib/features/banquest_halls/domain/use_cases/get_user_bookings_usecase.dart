// lib/domain/usecases/get_user_banquet_bookings.dart
import '../entities/banquet_booking_entity.dart';
import '../repositories/banquet_booking_repository.dart';

class GetUserBanquetBookingsUseCase{
  final BanquetBookingRepository repository;
  GetUserBanquetBookingsUseCase(this.repository);

  Future<List<BanquetBookingEntity>> call(String userId) =>
      repository.getUserBookings(userId);
}
