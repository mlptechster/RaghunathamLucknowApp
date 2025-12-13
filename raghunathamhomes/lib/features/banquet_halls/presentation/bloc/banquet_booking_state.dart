// lib/presentation/bloc/banquet/banquet_booking_state.dart
import 'package:equatable/equatable.dart';
import 'package:raghunathamhomes/features/banquet_halls/domain/entities/banquet_booking_entity.dart';
import 'package:raghunathamhomes/features/banquet_halls/domain/entities/banquet_hall_entity.dart';

class BanquetBookingState extends Equatable {
  final bool loading;
  final List<BanquetHallEntity> halls;
  final List<BanquetBookingEntity> bookings;
  final String? errorMessage;
  final bool bookingSuccess;

  const BanquetBookingState({
    this.loading = false,
    this.halls = const [],
    this.bookings = const [],
    this.errorMessage,
    this.bookingSuccess = false,
  });

  BanquetBookingState copyWith({
    bool? loading,
    List<BanquetHallEntity>? halls,
    List<BanquetBookingEntity>? bookings,
    String? errorMessage,
    bool? bookingSuccess,
  }) {
    return BanquetBookingState(
      loading: loading ?? this.loading,
      halls: halls ?? this.halls,
      bookings: bookings ?? this.bookings,
      errorMessage: errorMessage,
      bookingSuccess: bookingSuccess ?? false,
    );
  }

  @override
  List<Object?> get props =>
      [loading, halls, bookings, errorMessage, bookingSuccess];
}
