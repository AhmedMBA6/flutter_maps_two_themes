import 'package:flutter/material.dart';
import '../../../constants/themes/app_colors.dart';

class PasswordFormField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const PasswordFormField({
    required this.label, 
    this.hintText,
    this.controller,
    this.validator,
    super.key,
  });

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.gray900,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscure,
          validator: widget.validator,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock_outline,
              color: isDark ? Colors.white70 : AppColors.gray500,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: isDark ? Colors.white70 : AppColors.gray500,
                size: 20,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
            hintText: widget.hintText ?? "Enter your password",
            hintStyle: TextStyle(
              color: isDark ? Colors.white54 : AppColors.gray400,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: isDark ? AppColors.gray600 : AppColors.gray100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: isDark ? Colors.white : AppColors.gray900,
          ),
        ),
      ],
    );
  }
}

