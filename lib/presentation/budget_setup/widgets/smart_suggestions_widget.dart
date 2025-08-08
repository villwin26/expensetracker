import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SmartSuggestionsWidget extends StatefulWidget {
  final bool isEnabled;
  final Function(bool enabled) onToggle;
  final Function(Map<String, double> suggestions) onApplySuggestions;
  final String userDemographic;

  const SmartSuggestionsWidget({
    super.key,
    required this.isEnabled,
    required this.onToggle,
    required this.onApplySuggestions,
    this.userDemographic = 'young_professional',
  });

  @override
  State<SmartSuggestionsWidget> createState() => _SmartSuggestionsWidgetState();
}

class _SmartSuggestionsWidgetState extends State<SmartSuggestionsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;
  bool _isLoading = false;

  // Mock demographic-based suggestions
  final Map<String, Map<String, double>> _demographicSuggestions = {
    'young_professional': {
      'food': 600.0,
      'transportation': 300.0,
      'utilities': 200.0,
      'entertainment': 250.0,
      'shopping': 200.0,
      'healthcare': 150.0,
      'savings': 500.0,
    },
    'student': {
      'food': 300.0,
      'transportation': 100.0,
      'utilities': 80.0,
      'entertainment': 150.0,
      'shopping': 100.0,
      'healthcare': 50.0,
      'education': 200.0,
    },
    'family': {
      'food': 800.0,
      'transportation': 400.0,
      'utilities': 300.0,
      'entertainment': 200.0,
      'shopping': 300.0,
      'healthcare': 250.0,
      'childcare': 600.0,
      'savings': 400.0,
    },
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Future<void> _applySuggestions() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 1500));

    final suggestions = _demographicSuggestions[widget.userDemographic] ??
        _demographicSuggestions['young_professional']!;

    widget.onApplySuggestions(suggestions);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isEnabled
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3)
              : Colors.transparent,
          width: 1,
        ),
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
        children: [
          // Header with toggle
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'psychology',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 6.w,
                      ),
                    ),
                  ),

                  SizedBox(width: 4.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Smart Suggestions',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'AI-powered budget recommendations',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Toggle switch
                  Switch(
                    value: widget.isEnabled,
                    onChanged: widget.onToggle,
                    activeColor: AppTheme.lightTheme.colorScheme.primary,
                  ),

                  SizedBox(width: 2.w),

                  // Expand icon
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    height: 1,
                  ),

                  SizedBox(height: 3.h),

                  // Description
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 5.w,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            'Based on spending patterns of similar users in your demographic, we can suggest realistic budget amounts for each category.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.8),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Demographic info
                  Row(
                    children: [
                      Text(
                        'Your Profile: ',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00C851).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getDemographicLabel(widget.userDemographic),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF00C851),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Preview of suggestions
                  if (widget.isEnabled) ...[
                    Text(
                      'Suggested Budget Breakdown:',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    ..._buildSuggestionPreview(theme),

                    SizedBox(height: 3.h),

                    // Apply button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _applySuggestions,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 5.w,
                                height: 5.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Apply Smart Suggestions',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'toggle_off',
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.4),
                            size: 5.w,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'Enable Smart Suggestions to see AI-powered budget recommendations tailored to your profile.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSuggestionPreview(ThemeData theme) {
    final suggestions = _demographicSuggestions[widget.userDemographic] ??
        _demographicSuggestions['young_professional']!;

    return suggestions.entries.take(4).map((entry) {
      return Padding(
        padding: EdgeInsets.only(bottom: 1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getCategoryDisplayName(entry.key),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            Text(
              '\$${entry.value.toStringAsFixed(0)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _getDemographicLabel(String demographic) {
    switch (demographic) {
      case 'young_professional':
        return 'Young Professional';
      case 'student':
        return 'Student';
      case 'family':
        return 'Family';
      default:
        return 'General';
    }
  }

  String _getCategoryDisplayName(String key) {
    switch (key) {
      case 'food':
        return 'Food & Dining';
      case 'transportation':
        return 'Transportation';
      case 'utilities':
        return 'Utilities';
      case 'entertainment':
        return 'Entertainment';
      case 'shopping':
        return 'Shopping';
      case 'healthcare':
        return 'Healthcare';
      case 'savings':
        return 'Savings';
      case 'education':
        return 'Education';
      case 'childcare':
        return 'Childcare';
      default:
        return key
            .replaceAll('_', ' ')
            .split(' ')
            .map((word) => word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1)
                : '')
            .join(' ');
    }
  }
}
