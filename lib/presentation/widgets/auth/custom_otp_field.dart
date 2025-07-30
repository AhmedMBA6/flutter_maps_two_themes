import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/themes/app_colors.dart';
import '../../../constants/themes/app_text_styles.dart';

class CustomOtpField extends StatefulWidget {
  final int length;
  final Function(String) onChanged;
  final Function(String)? onCompleted;
  final bool autoFocus;
  final TextStyle? textStyle;
  final double fieldWidth;
  final double fieldHeight;
  final double spacing;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? selectedColor;
  final double borderRadius;
  final double borderWidth;
  final bool hasError;

  const CustomOtpField({
    super.key,
    this.length = 6,
    required this.onChanged,
    this.onCompleted,
    this.autoFocus = true,
    this.textStyle,
    this.fieldWidth = 45,
    this.fieldHeight = 56,
    this.spacing = 4,
    this.activeColor,
    this.inactiveColor,
    this.selectedColor,
    this.borderRadius = 12,
    this.borderWidth = 1.5,
    this.hasError = false,
  });

  @override
  State<CustomOtpField> createState() => _CustomOtpFieldState();
}

class _CustomOtpFieldState extends State<CustomOtpField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<String> _otpValues;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (index) => FocusNode(),
    );
    _otpValues = List.filled(widget.length, '');
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length > 1) {
      value = value[value.length - 1];
    }

    setState(() {
      _otpValues[index] = value;
    });

    // Move to next field
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    // Move to previous field on backspace
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    final otp = _otpValues.join();
    widget.onChanged(otp);

    if (otp.length == widget.length) {
      widget.onCompleted?.call(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;

    // Colors based on design
    final activeColor = widget.activeColor ?? AppColors.primary;
    final inactiveColor = widget.hasError 
        ? AppColors.error 
        : (widget.inactiveColor ?? (isDark ? Colors.white24 : AppColors.gray300));
    final selectedColor = widget.selectedColor ?? AppColors.primary;
    final cursorColor = isDark ? Colors.white : AppColors.gray900;
    final textColor = isDark ? Colors.white : AppColors.gray900;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available width and adjust field size accordingly
        final availableWidth = constraints.maxWidth;
        final totalSpacing = (widget.length - 1) * widget.spacing;
        final fieldWidth = (availableWidth - totalSpacing - 8) / widget.length; // Added safety margin
        
                 return Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: List.generate(
             widget.length,
             (index) => SizedBox(
               width: fieldWidth,
               height: widget.fieldHeight,
               child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                cursorColor: cursorColor,
                cursorWidth: 2,
                cursorHeight: 24,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1),
                ],
                style: widget.textStyle ?? AppTextStyles.otpField.copyWith(
                  color: textColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? AppColors.gray700 : AppColors.gray100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide(
                      color: inactiveColor,
                      width: widget.borderWidth,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide(
                      color: inactiveColor,
                      width: widget.borderWidth,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide(
                      color: _otpValues[index].isNotEmpty ? selectedColor : activeColor,
                      width: widget.borderWidth,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) => _onOtpChanged(value, index),
                onTap: () {
                  setState(() {});
                },
              ),
            ),
          ),
        );
      },
    );
  }
} 