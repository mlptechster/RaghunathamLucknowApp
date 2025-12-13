
class BanquetHallEntity {
  final String id;           // e.g. hall_1, hall_2
  final String name;         // e.g. "Royal Hall"
  final int capacity;        // 100
  final double hourlyRate;   // price per hour
  final List<String> images;
  final String description;

  const BanquetHallEntity({
    required this.id,
    required this.name,
    required this.capacity,
    required this.hourlyRate,
    required this.images,
    required this.description,
  });
}
