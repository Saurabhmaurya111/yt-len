import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_moment/core/theme/app_palette.dart';
import 'package:last_moment/features/auth/data/auth_service.dart';
import 'package:last_moment/features/auth/presentation/widgets/auth_layout.dart';
import 'package:last_moment/shared/widgets/custom_button.dart';
import 'package:last_moment/shared/widgets/custom_text_field.dart';
import 'package:last_moment/shared/widgets/square_tile.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> signUserUp() async {
    if (passwordController.text != confirmedPasswordController.text) {
      showErrorMessage("Passwords don't match. Please try again.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      await credential.user?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (mounted) showErrorMessage(_friendlyError(e.code));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _friendlyError(String code) {
    return switch (code) {
      'email-already-in-use' => 'An account already exists with this email.',
      'weak-password' => 'Password is too weak. Use at least 6 characters.',
      'invalid-email' => 'Please enter a valid email address.',
      _ => code.replaceAll('-', ' '),
    };
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 40),
        title: const Text('Sign up failed'),
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
      title: 'Create account',
      subtitle: 'Join Last Moment and unlock YouTube insights',
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
          const SizedBox(height: 14),
          CustomTextfiled(
            controller: confirmedPasswordController,
            hintText: 'Confirm password',
            obscureText: true,
            prefixIcon: Icons.lock_outline_rounded,
          ),
          const SizedBox(height: 20),
          CustomButton(text: 'Create Account', onTap: signUserUp, isLoading: _isLoading),
          const SizedBox(height: 28),
          const SocialDivider(label: 'Or sign up with'),
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
                'Already have an account?',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              TextButton(
                onPressed: widget.onTap,
                child: const Text('Sign in'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
