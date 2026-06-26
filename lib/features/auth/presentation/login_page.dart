import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_moment/core/theme/app_palette.dart';
import 'package:last_moment/features/auth/data/auth_service.dart';
import 'package:last_moment/features/auth/presentation/widgets/auth_layout.dart';
import 'package:last_moment/shared/widgets/custom_button.dart';
import 'package:last_moment/shared/widgets/custom_text_field.dart';
import 'package:last_moment/shared/widgets/square_tile.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> signUserIn() async {
    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) showErrorMessage(_friendlyError(e.code));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _friendlyError(String code) {
    return switch (code) {
      'user-not-found' => 'No account found with this email.',
      'wrong-password' => 'Incorrect password. Please try again.',
      'invalid-email' => 'Please enter a valid email address.',
      'invalid-credential' => 'Invalid email or password.',
      _ => code.replaceAll('-', ' '),
    };
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 40),
        title: const Text('Sign in failed'),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Welcome back',
      subtitle: 'Sign in to access your YouTube tools',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextfiled(
            controller: emailController,
            hintText: 'Email address',
            obscureText: false,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: 14),
          CustomTextfiled(
            controller: passwordController,
            hintText: 'Password',
            obscureText: true,
            prefixIcon: Icons.lock_outline_rounded,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Forgot password?'),
            ),
          ),
          const SizedBox(height: 8),
          CustomButton(text: 'Sign In', onTap: signUserIn, isLoading: _isLoading),
          const SizedBox(height: 28),
          const SocialDivider(label: 'Or continue with'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SquareTile(
                onTap: () => AuthService().signInWithGoogle(),
                imagePath: 'assets/google.png',
                label: 'Google',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account?",
                style: TextStyle(color: AppColors.textSecondary),
              ),
              TextButton(
                onPressed: widget.onTap,
                child: const Text('Sign up'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
