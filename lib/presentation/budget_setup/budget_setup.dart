import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_custom_category_widget.dart';
import './widgets/category_card_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/smart_suggestions_widget.dart';

class BudgetSetup extends StatefulWidget {
  const BudgetSetup({super.key});

  @override
  State<BudgetSetup> createState() => _BudgetSetupState();
}

class _BudgetSetupState extends State<BudgetSetup>
    with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  int _currentStep = 2;
  final int _totalSteps = 4;
  bool _smartSuggestionsEnabled = true;
  String _userDemographic = 'young_professional';
  Set<String> _priorityCategories = {};

  // Mock categories data
  List<Map<String, dynamic>> _categories = [
    {
      'id': 'food',
      'name': 'Food & Dining',
      'icon': 'restaurant',
      'color': 0xFF2B5CE6,
      'budgetAmount': 600.0,
      'suggestedAmount': 600.0,
      'isCustom': false,
    },
    {
      'id': 'transportation',
      'name': 'Transportation',
      'icon': 'directions_car',
      'color': 0xFF00C851,
      'budgetAmount': 300.0,
      'suggestedAmount': 300.0,
      'isCustom': false,
    },
    {
      'id': 'utilities',
      'name': 'Utilities',
      'icon': 'home',
      'color': 0xFFFF8800,
      'budgetAmount': 200.0,
      'suggestedAmount': 200.0,
      'isCustom': false,
    },
    {
      'id': 'entertainment',
      'name': 'Entertainment',
      'icon': 'movie',
      'color': 0xFFE91E63,
      'budgetAmount': 250.0,
      'suggestedAmount': 250.0,
      'isCustom': false,
    },
    {
      'id': 'shopping',
      'name': 'Shopping',
      'icon': 'shopping_bag',
      'color': 0xFF9C27B0,
      'budgetAmount': 200.0,
      'suggestedAmount': 200.0,
      'isCustom': false,
    },
    {
      'id': 'healthcare',
      'name': 'Healthcare',
      'icon': 'local_hospital',
      'color': 0xFFDC3545,
      'budgetAmount': 150.0,
      'suggestedAmount': 150.0,
      'isCustom': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    );

    _fadeAnimationController.forward();

    // Set initial priority categories
    _priorityCategories = {'food', 'transportation', 'utilities'};
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    super.dispose();
  }

  double get _totalBudget {
    return _categories.fold(0.0,
        (sum, category) => sum + (category['budgetAmount'] as double? ?? 0.0));
  }

  double get _completionPercentage {
    final categoriesWithBudget = _categories
        .where((cat) => (cat['budgetAmount'] as double? ?? 0.0) > 0)
        .length;
    return (categoriesWithBudget / _categories.length * 100).clamp(0.0, 100.0);
  }

  bool get _canCompleteSetup {
    final categoriesWithBudget = _categories
        .where((cat) => (cat['budgetAmount'] as double? ?? 0.0) > 0)
        .length;
    return categoriesWithBudget >= 3;
  }

  void _onAmountChanged(String categoryId, double amount) {
    setState(() {
      final categoryIndex =
          _categories.indexWhere((cat) => cat['id'] == categoryId);
      if (categoryIndex != -1) {
        _categories[categoryIndex]['budgetAmount'] = amount;
      }
    });

    HapticFeedback.lightImpact();
  }

  void _onDeleteCategory(String categoryId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _categories.removeWhere((cat) => cat['id'] == categoryId);
                _priorityCategories.remove(categoryId);
              });
              Navigator.pop(context);
              HapticFeedback.mediumImpact();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _onEditCategory(String categoryId) {
    // Show edit dialog or navigate to edit screen
    HapticFeedback.lightImpact();
  }

  void _onSetPriority(String categoryId) {
    setState(() {
      if (_priorityCategories.contains(categoryId)) {
        _priorityCategories.remove(categoryId);
      } else {
        _priorityCategories.add(categoryId);
      }
    });
    HapticFeedback.lightImpact();
  }

  void _onToggleSmartSuggestions(bool enabled) {
    setState(() {
      _smartSuggestionsEnabled = enabled;
    });
    HapticFeedback.lightImpact();
  }

  void _onApplySuggestions(Map<String, double> suggestions) {
    setState(() {
      for (final category in _categories) {
        final categoryId = category['id'] as String;
        if (suggestions.containsKey(categoryId)) {
          category['budgetAmount'] = suggestions[categoryId];
        }
      }
    });

    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Smart suggestions applied successfully!'),
        backgroundColor: const Color(0xFF00C851),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _onAddCustomCategory(Map<String, dynamic> category) {
    setState(() {
      _categories.add(category);
    });

    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${category['name']} category added!'),
        backgroundColor: const Color(0xFF00C851),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _completeSetup() {
    if (!_canCompleteSetup) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please set budgets for at least 3 categories'),
          backgroundColor: const Color(0xFFFF8800),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();

    // Navigate to expense dashboard
    Navigator.pushReplacementNamed(context, '/expense-dashboard');
  }

  void _skipSetup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skip Budget Setup?'),
        content: const Text(
          'You can always set up your budget later in the settings. Default budgets will be used for now.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue Setup'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/expense-dashboard');
            },
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        title: Text(
          'Budget Setup',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _skipSetup,
            child: Text(
              'Skip',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Header with current month and total budget
            Container(
              padding: EdgeInsets.all(4.w),
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary,
                    AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'August 2025',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Monthly Budget',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomIconWidget(
                          iconName: 'account_balance_wallet',
                          color: Colors.white,
                          size: 6.w,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${_totalBudget.toStringAsFixed(0)}',
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Padding(
                        padding: EdgeInsets.only(bottom: 1.h),
                        child: Text(
                          'total',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Progress indicator
            ProgressIndicatorWidget(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              completionPercentage: _completionPercentage,
            ),

            // Smart suggestions
            SmartSuggestionsWidget(
              isEnabled: _smartSuggestionsEnabled,
              onToggle: _onToggleSmartSuggestions,
              onApplySuggestions: _onApplySuggestions,
              userDemographic: _userDemographic,
            ),

            // Categories list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 2.h, bottom: 12.h),
                itemCount: _categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == _categories.length) {
                    return AddCustomCategoryWidget(
                      onAddCategory: _onAddCustomCategory,
                    );
                  }

                  final category = _categories[index];
                  final categoryId = category['id'] as String;

                  return CategoryCardWidget(
                    category: category,
                    onAmountChanged: _onAmountChanged,
                    onDelete: _onDeleteCategory,
                    onEdit: _onEditCategory,
                    onSetPriority: _onSetPriority,
                    isPriority: _priorityCategories.contains(categoryId),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Bottom action buttons
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 4.h),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, -2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Helpful tip
              if (!_canCompleteSetup) ...[
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8800).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'lightbulb',
                        color: const Color(0xFFFF8800),
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          'Set budgets for at least 3 categories to complete setup',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFFFF8800),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
              ],

              // Complete setup button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canCompleteSetup ? _completeSetup : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    backgroundColor: _canCompleteSetup
                        ? AppTheme.lightTheme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Complete Setup',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'arrow_forward',
                        color: Colors.white,
                        size: 5.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
