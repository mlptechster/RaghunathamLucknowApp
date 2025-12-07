class UserEntity {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? profileImageUrl; 
  final List<AddressEntity> addresses; 
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    this.addresses = const [],
    this.role = 'customer',
    required this.createdAt,
    required this.updatedAt,
  });


  UserEntity copyWith({
  String? id,
  String? fullName,
  String? email,
  String? phoneNumber,
  String? profileImageUrl,
  List<AddressEntity>? addresses,
  String? role,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return UserEntity(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    addresses: addresses ?? this.addresses,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
}


class AddressEntity {
  final String id;
  final String userId; 
  final String label; 
  final String street;
  final String city;
  final String state;
  final String country;
  final String pinCode;
  final bool isDefault;

  const AddressEntity({
    required this.id,
    required this.userId,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.pinCode,
    this.isDefault = false,
  });
}