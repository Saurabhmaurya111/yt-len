import 'package:flutter/material.dart';
import 'package:last_moment/core/theme/app_palette.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.hint,
    required this.controller,
    this.label,
    this.prefixIcon = Icons.link_rounded,
  });

  final TextEditingController controller;
  final String hint;
  final String? label;
  final IconData prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(prefixIcon, color: AppColors.textSecondary, size: 22),
          ),
        ),
      ],
    );
  }
}
