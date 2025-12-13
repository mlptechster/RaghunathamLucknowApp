// lib/presentation/bloc/banquet/banquet_booking_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raghunathamhomes/features/banquet_halls/domain/use_cases/cancel_booking_usecase.dart';
import 'package:raghunathamhomes/features/banquet_halls/domain/use_cases/create_banquet_booking_usecase.dart';
import 'package:raghunathamhomes/features/banquet_halls/domain/use_cases/get_banquet_halls_usecase.dart';
import 'package:raghunathamhomes/features/banquet_halls/domain/use_cases/get_user_bookings_usecase.dart';
import 'package:raghunathamhomes/utlis/exceptions/server_exception.dart';
import 'banquet_booking_event.dart';
import 'banquet_booking_state.dart';

class BanquetBookingBloc
    extends Bloc<BanquetBookingEvent, BanquetBookingState> {
  final GetBanquetHallsUseCase getBanquetHalls;
  final GetUserBanquetBookingsUseCase getUserBookings;
  final CreateBanquetBookingUseCase createBooking;
  final CancelBanquetBookingUseCase cancelBooking;

  BanquetBookingBloc({
    required this.getBanquetHalls,
    required this.getUserBookings,
    required this.createBooking,
    required this.cancelBooking,
  }) : super(const BanquetBookingState()) {
    on<LoadBanquetHallsEvent>(_onLoadHalls);
    on<LoadUserBanquetBookingsEvent>(_onLoadUserBookings);
    on<CreateBanquetBookingEvent>(_onCreateBooking);
    on<CancelBanquetBookingEvent>(_onCancelBooking);
  }

  Future<void> _onLoadHalls(
      LoadBanquetHallsEvent event, Emitter<BanquetBookingState> emit) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final halls = await getBanquetHalls();
      emit(state.copyWith(loading: false, halls: halls));
    } on ServerException catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadUserBookings(LoadUserBanquetBookingsEvent event,
      Emitter<BanquetBookingState> emit) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final bookings = await getUserBookings(event.userId);
      emit(state.copyWith(loading: false, bookings: bookings));
    } on ServerException catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onCreateBooking(
  CreateBanquetBookingEvent event,
  Emitter<BanquetBookingState> emit,
) async {
  emit(state.copyWith(
    loading: true,
    errorMessage: null,
    bookingSuccess: false,
  ));

  try {
    await createBooking(event.booking);

    final updated =
        await getUserBookings(event.booking.userId);

    emit(state.copyWith(
      loading: false,
      bookings: updated,
      bookingSuccess: true, // ✅ SUCCESS FLAG
    ));
  } on ServerException catch (e) {
    emit(state.copyWith(
      loading: false,
      errorMessage: e.message,
    ));
  } catch (e) {
    emit(state.copyWith(
      loading: false,
      errorMessage: e.toString(),
    ));
  }
}


  Future<void> _onCancelBooking(CancelBanquetBookingEvent event,
      Emitter<BanquetBookingState> emit) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      await cancelBooking(bookingId: event.bookingId, userId: event.userId);
      final updated = await getUserBookings(event.userId);
      emit(state.copyWith(loading: false, bookings: updated));
    } on ServerException catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
