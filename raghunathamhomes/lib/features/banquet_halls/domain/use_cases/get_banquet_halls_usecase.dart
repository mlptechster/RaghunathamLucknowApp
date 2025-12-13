// lib/domain/usecases/get_banquet_halls.dart
import '../entities/banquet_hall_entity.dart';
import '../repositories/banquet_booking_repository.dart';

class GetBanquetHallsUseCase{
  final BanquetBookingRepository repository;
  GetBanquetHallsUseCase(this.repository);

  Future<List<BanquetHallEntity>> call() => repository.getBanquetHalls();
}
