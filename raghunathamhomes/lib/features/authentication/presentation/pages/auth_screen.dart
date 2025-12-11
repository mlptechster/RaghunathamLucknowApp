// features/authentication/presentation/pages/auth_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raghunathamhomes/constants/app_colors.dart'; 
import 'package:raghunathamhomes/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:raghunathamhomes/features/authentication/presentation/bloc/auth_event.dart';
import 'package:raghunathamhomes/features/authentication/presentation/bloc/auth_state.dart';
import 'package:raghunathamhomes/features/home_page/pages/home_page.dart';

enum AuthFormType { login, signUp }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthFormType _formType = AuthFormType.login;
  bool _hasNavigated = false;

  void _toggleForm() {
    setState(() {
      _formType =
          _formType == AuthFormType.login ? AuthFormType.signUp : AuthFormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (_hasNavigated) return;

        // ✅ Navigation
        if (state.status == AuthStatus.authenticated) {
          _hasNavigated = true;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }

        if (state.status == AuthStatus.requiresEmailVerification) {
          _hasNavigated = true;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const VerificationScreen()),
          );
        }

        // ✅ Show messages
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red.shade700),
          );
        }

        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.successMessage!), backgroundColor: AppColors.accentGoldDark),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Image.asset("assets/logo2.png", height: 120),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: AppColors.shadowStrong, blurRadius: 20, offset: Offset(0, 8)),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _formType == AuthFormType.login
                        ? _LoginForm(key: const ValueKey('login'), toggleForm: _toggleForm)
                        : _SignUpForm(key: const ValueKey('signup'), toggleForm: _toggleForm),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ----------------------------------------------------
// FORM WIDGETS (Unchanged Logic)
// ----------------------------------------------------

class _LoginForm extends StatefulWidget {
  final VoidCallback toggleForm;
  const _LoginForm({super.key, required this.toggleForm});
  @override
  State<_LoginForm> createState() => _LoginFormState();
}
class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Welcome Back", style: headingStyle),
          const SizedBox(height: 8),
          Text("Sign in to continue your luxury shopping.", style: captionText),
          const SizedBox(height: 30),
          _buildTextFormField(
            controller: _emailController, label: "Email Address", icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          _buildTextFormField(
            controller: _passwordController, label: "Password", icon: Icons.lock_outline, obscureText: true,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _showForgotPasswordDialog(context),
              child: Text('Forgot Password?', style: bodyText.copyWith(color: AppColors.primaryLight, fontSize: 14)),
            ),
          ),
          const SizedBox(height: 30),
          _buildAuthButton(context, text: "LOG IN", onPressed: _submitLogin),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: widget.toggleForm,
              child: Text.rich(
                TextSpan(
                  text: "Don't have an account? ",
                  style: captionText.copyWith(color: AppColors.textSecondary),
                  children: [
                    TextSpan(text: "Sign Up", style: bodyText.copyWith(color: AppColors.accentGold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  final VoidCallback toggleForm;
  const _SignUpForm({super.key, required this.toggleForm});
  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}
class _SignUpFormState extends State<_SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _submitSignUp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthSignUpRequested(
              fullName: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              phoneNumber: _phoneController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Create Account", style: goldHeadingStyle),
          const SizedBox(height: 8),
          Text("Join us to unlock premium features.", style: captionText),
          const SizedBox(height: 30),
          _buildTextFormField(controller: _nameController, label: "Full Name", icon: Icons.person_outline),
          const SizedBox(height: 20),
          _buildTextFormField(controller: _emailController, label: "Email Address", icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 20),
          _buildTextFormField(controller: _phoneController, label: "Phone Number", icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
          const SizedBox(height: 20),
          _buildTextFormField(
            controller: _passwordController, label: "Password", icon: Icons.lock_outline, obscureText: true,
            validator: (value) {
              if (value == null || value.length < 8) {
                return 'Password must be at least 8 characters.';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          _buildAuthButton(context, text: "SIGN UP", onPressed: _submitSignUp),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: widget.toggleForm,
              child: Text.rich(
                TextSpan(
                  text: "Already a member? ",
                  style: captionText.copyWith(color: AppColors.textSecondary),
                  children: [
                    TextSpan(text: "Log In", style: bodyText.copyWith(color: AppColors.accentGold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// REUSABLE UI COMPONENTS (Unchanged)
// ----------------------------------------------------

Widget _buildTextFormField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    style: bodyText.copyWith(color: AppColors.textPrimary),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: captionText.copyWith(color: AppColors.textMuted),
      prefixIcon: Icon(icon, color: AppColors.primaryLight, size: 20),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.surfaceDark),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.accentGold, width: 2),
      ),
      errorStyle: captionText.copyWith(color: Colors.red),
    ),
    validator: validator ??
        (value) {
          if (value == null || value.isEmpty) {
            return 'This field cannot be empty.';
          }
          return null;
        },
  );
}

Widget _buildAuthButton(BuildContext context, {required String text, required VoidCallback onPressed}) {
  return BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) {
      return Container(
        margin: EdgeInsets.all(8),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha:0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          gradient: AppColors.royalGoldGradient,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: state.isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Center(
              child: state.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.textWhite,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      text,
                      style: bodyText.copyWith(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
            ),
          ),
        ),
      );
    },
  );
}

void _showForgotPasswordDialog(BuildContext context) {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Reset Password', style: headingStyle.copyWith(fontSize: 20)),
        content: Form(
          key: _formKey,
          child: _buildTextFormField(
            controller: emailController, label: 'Enter Email', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel', style: bodyText.copyWith(color: AppColors.textMuted)),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          _buildAuthButton(
            dialogContext,
            text: 'SEND LINK',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Dispatch event from the dialog's context
                context.read<AuthBloc>().add(
                      AuthForgotPasswordRequested(email: emailController.text.trim()),
                    );
                Navigator.of(dialogContext).pop();
              }
            },
          ),
        ],
      );
    },
  );
}



class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  Timer? _timer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    // 🔁 Check email verification every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      context.read<AuthBloc>().add(AuthCheckEmailVerificationRequested());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (_hasNavigated) return;

        if (state.status == AuthStatus.authenticated) {
          _hasNavigated = true;
          _timer?.cancel();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
        }

        if (state.status == AuthStatus.unauthenticated) {
          _hasNavigated = true;
          _timer?.cancel();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const AuthScreen()));
        }

        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: AppColors.accentGoldDark,
            ),
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
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Please check your inbox!",
                  style: goldHeadingStyle.copyWith(fontSize: 24),
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Text(
                context.read<AuthBloc>().state.user?.email ?? '',
                style: bodyText.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildAuthButton(context,
                  text: "Resend Verification Email",
                  onPressed: () {
                context.read<AuthBloc>().add(AuthResendVerificationEmailRequested());
              }),
              const SizedBox(height: 20),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthSignOutRequested());
                  },
                  child: Text('Return to Login',
                      style: bodyText.copyWith(color: AppColors.textMuted))),
            ],
          ),
        ),
      ),
    );
  }
}
