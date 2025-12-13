// lib/presentation/bloc/banquet/banquet_booking_event.dart
import 'package:equatable/equatable.dart';
import 'package:raghunathamhomes/features/banquet_halls/domain/entities/banquet_booking_entity.dart';

abstract class BanquetBookingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadBanquetHallsEvent extends BanquetBookingEvent {}

class LoadUserBanquetBookingsEvent extends BanquetBookingEvent {
  final String userId;
  LoadUserBanquetBookingsEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}

class CreateBanquetBookingEvent extends BanquetBookingEvent {
  final BanquetBookingEntity booking;
  CreateBanquetBookingEvent(this.booking);
  @override
  List<Object?> get props => [booking];
}

class CancelBanquetBookingEvent extends BanquetBookingEvent {
  final String bookingId;
  final String userId;
  CancelBanquetBookingEvent(this.bookingId, this.userId);
  @override
  List<Object?> get props => [bookingId, userId];
}
