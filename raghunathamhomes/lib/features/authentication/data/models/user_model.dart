

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raghunathamhomes/features/authentication/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    super.profileImageUrl,
    super.addresses = const [],
    super.role = 'customer',
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
  // normalize keys if your Firestore sometimes uses different keys
  final id = json['id'] ?? json['uid'] ?? json['userId'] ?? '';
  final fullName = json['full_name'] ?? json['fullName'] ?? json['name'] ?? 'Unnamed User';
  final email = json['email'] ?? json['user_email'] ?? '';
  final phone = json['phone_number'] ?? json['phoneNumber'] ?? '';
  final profileImageUrl = json['profile_image_url'] ??
      json['profileImageUrl'] ??
      json['avatar'] ??
      '';

  final addressesRaw = json['addresses'] ?? [];
final addresses = (addressesRaw is List)
    ? addressesRaw.map((e) => AddressModel.fromJson(Map<String, dynamic>.from(e))).toList()
    : <AddressModel>[];


  final createdAtRaw = json['created_at'] ?? json['createdAt'] ?? json['created'];
  final updatedAtRaw = json['updated_at'] ?? json['updatedAt'] ?? json['updated'];

  DateTime parseDate(dynamic v) {
    if (v == null) return DateTime.now();
    if (v is DateTime) return v;
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
    return DateTime.now();
  }

  return UserModel(
    id: id,
    fullName: fullName,
    email: email,
    phoneNumber: phone,
    profileImageUrl: profileImageUrl,
    addresses: addresses,
    role: json['role'] ?? 'customer',
    createdAt: parseDate(createdAtRaw),
    updatedAt: parseDate(updatedAtRaw),
  );
}


  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'profileImageUrl': profileImageUrl,
        'addresses': addresses.map((e) => (e as AddressModel).toJson()).toList(),
        'role': role,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}


class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.userId,
    required super.label,
    required super.street,
    required super.city,
    required super.state,
    required super.country,
    required super.pinCode,
    super.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
  return AddressModel(
    id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
    userId: json['user_id'] ?? '',
    label: json['label'] ?? '',       
    street: json['street'] ?? '',
    city: json['city'] ?? '',
    state: json['state'] ?? '',
    country: json['country'] ?? '',
    pinCode: json['pin_code'] ?? '',
    isDefault: json['is_default'] ?? false,
  );
}


  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'label': label,
        'street': street,
        'city': city,
        'state': state,
        'country': country,
        'pin_code': pinCode,
        'is_default': isDefault,
      };
}