// lib/init_di.dart or lib/service_locator.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Adjust path
import 'package:get_it/get_it.dart';
import 'package:raghunathamhomes/features/authentication/data/repositories/auth_reposiotry_impl.dart';
import 'package:raghunathamhomes/features/authentication/domain/repositories/auth_repository.dart';
import 'package:raghunathamhomes/features/authentication/domain/use_cases/forgot_password_use_case.dart';
import 'package:raghunathamhomes/features/authentication/domain/use_cases/get_current_user_use_case.dart';
import 'package:raghunathamhomes/features/authentication/domain/use_cases/log_out_use_case.dart';
import 'package:raghunathamhomes/features/authentication/domain/use_cases/login_use_case.dart';
import 'package:raghunathamhomes/features/authentication/domain/use_cases/resend_verification_email_use_case.dart';
import 'package:raghunathamhomes/features/authentication/domain/use_cases/sign_up_use_case.dart';
import 'package:raghunathamhomes/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:raghunathamhomes/features/banquet_halls/data/repositories/banquet_booking_repsitory_impl.dart';
import 'package:raghunathamhomes/features/banquet_halls/domain/repositories/banquet_booking_repository.dart';
import 'package:raghunathamhomes/features/banquet_halls/domain/use_cases/cancel_booking_usecase.dart';
import 'package:raghunathamhomes/features/banquet_halls/domain/use_cases/create_banquet_booking_usecase.dart';
import 'package:raghunathamhomes/features/banquet_halls/domain/use_cases/get_banquet_halls_usecase.dart';
import 'package:raghunathamhomes/features/banquet_halls/domain/use_cases/get_hall_booking_in_range_usecase.dart';
import 'package:raghunathamhomes/features/banquet_halls/domain/use_cases/get_user_bookings_usecase.dart';
import 'package:raghunathamhomes/features/banquet_halls/presentation/bloc/banquet_booking_bloc.dart';
// Note: Ensure all your UseCase, Repository, and BLoC files are imported correctly

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> init() async {
  // ----------------------------------------------------------------------
  // 📚 1. Presentation Layer (BLoC/Cubit)
  // ----------------------------------------------------------------------

  // We register the AuthBloc as a Factory because BLoCs contain mutable state
  // and should be instantiated fresh every time they are requested (e.g., via BlocProvider).
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        signUpUseCase: sl(),
        signOutUserUseCase: sl(),
        getCurrentUserUseCase: sl(),
        forgotPasswordUseCase: sl(),
        resendEmailVerificationUseCase: sl(),
      ));

  // ----------------------------------------------------------------------
  // 🌐 2. Domain Layer (Use Cases)
  // ----------------------------------------------------------------------

  // Register Use Cases as Lazily Singletons (or Factories if they had runtime arguments)
  // LazySingleton means it's created once, but only when first requested.

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUserUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ResendEmailVerificationUseCase(sl()));

  // ----------------------------------------------------------------------
  // 💾 3. Data Layer (Repositories)
  // ----------------------------------------------------------------------

  // Register the concrete implementation against its abstract interface.
  sl.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(),
  );

  // ----------------------------------------------------------------------
  // 🔌 4. External Dependencies
  // ----------------------------------------------------------------------

  // Register Firebase instances as Singletons (they are inherently singletons)
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);




  //------------------------------Banquet System----------------------------------------------
  // Banquet BLoC
  sl.registerFactory(
    () => BanquetBookingBloc(
      getBanquetHalls: sl(),
      getUserBookings: sl(),
      createBooking: sl(),
      cancelBooking: sl(),
    ),
  );



  // Banquet use cases
  sl.registerLazySingleton(() => GetBanquetHallsUseCase(sl()));
  sl.registerLazySingleton(() => GetUserBanquetBookingsUseCase(sl()));
  sl.registerLazySingleton(() => GetHallBookingsInRangeUseCase(sl()));
  sl.registerLazySingleton(() => CreateBanquetBookingUseCase(sl()));
  sl.registerLazySingleton(() => CancelBanquetBookingUseCase(sl()));
  
  // Banquet repository
  sl.registerLazySingleton<BanquetBookingRepository>(
    () => BanquetBookingRepositoryImpl(
      firestore: sl<FirebaseFirestore>(),
      auth: sl<FirebaseAuth>(),
    ),
  );
}