import 'package:flutter/material.dart';

class CTOnboardingTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  const CTOnboardingTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1F2937),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 17),

        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, color: const Color(0xFF9CA3AF), size: 22),

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 20,
        ),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.2),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF6C4CF5), width: 2),
        ),
      ),
    );
  }
}
