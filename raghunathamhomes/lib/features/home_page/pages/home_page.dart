import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raghunathamhomes/constants/app_colors.dart';
import 'package:raghunathamhomes/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:raghunathamhomes/features/authentication/presentation/bloc/auth_event.dart';
import 'package:raghunathamhomes/features/authentication/presentation/bloc/auth_state.dart';
import 'package:raghunathamhomes/features/authentication/presentation/pages/auth_screen.dart';
import 'package:raghunathamhomes/features/home_page/widgets/home_drawer.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // ⚡ Fetch current user immediately
    context.read<AuthBloc>().add(AuthCheckStatusRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => const AuthScreen()),
            (Route<dynamic> route) => false,
          );
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                iconTheme: IconThemeData(color: AppColors.primary),
                backgroundColor: AppColors.background,
                centerTitle: true,
                title: Text(
                  "Raghunatham Homes",
                  style: headingStyle,
                ),
              ),
              drawer: const HomeDrawer(),
              body: Center(
                child: state.user != null
                    ? Text(
                        "Welcome, ${state.user!.fullName}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            if (state.isLoading)
              Container(
                color: Colors.black.withValues(alpha:0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.accentGold),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
