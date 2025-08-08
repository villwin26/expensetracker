import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Custom text field widget optimized for registration form with validation
/// Provides consistent styling and behavior across all form inputs
class CustomTextFieldWidget extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? errorText;
  final bool isPassword;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final int? maxLines;
  final TextCapitalization textCapitalization;

  const CustomTextFieldWidget({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.errorText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget>
    with SingleTickerProviderStateMixin {
  bool _obscureText = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget _buildPasswordToggle() {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          key: ValueKey(_obscureText),
          color: _isFocused
              ? AppTheme.lightTheme.primaryColor
              : AppTheme.textSecondaryLight,
          size: 5.w,
        ),
      ),
      onPressed: _togglePasswordVisibility,
      splashRadius: 6.w,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 2.w),
            child: Text(
              widget.label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        // Text Field
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.w),
            boxShadow: [
              if (_isFocused)
                BoxShadow(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : false,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled,
            maxLines: widget.maxLines,
            textCapitalization: widget.textCapitalization,
            onChanged: widget.onChanged,
            validator: widget.validator,
            onTap: () {
              setState(() {
                _isFocused = true;
              });
              _animationController.forward();
            },
            onFieldSubmitted: (_) {
              setState(() {
                _isFocused = false;
              });
              _animationController.reverse();
            },
            onEditingComplete: () {
              setState(() {
                _isFocused = false;
              });
              _animationController.reverse();
            },
            decoration: InputDecoration(
              hintText: widget.hint,
              prefixIcon: widget.prefixIcon != null
                  ? Container(
                      padding: EdgeInsets.all(3.w),
                      child: widget.prefixIcon,
                    )
                  : null,
              suffixIcon: widget.isPassword
                  ? _buildPasswordToggle()
                  : widget.suffixIcon != null
                      ? Container(
                          padding: EdgeInsets.all(3.w),
                          child: widget.suffixIcon,
                        )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.w),
                borderSide: BorderSide(
                  color: AppTheme.outlineLight,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.w),
                borderSide: BorderSide(
                  color: AppTheme.outlineLight,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.w),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.primaryColor,
                  width: 2.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.w),
                borderSide: BorderSide(
                  color: AppTheme.errorLight,
                  width: 2.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.w),
                borderSide: BorderSide(
                  color: AppTheme.errorLight,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),

        // Error Text with Animation
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: EdgeInsets.only(top: 2.w, left: 4.w),
              child: Text(
                widget.errorText!,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.errorLight,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
