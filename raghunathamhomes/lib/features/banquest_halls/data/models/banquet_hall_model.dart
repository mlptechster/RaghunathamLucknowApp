// lib/data/models/banquet_hall_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/banquet_hall_entity.dart';

class BanquetHallModel extends BanquetHallEntity {
  const BanquetHallModel({
    required super.id,
    required super.name,
    required super.capacity,
    required super.hourlyRate,
    required super.images,
    required super.description,
  });

  factory BanquetHallModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BanquetHallModel(
      id: doc.id,
      name: data['name'] ?? '',
      capacity: data['capacity'] ?? 0,
      hourlyRate: (data['hourlyRate'] ?? 0).toDouble(),
      images: List<String>.from(data['images'] ?? []),
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'capacity': capacity,
        'hourlyRate': hourlyRate,
        'images': images,
        'description': description,
      };
}
