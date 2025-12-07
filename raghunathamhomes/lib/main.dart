import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raghunathamhomes/dependency_injection.dart';
import 'package:raghunathamhomes/dependency_injection.dart' as di;
import 'package:raghunathamhomes/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:raghunathamhomes/features/authentication/presentation/bloc/auth_event.dart';
import 'package:raghunathamhomes/features/splash/splash_screen.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()..add(AuthCheckStatusRequested()),),
      ],
      child: MaterialApp(
        home: SplashScreen(),
      ),
    );
  }
}