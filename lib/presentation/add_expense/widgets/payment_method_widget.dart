import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PaymentMethodWidget extends StatelessWidget {
  final String? selectedMethod;
  final Function(String) onMethodSelected;

  const PaymentMethodWidget({
    super.key,
    this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> paymentMethods = [
      {
        'name': 'Cash',
        'icon': 'payments',
        'color': const Color(0xFF4CAF50),
        'subtitle': 'Physical cash',
      },
      {
        'name': 'Credit Card',
        'icon': 'credit_card',
        'color': const Color(0xFF2196F3),
        'subtitle': 'Visa •••• 1234',
      },
      {
        'name': 'Debit Card',
        'icon': 'payment',
        'color': const Color(0xFFFF9800),
        'subtitle': 'Master •••• 5678',
      },
      {
        'name': 'Digital Wallet',
        'icon': 'account_balance_wallet',
        'color': const Color(0xFF9C27B0),
        'subtitle': 'PayPal, Apple Pay',
      },
      {
        'name': 'Bank Transfer',
        'icon': 'account_balance',
        'color': const Color(0xFF607D8B),
        'subtitle': 'Direct transfer',
      },
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
            'Payment Method',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: paymentMethods.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final method = paymentMethods[index];
              final isSelected = selectedMethod == method['name'];

              return GestureDetector(
                onTap: () => onMethodSelected(method['name']),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: method['color'].withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: method['icon'],
                          color: method['color'],
                          size: 6.w,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method['name'],
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              method['subtitle'],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: theme.colorScheme.primary,
                          size: 5.w,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
