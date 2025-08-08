import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SplitExpenseWidget extends StatefulWidget {
  final bool isSplitEnabled;
  final Function(bool) onSplitToggled;
  final List<Map<String, dynamic>> splitContacts;
  final Function(List<Map<String, dynamic>>) onSplitContactsChanged;
  final double totalAmount;

  const SplitExpenseWidget({
    super.key,
    required this.isSplitEnabled,
    required this.onSplitToggled,
    required this.splitContacts,
    required this.onSplitContactsChanged,
    required this.totalAmount,
  });

  @override
  State<SplitExpenseWidget> createState() => _SplitExpenseWidgetState();
}

class _SplitExpenseWidgetState extends State<SplitExpenseWidget> {
  final List<Map<String, dynamic>> _availableContacts = [
    {
      'name': 'John Smith',
      'email': 'john@example.com',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'
    },
    {
      'name': 'Sarah Johnson',
      'email': 'sarah@example.com',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'
    },
    {
      'name': 'Mike Davis',
      'email': 'mike@example.com',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'
    },
    {
      'name': 'Emma Wilson',
      'email': 'emma@example.com',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'
    },
    {
      'name': 'Alex Brown',
      'email': 'alex@example.com',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'
    },
  ];

  void _addContact(Map<String, dynamic> contact) {
    final updatedContacts =
        List<Map<String, dynamic>>.from(widget.splitContacts);
    final equalAmount = widget.totalAmount /
        (updatedContacts.length + 2); // +2 for user and new contact

    // Update existing contacts with equal split
    for (var existingContact in updatedContacts) {
      existingContact['amount'] = equalAmount;
    }

    // Add new contact
    updatedContacts.add({
      ...contact,
      'amount': equalAmount,
    });

    widget.onSplitContactsChanged(updatedContacts);
  }

  void _removeContact(int index) {
    final updatedContacts =
        List<Map<String, dynamic>>.from(widget.splitContacts);
    updatedContacts.removeAt(index);

    if (updatedContacts.isNotEmpty) {
      final equalAmount =
          widget.totalAmount / (updatedContacts.length + 1); // +1 for user
      for (var contact in updatedContacts) {
        contact['amount'] = equalAmount;
      }
    }

    widget.onSplitContactsChanged(updatedContacts);
  }

  void _updateContactAmount(int index, double amount) {
    final updatedContacts =
        List<Map<String, dynamic>>.from(widget.splitContacts);
    updatedContacts[index]['amount'] = amount;
    widget.onSplitContactsChanged(updatedContacts);
  }

  void _splitEqually() {
    final updatedContacts =
        List<Map<String, dynamic>>.from(widget.splitContacts);
    final equalAmount =
        widget.totalAmount / (updatedContacts.length + 1); // +1 for user

    for (var contact in updatedContacts) {
      contact['amount'] = equalAmount;
    }

    widget.onSplitContactsChanged(updatedContacts);
  }

  double get _userAmount {
    final totalSplit = widget.splitContacts.fold<double>(
      0.0,
      (sum, contact) => sum + (contact['amount'] as double? ?? 0.0),
    );
    return widget.totalAmount - totalSplit;
  }

  void _showContactSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Contacts',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: _availableContacts.length,
                separatorBuilder: (context, index) => SizedBox(height: 1.h),
                itemBuilder: (context, index) {
                  final contact = _availableContacts[index];
                  final isSelected = widget.splitContacts.any(
                    (c) => c['email'] == contact['email'],
                  );

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(contact['avatar']),
                      radius: 6.w,
                    ),
                    title: Text(
                      contact['name'],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      contact['email'],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: isSelected
                        ? CustomIconWidget(
                            iconName: 'check_circle',
                            color: Theme.of(context).colorScheme.primary,
                            size: 6.w,
                          )
                        : null,
                    onTap: isSelected
                        ? null
                        : () {
                            _addContact(contact);
                            Navigator.pop(context);
                          },
                    enabled: !isSelected,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
                      'Split Expense',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Divide expense among multiple people',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: widget.isSplitEnabled,
                onChanged: widget.onSplitToggled,
                activeColor: theme.colorScheme.primary,
              ),
            ],
          ),
          if (widget.isSplitEnabled && widget.totalAmount > 0) ...[
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Split Details',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: _splitEqually,
                      icon: CustomIconWidget(
                        iconName: 'balance',
                        color: theme.colorScheme.primary,
                        size: 4.w,
                      ),
                      label: const Text('Split Equally'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                      ),
                    ),
                    IconButton(
                      onPressed: _showContactSelector,
                      icon: CustomIconWidget(
                        iconName: 'person_add',
                        color: theme.colorScheme.primary,
                        size: 5.w,
                      ),
                      tooltip: 'Add Contact',
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // User's share
            Container(
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
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.primary,
                    radius: 5.w,
                    child: CustomIconWidget(
                      iconName: 'person',
                      color: Colors.white,
                      size: 5.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Your share',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${_userAmount.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            // Split contacts
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.splitContacts.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                final contact = widget.splitContacts[index];
                return Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(contact['avatar']),
                        radius: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contact['name'],
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              contact['email'],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                        child: TextField(
                          controller: TextEditingController(
                            text: (contact['amount'] as double)
                                .toStringAsFixed(2),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          style: theme.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            prefixText: '\$',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: theme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 1.h),
                            isDense: true,
                          ),
                          onChanged: (value) {
                            final amount = double.tryParse(value) ?? 0.0;
                            _updateContactAmount(index, amount);
                          },
                        ),
                      ),
                      SizedBox(width: 2.w),
                      IconButton(
                        onPressed: () => _removeContact(index),
                        icon: CustomIconWidget(
                          iconName: 'remove_circle',
                          color: theme.colorScheme.error,
                          size: 5.w,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 8.w,
                          minHeight: 4.h,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                );
              },
            ),
            if (widget.splitContacts.isEmpty) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'group_add',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 8.w,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Add contacts to split this expense',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 1.h),
                    ElevatedButton.icon(
                      onPressed: _showContactSelector,
                      icon: CustomIconWidget(
                        iconName: 'person_add',
                        color: Colors.white,
                        size: 4.w,
                      ),
                      label: const Text('Add Contact'),
                    ),
                  ],
                ),
              ),
            ],
          ] else if (widget.isSplitEnabled && widget.totalAmount == 0) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.error.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'warning',
                    color: theme.colorScheme.error,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Enter an amount to split the expense',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
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
