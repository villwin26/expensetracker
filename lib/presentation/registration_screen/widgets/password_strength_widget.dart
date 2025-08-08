import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Password strength indicator widget with real-time validation
/// Provides visual feedback on password security requirements
class PasswordStrengthWidget extends StatefulWidget {
  final String password;
  final Function(bool) onStrengthChanged;

  const PasswordStrengthWidget({
    super.key,
    required this.password,
    required this.onStrengthChanged,
  });

  @override
  State<PasswordStrengthWidget> createState() => _PasswordStrengthWidgetState();
}

class _PasswordStrengthWidgetState extends State<PasswordStrengthWidget>
    with TickerProviderStateMixin {
  late AnimationController _strengthAnimationController;
  late Animation<double> _strengthAnimation;

  PasswordStrength _currentStrength = PasswordStrength.weak;
  List<PasswordRequirement> _requirements = [];

  @override
  void initState() {
    super.initState();
    _strengthAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _strengthAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _strengthAnimationController,
      curve: Curves.easeInOut,
    ));
    _updatePasswordStrength();
  }

  @override
  void didUpdateWidget(PasswordStrengthWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.password != widget.password) {
      _updatePasswordStrength();
    }
  }

  @override
  void dispose() {
    _strengthAnimationController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength() {
    final newStrength = _calculatePasswordStrength(widget.password);
    final newRequirements = _getPasswordRequirements(widget.password);

    if (_currentStrength != newStrength ||
        !_requirementsEqual(newRequirements)) {
      setState(() {
        _currentStrength = newStrength;
        _requirements = newRequirements;
      });
      _strengthAnimationController.reset();
      _strengthAnimationController.forward();

      widget.onStrengthChanged(_currentStrength == PasswordStrength.strong);
    }
  }

  bool _requirementsEqual(List<PasswordRequirement> newReq) {
    if (_requirements.length != newReq.length) return false;
    for (int i = 0; i < _requirements.length; i++) {
      if (_requirements[i].text != newReq[i].text ||
          _requirements[i].isMet != newReq[i].isMet) {
        return false;
      }
    }
    return true;
  }

  PasswordStrength _calculatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;

    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Character variety checks
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    // Determine strength
    if (score >= 6) return PasswordStrength.strong;
    if (score >= 4) return PasswordStrength.medium;
    return PasswordStrength.weak;
  }

  List<PasswordRequirement> _getPasswordRequirements(String password) {
    return [
      PasswordRequirement(
        text: 'At least 8 characters',
        isMet: password.length >= 8,
      ),
      PasswordRequirement(
        text: 'Contains lowercase letter',
        isMet: password.contains(RegExp(r'[a-z]')),
      ),
      PasswordRequirement(
        text: 'Contains uppercase letter',
        isMet: password.contains(RegExp(r'[A-Z]')),
      ),
      PasswordRequirement(
        text: 'Contains number',
        isMet: password.contains(RegExp(r'[0-9]')),
      ),
      PasswordRequirement(
        text: 'Contains special character',
        isMet: password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
      ),
    ];
  }

  Color _getStrengthColor() {
    switch (_currentStrength) {
      case PasswordStrength.strong:
        return AppTheme.successLight;
      case PasswordStrength.medium:
        return AppTheme.warningLight;
      case PasswordStrength.weak:
        return AppTheme.errorLight;
    }
  }

  String _getStrengthText() {
    switch (_currentStrength) {
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.weak:
        return 'Weak';
    }
  }

  double _getStrengthProgress() {
    switch (_currentStrength) {
      case PasswordStrength.strong:
        return 1.0;
      case PasswordStrength.medium:
        return 0.6;
      case PasswordStrength.weak:
        return 0.3;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.password.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _strengthAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _strengthAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.w),

              // Strength indicator bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1.w,
                      decoration: BoxDecoration(
                        color: AppTheme.outlineLight,
                        borderRadius: BorderRadius.circular(0.5.w),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _getStrengthProgress(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getStrengthColor(),
                            borderRadius: BorderRadius.circular(0.5.w),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    _getStrengthText(),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _getStrengthColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 3.w),

              // Requirements list
              ..._requirements.map((requirement) => Padding(
                    padding: EdgeInsets.only(bottom: 1.w),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 4.w,
                          height: 4.w,
                          decoration: BoxDecoration(
                            color: requirement.isMet
                                ? AppTheme.successLight
                                : AppTheme.outlineLight,
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          child: requirement.isMet
                              ? Icon(
                                  Icons.check,
                                  size: 3.w,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            requirement.text,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: requirement.isMet
                                  ? AppTheme.textPrimaryLight
                                  : AppTheme.textSecondaryLight,
                              fontWeight: requirement.isMet
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}

enum PasswordStrength { weak, medium, strong }

class PasswordRequirement {
  final String text;
  final bool isMet;

  PasswordRequirement({
    required this.text,
    required this.isMet,
  });
}
