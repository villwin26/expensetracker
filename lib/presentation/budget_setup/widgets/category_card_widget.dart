import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryCardWidget extends StatefulWidget {
  final Map<String, dynamic> category;
  final Function(String categoryId, double amount) onAmountChanged;
  final Function(String categoryId) onDelete;
  final Function(String categoryId) onEdit;
  final Function(String categoryId) onSetPriority;
  final bool isPriority;

  const CategoryCardWidget({
    super.key,
    required this.category,
    required this.onAmountChanged,
    required this.onDelete,
    required this.onEdit,
    required this.onSetPriority,
    this.isPriority = false,
  });

  @override
  State<CategoryCardWidget> createState() => _CategoryCardWidgetState();
}

class _CategoryCardWidgetState extends State<CategoryCardWidget>
    with SingleTickerProviderStateMixin {
  late TextEditingController _amountController;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isSwipeRevealed = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.category['budgetAmount']?.toString() ?? '',
    );

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.3, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _amountController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSwipe() {
    setState(() {
      _isSwipeRevealed = !_isSwipeRevealed;
    });

    if (_isSwipeRevealed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onAmountSubmitted(String value) {
    final amount = double.tryParse(value.replaceAll(',', '')) ?? 0.0;
    widget.onAmountChanged(widget.category['id'], amount);
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Stack(
        children: [
          // Action buttons background
          if (_isSwipeRevealed)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2C2C2C)
                      : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionButton(
                      icon: 'edit',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      onTap: () {
                        _toggleSwipe();
                        widget.onEdit(widget.category['id']);
                      },
                    ),
                    SizedBox(width: 2.w),
                    _buildActionButton(
                      icon: widget.isPriority ? 'star' : 'star_border',
                      color: const Color(0xFFFF8800),
                      onTap: () {
                        _toggleSwipe();
                        widget.onSetPriority(widget.category['id']);
                      },
                    ),
                    SizedBox(width: 2.w),
                    _buildActionButton(
                      icon: 'delete',
                      color: const Color(0xFFDC3545),
                      onTap: () {
                        _toggleSwipe();
                        widget.onDelete(widget.category['id']);
                      },
                    ),
                    SizedBox(width: 4.w),
                  ],
                ),
              ),
            ),

          // Main card
          SlideTransition(
            position: _slideAnimation,
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! < -500) {
                  if (!_isSwipeRevealed) _toggleSwipe();
                } else if (details.primaryVelocity! > 500) {
                  if (_isSwipeRevealed) _toggleSwipe();
                }
              },
              onTap: () {
                if (_isSwipeRevealed) {
                  _toggleSwipe();
                } else {
                  setState(() {
                    _isEditing = true;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: widget.isPriority
                      ? Border.all(
                          color: const Color(0xFFFF8800),
                          width: 2,
                        )
                      : null,
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
                child: Row(
                  children: [
                    // Category icon
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: Color(widget.category['color'])
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: widget.category['icon'],
                          color: Color(widget.category['color']),
                          size: 6.w,
                        ),
                      ),
                    ),

                    SizedBox(width: 4.w),

                    // Category details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.category['name'],
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.isPriority)
                                CustomIconWidget(
                                  iconName: 'star',
                                  color: const Color(0xFFFF8800),
                                  size: 4.w,
                                ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Suggested: \$${widget.category['suggestedAmount']?.toStringAsFixed(0) ?? '0'}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Amount input
                    SizedBox(
                      width: 25.w,
                      child: _isEditing
                          ? TextField(
                              controller: _amountController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              textAlign: TextAlign.right,
                              autofocus: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                              decoration: InputDecoration(
                                prefixText: '\$',
                                prefixStyle:
                                    theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onSubmitted: _onAmountSubmitted,
                              onTapOutside: (_) {
                                _onAmountSubmitted(_amountController.text);
                              },
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isEditing = true;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                  vertical: 1.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '\$${widget.category['budgetAmount']?.toStringAsFixed(0) ?? '0'}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: color,
            size: 5.w,
          ),
        ),
      ),
    );
  }
}
