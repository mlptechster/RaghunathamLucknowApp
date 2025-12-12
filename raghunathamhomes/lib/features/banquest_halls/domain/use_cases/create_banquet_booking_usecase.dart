// lib/domain/usecases/create_banquet_booking.dart
import '../entities/banquet_booking_entity.dart';
import '../repositories/banquet_booking_repository.dart';

class CreateBanquetBookingUseCase{
  final BanquetBookingRepository repository;
  CreateBanquetBookingUseCase(this.repository);

  Future<String> call(BanquetBookingEntity booking) async {
    if (booking.start.isBefore(DateTime.now())) {
      throw Exception('Start time must be in the future');
    }
    if (booking.end.isBefore(booking.start)) {
      throw Exception('End time must be after start time');
    }
    return repository.createBooking(booking);
  }
}
