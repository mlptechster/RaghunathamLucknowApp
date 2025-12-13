// lib/domain/usecases/get_hall_bookings_in_range.dart
import '../entities/banquet_booking_entity.dart';
import '../repositories/banquet_booking_repository.dart';

class GetHallBookingsInRangeUseCase{
  final BanquetBookingRepository repository;
  GetHallBookingsInRangeUseCase(this.repository);

  Future<List<BanquetBookingEntity>> call(
    String hallId,
    DateTime from,
    DateTime to,
  ) =>
      repository.getHallBookingsInRange(hallId, from, to);
}
