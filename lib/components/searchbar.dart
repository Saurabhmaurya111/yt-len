
import 'package:flutter/material.dart';

class CusotomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  
  const CusotomSearchBar({
    super.key, required this.hint, required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(30),
        ),
        border: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(30),
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}