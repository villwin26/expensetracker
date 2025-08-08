import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BudgetOverviewWidget extends StatelessWidget {
  final double totalSpent;
  final double totalBudget;
  final double budgetUtilization;

  const BudgetOverviewWidget({
    super.key,
    required this.totalSpent,
    required this.totalBudget,
    required this.budgetUtilization,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remainingBudget = totalBudget - totalSpent;

    Color progressColor;
    if (budgetUtilization <= 0.7) {
      progressColor = AppTheme.lightTheme.colorScheme.tertiary; // Green
    } else if (budgetUtilization <= 0.9) {
      progressColor = const Color(0xFFFF8800); // Warning yellow
    } else {
      progressColor = theme.colorScheme.error; // Red
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly Overview',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              CustomIconWidget(
                iconName: 'account_balance_wallet',
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Total Spent
          Text(
            'Total Spent',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            '\$${totalSpent.toStringAsFixed(2)}',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),

          // Remaining Budget
          Text(
            remainingBudget >= 0 ? 'Remaining Budget' : 'Over Budget',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: remainingBudget >= 0
                  ? theme.colorScheme.onSurface.withValues(alpha: 0.7)
                  : theme.colorScheme.error,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            remainingBudget >= 0
                ? '\$${remainingBudget.toStringAsFixed(2)}'
                : '\$${remainingBudget.abs().toStringAsFixed(2)}',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: remainingBudget >= 0
                  ? AppTheme.lightTheme.colorScheme.tertiary
                  : theme.colorScheme.error,
            ),
          ),
          SizedBox(height: 3.h),

          // Progress Indicator
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Budget Usage',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    '${(budgetUtilization * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: progressColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor:
                      budgetUtilization > 1.0 ? 1.0 : budgetUtilization,
                  child: Container(
                    decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
