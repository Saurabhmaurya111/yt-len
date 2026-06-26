import 'package:flutter/material.dart';
import 'package:last_moment/core/theme/app_palette.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_rounded,
            size: 14,
            color: AppColors.accent.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 6),
          const Text(
            'Made with love by Saurabh Maurya',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
