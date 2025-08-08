import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class RecurringExpenseWidget extends StatelessWidget {
  final bool isRecurring;
  final Function(bool) onRecurringToggled;
  final String? frequency;
  final Function(String)? onFrequencyChanged;
  final DateTime? endDate;
  final Function(DateTime?)? onEndDateChanged;

  const RecurringExpenseWidget({
    super.key,
    required this.isRecurring,
    required this.onRecurringToggled,
    this.frequency,
    this.onFrequencyChanged,
    this.endDate,
    this.onEndDateChanged,
  });

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && onEndDateChanged != null) {
      onEndDateChanged!(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recurring Expense',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Set up automatic recurring expenses',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isRecurring,
                onChanged: onRecurringToggled,
                activeColor: theme.colorScheme.primary,
              ),
            ],
          ),
          if (isRecurring) ...[
            SizedBox(height: 3.h),
            Text(
              'Frequency',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Expanded(
                  child: _FrequencyButton(
                    label: 'Weekly',
                    isSelected: frequency == 'Weekly',
                    onTap: () => onFrequencyChanged?.call('Weekly'),
                    theme: theme,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _FrequencyButton(
                    label: 'Monthly',
                    isSelected: frequency == 'Monthly',
                    onTap: () => onFrequencyChanged?.call('Monthly'),
                    theme: theme,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _FrequencyButton(
                    label: 'Yearly',
                    isSelected: frequency == 'Yearly',
                    onTap: () => onFrequencyChanged?.call('Yearly'),
                    theme: theme,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              'End Date (Optional)',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: () => _selectEndDate(context),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'calendar_today',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        endDate != null
                            ? 'Ends on ${_formatDate(endDate!)}'
                            : 'Select end date (optional)',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: endDate != null
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    if (endDate != null)
                      GestureDetector(
                        onTap: () => onEndDateChanged?.call(null),
                        child: CustomIconWidget(
                          iconName: 'clear',
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                          size: 5.w,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: theme.colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      frequency != null
                          ? 'This expense will repeat $frequency${endDate != null ? ' until ${_formatDate(endDate!)}' : ' indefinitely'}'
                          : 'Select a frequency to set up recurring expense',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FrequencyButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _FrequencyButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? Colors.white
                : theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
