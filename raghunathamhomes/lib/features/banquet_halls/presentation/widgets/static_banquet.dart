// lib/features/banquet_halls/data/static_halls.dart
import '../../domain/entities/banquet_hall_entity.dart';

class StaticBanquetHalls {
  static const List<BanquetHallEntity> halls = [
    BanquetHallEntity(
      id: 'hall_1',
      name: 'Royal Hall',
      capacity: 100,
      hourlyRate: 5000,
      images: ['assets/hall_1.jpg','assets/hall_1a.jpg'],
      description: 'Perfect for weddings & receptions',
    ),
    BanquetHallEntity(
      id: 'hall_2',
      name: 'Imperial Hall',
      capacity: 100,
      hourlyRate: 6000,
      images: ['assets/hall_2.jpg','assets/hall_2a.jpg'],
      description: 'Ideal for corporate & premium events',
    ),
  ];
}
