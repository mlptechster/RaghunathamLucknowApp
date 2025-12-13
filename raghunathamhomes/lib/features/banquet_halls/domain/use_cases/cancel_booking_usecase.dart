// lib/domain/usecases/cancel_banquet_booking.dart
import '../repositories/banquet_booking_repository.dart';

class CancelBanquetBookingUseCase{
  final BanquetBookingRepository repository;
  CancelBanquetBookingUseCase(this.repository);

  Future<void> call({
    required String bookingId,
    required String userId,
  }) =>
      repository.cancelBooking(bookingId: bookingId, userId: userId);
}
