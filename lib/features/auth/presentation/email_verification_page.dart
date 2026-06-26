import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_moment/core/theme/app_palette.dart';
import 'package:last_moment/features/auth/data/auth_service.dart';
import 'package:last_moment/features/auth/presentation/widgets/auth_layout.dart';
import 'package:last_moment/shared/widgets/custom_button.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key, required this.user});

  final User user;

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final AuthService _authService = AuthService();
  bool _isResending = false;
  bool _isChecking = false;
  String? _message;

  Future<void> _resendVerificationEmail() async {
    setState(() {
      _isResending = true;
      _message = null;
    });

    try {
      await _authService.sendEmailVerification();
      if (mounted) {
        setState(() {
          _message = 'Verification email sent. Check your inbox.';
        });
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _message = _friendlyError(e.code);
        });
      }
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  Future<void> _checkVerification() async {
    setState(() {
      _isChecking = true;
      _message = null;
    });

    try {
      final verified = await _authService.reloadAndCheckEmailVerified();
      if (!mounted) return;

      if (verified) {
        setState(() {
          _message = 'Email verified! Redirecting...';
        });
      } else {
        setState(() {
          _message = 'Email not verified yet. Open the link in your inbox first.';
        });
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _message = _friendlyError(e.code);
        });
      }
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  String _friendlyError(String code) {
    return switch (code) {
      'too-many-requests' => 'Too many attempts. Please wait a few minutes.',
      _ => code.replaceAll('-', ' '),
    };
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.user.email ?? 'your email';

    return AuthScaffold(
      title: 'Verify your email',
      subtitle: 'We sent a verification link to $email',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.mark_email_unread_outlined,
            size: 48,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Open the link in the email to activate your account, then tap the button below.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, height: 1.4),
          ),
          if (_message != null) ...[
            const SizedBox(height: 16),
            Text(
              _message!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _message!.contains('verified')
                    ? AppColors.success
                    : AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 24),
          CustomButton(
            text: "I've verified my email",
            onTap: _checkVerification,
            isLoading: _isChecking,
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Resend verification email',
            onTap: _resendVerificationEmail,
            isLoading: _isResending,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _authService.signOut,
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
