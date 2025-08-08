import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressIndicatorWidget extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final double completionPercentage;

  const ProgressIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.completionPercentage,
  });

  @override
  State<ProgressIndicatorWidget> createState() =>
      _ProgressIndicatorWidgetState();
}

class _ProgressIndicatorWidgetState extends State<ProgressIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.completionPercentage,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void didUpdateWidget(ProgressIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.completionPercentage != widget.completionPercentage) {
      _progressAnimation = Tween<double>(
        begin: oldWidget.completionPercentage,
        end: widget.completionPercentage,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with step info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget Setup Progress',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 0.5.h,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.currentStep}/${widget.totalSteps}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE1E5E9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _progressAnimation.value / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary,
                          AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 1.h),

          // Percentage text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getProgressMessage(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Text(
                    '${_progressAnimation.value.toInt()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  );
                },
              ),
            ],
          ),

          // Step indicators
          SizedBox(height: 2.h),
          Row(
            children: List.generate(widget.totalSteps, (index) {
              final isCompleted = index < widget.currentStep;
              final isCurrent = index == widget.currentStep - 1;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  child: Column(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppTheme.lightTheme.colorScheme.primary
                              : isCurrent
                                  ? AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.3)
                                  : isDark
                                      ? const Color(0xFF2C2C2C)
                                      : const Color(0xFFE1E5E9),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: isCompleted
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color: Colors.white,
                                  size: 4.w,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isCurrent
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                        : theme.colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        _getStepLabel(index),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10.sp,
                          color: isCompleted || isCurrent
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getProgressMessage() {
    if (widget.completionPercentage < 25) {
      return 'Just getting started...';
    } else if (widget.completionPercentage < 50) {
      return 'Making good progress!';
    } else if (widget.completionPercentage < 75) {
      return 'More than halfway there!';
    } else if (widget.completionPercentage < 100) {
      return 'Almost finished!';
    } else {
      return 'Setup complete!';
    }
  }

  String _getStepLabel(int index) {
    switch (index) {
      case 0:
        return 'Categories';
      case 1:
        return 'Amounts';
      case 2:
        return 'Review';
      case 3:
        return 'Complete';
      default:
        return 'Step ${index + 1}';
    }
  }
}
