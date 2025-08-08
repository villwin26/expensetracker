import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CategorySelectorWidget extends StatelessWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelectorWidget({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> categories = [
      {'name': 'Food', 'icon': 'restaurant', 'color': const Color(0xFFFF6B6B)},
      {
        'name': 'Transport',
        'icon': 'directions_car',
        'color': const Color(0xFF4ECDC4)
      },
      {
        'name': 'Utilities',
        'icon': 'electrical_services',
        'color': const Color(0xFFFFE66D)
      },
      {
        'name': 'Entertainment',
        'icon': 'movie',
        'color': const Color(0xFFFF8E53)
      },
      {
        'name': 'Shopping',
        'icon': 'shopping_bag',
        'color': const Color(0xFFA8E6CF)
      },
      {
        'name': 'Health',
        'icon': 'local_hospital',
        'color': const Color(0xFFFFB3BA)
      },
      {'name': 'Education', 'icon': 'school', 'color': const Color(0xFFBAE1FF)},
      {'name': 'Travel', 'icon': 'flight', 'color': const Color(0xFFD4A5FF)},
      {'name': 'Other', 'icon': 'category', 'color': const Color(0xFFB5B5B5)},
    ];

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
          Text(
            'Category',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 12.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category['name'];

                return GestureDetector(
                  onTap: () => onCategorySelected(category['name']),
                  child: Container(
                    width: 20.w,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? category['color'].withValues(alpha: 0.2)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? category['color']
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 12.w,
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: category['color'].withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: category['icon'],
                            color: category['color'],
                            size: 6.w,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          category['name'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? category['color']
                                : theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
