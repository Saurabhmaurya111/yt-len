import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_moment/features/auth/data/auth_service.dart';
import 'package:last_moment/features/auth/presentation/email_verification_page.dart';
import 'package:last_moment/features/auth/presentation/login_or_register_page.dart';
import 'package:last_moment/features/home/presentation/home_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          if (user == null) {
            return const LoginOrRegisterPage();
          }

          if (_authService.needsEmailVerification(user)) {
            return EmailVerificationPage(user: user);
          }

          return const HomeScreen();
        },
      ),
    );
  }
}
