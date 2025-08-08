import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AddCustomCategoryWidget extends StatefulWidget {
  final Function(Map<String, dynamic> category) onAddCategory;

  const AddCustomCategoryWidget({
    super.key,
    required this.onAddCategory,
  });

  @override
  State<AddCustomCategoryWidget> createState() =>
      _AddCustomCategoryWidgetState();
}

class _AddCustomCategoryWidgetState extends State<AddCustomCategoryWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  String _selectedIcon = 'category';
  Color _selectedColor = const Color(0xFF2B5CE6);

  final List<String> _availableIcons = [
    'category',
    'restaurant',
    'directions_car',
    'home',
    'movie',
    'shopping_bag',
    'local_hospital',
    'school',
    'fitness_center',
    'pets',
    'work',
    'flight',
    'hotel',
    'local_gas_station',
    'phone',
    'wifi',
    'electric_bolt',
    'water_drop',
    'local_laundry_service',
    'cleaning_services',
    'handyman',
    'garden',
    'sports_esports',
    'music_note',
    'book',
    'camera_alt',
    'palette',
    'celebration',
  ];

  final List<Color> _availableColors = [
    const Color(0xFF2B5CE6), // Primary blue
    const Color(0xFF00C851), // Success green
    const Color(0xFFFF8800), // Warning orange
    const Color(0xFFDC3545), // Error red
    const Color(0xFF6F42C1), // Purple
    const Color(0xFF20C997), // Teal
    const Color(0xFFE91E63), // Pink
    const Color(0xFF795548), // Brown
    const Color(0xFF607D8B), // Blue grey
    const Color(0xFF9C27B0), // Deep purple
    const Color(0xFF3F51B5), // Indigo
    const Color(0xFF009688), // Cyan
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _showAddCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildBottomSheetContent(context));
  }

  Widget _buildBottomSheetContent(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
        decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20))),
        padding: EdgeInsets.fromLTRB(
            4.w, 3.h, 4.w, MediaQuery.of(context).viewInsets.bottom + 3.h),
        child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              // Header
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Add Custom Category',
                    style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface)),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                        iconName: 'close',
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 6.w)),
              ]),

              SizedBox(height: 3.h),

              // Category preview
              Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: _selectedColor.withValues(alpha: 0.3),
                          width: 1)),
                  child: Row(children: [
                    Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                            color: _selectedColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                            child: CustomIconWidget(
                                iconName: _selectedIcon,
                                color: _selectedColor,
                                size: 6.w))),
                    SizedBox(width: 4.w),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(
                              _nameController.text.isEmpty
                                  ? 'Category Name'
                                  : _nameController.text,
                              style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: _nameController.text.isEmpty
                                      ? theme.colorScheme.onSurface
                                          .withValues(alpha: 0.4)
                                      : theme.colorScheme.onSurface)),
                          SizedBox(height: 0.5.h),
                          Text(
                              'Budget: \$${_budgetController.text.isEmpty ? '0' : _budgetController.text}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6))),
                        ])),
                  ])),

              SizedBox(height: 4.h),

              // Category name input
              Text('Category Name',
                  style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface)),
              SizedBox(height: 1.h),
              TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: 'Enter category name',
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                              iconName: 'edit',
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              size: 5.w))),
                  onChanged: (value) => setState(() {})),

              SizedBox(height: 3.h),

              // Budget amount input
              Text('Budget Amount',
                  style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface)),
              SizedBox(height: 1.h),
              TextField(
                  controller: _budgetController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                      hintText: '0.00',
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: Text('\$',
                              style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6))))),
                  onChanged: (value) => setState(() {})),

              SizedBox(height: 4.h),

              // Icon selection
              Text('Choose Icon',
                  style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface)),
              SizedBox(height: 2.h),
              SizedBox(
                  height: 20.h,
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          crossAxisSpacing: 2.w,
                          mainAxisSpacing: 1.h),
                      itemBuilder: (context, index) {
                        final icon = _availableIcons[index];
                        final isSelected = icon == _selectedIcon;

                        return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIcon = icon;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: isSelected
                                        ? _selectedColor.withValues(alpha: 0.1)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: isSelected
                                        ? Border.all(
                                            color: _selectedColor, width: 2)
                                        : Border.all(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.1),
                                            width: 1)),
                                child: Center(
                                    child: CustomIconWidget(
                                        iconName: icon,
                                        color: isSelected
                                            ? _selectedColor
                                            : theme.colorScheme.onSurface
                                                .withValues(alpha: 0.6),
                                        size: 6.w))));
                      })),

              SizedBox(height: 4.h),

              // Color selection
              Text('Choose Color',
                  style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface)),
              SizedBox(height: 2.h),
              Wrap(
                  spacing: 3.w,
                  runSpacing: 2.h,
                  children: _availableColors.map((color) {
                    final isSelected = color == _selectedColor;

                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                        child: Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(color: Colors.white, width: 3)
                                    : null,
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                            color: color.withValues(alpha: 0.4),
                                            offset: const Offset(0, 2),
                                            blurRadius: 8,
                                            spreadRadius: 0),
                                      ]
                                    : null),
                            child: isSelected
                                ? Center(
                                    child: CustomIconWidget(
                                        iconName: 'check',
                                        color: Colors.white,
                                        size: 5.w))
                                : null));
                  }).toList()),

              SizedBox(height: 4.h),

              // Add button
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _canAddCategory() ? _addCategory : null,
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h)),
                      child: Text('Add Category',
                          style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white)))),
            ])));
  }

  bool _canAddCategory() {
    return _nameController.text.trim().isNotEmpty &&
        _budgetController.text.trim().isNotEmpty &&
        double.tryParse(_budgetController.text) != null;
  }

  void _addCategory() {
    final category = {
      'id': 'custom_${DateTime.now().millisecondsSinceEpoch}',
      'name': _nameController.text.trim(),
      'icon': _selectedIcon,
      'color': _selectedColor.value,
      'budgetAmount': double.parse(_budgetController.text),
      'suggestedAmount': double.parse(_budgetController.text),
      'isCustom': true,
    };

    widget.onAddCategory(category);
    Navigator.pop(context);

    // Reset form
    _nameController.clear();
    _budgetController.clear();
    setState(() {
      _selectedIcon = 'category';
      _selectedColor = const Color(0xFF2B5CE6);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: InkWell(
            onTap: () => _showAddCategoryBottomSheet(context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.2),
                        width: 2,
                        style: BorderStyle.solid)),
                child: Row(children: [
                  Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: CustomIconWidget(
                              iconName: 'add',
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              size: 6.w))),
                  SizedBox(width: 4.w),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('Add Custom Category',
                            style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.8))),
                        SizedBox(height: 0.5.h),
                        Text('Create your own expense category',
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6))),
                      ])),
                  CustomIconWidget(
                      iconName: 'arrow_forward_ios',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      size: 4.w),
                ]))));
  }
}
