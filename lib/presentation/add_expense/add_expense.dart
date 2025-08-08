import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/amount_input_widget.dart';
import './widgets/barcode_scanner_widget.dart';
import './widgets/category_selector_widget.dart';
import './widgets/date_picker_widget.dart';
import './widgets/description_input_widget.dart';
import './widgets/location_toggle_widget.dart';
import './widgets/payment_method_widget.dart';
import './widgets/receipt_capture_widget.dart';
import './widgets/recurring_expense_widget.dart';
import './widgets/split_expense_widget.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  // Form controllers
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Form state
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  String? _selectedPaymentMethod = 'Credit Card';
  XFile? _capturedReceipt;
  bool _isLocationEnabled = false;
  String? _currentLocation;
  bool _isRecurringExpense = false;
  String? _recurringFrequency;
  DateTime? _recurringEndDate;
  bool _isSplitExpense = false;
  List<Map<String, dynamic>> _splitContacts = [];
  String? _scannedBarcode;

  // Form validation
  bool _isFormValid = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_validateForm);
    _descriptionController.addListener(_validateForm);
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _amountController.text.isNotEmpty &&
          double.tryParse(_amountController.text) != null &&
          double.parse(_amountController.text) > 0 &&
          _selectedCategory != null &&
          _descriptionController.text.isNotEmpty &&
          _selectedPaymentMethod != null;
    });
  }

  Future<void> _getCurrentLocation() async {
    // Simulate location fetching
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _currentLocation = '123 Main Street, New York, NY 10001';
      });
    }
  }

  void _handleVoiceInput() {
    // Simulate voice input
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Voice input feature coming soon!'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  Future<void> _saveExpense() async {
    if (!_isFormValid || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    // Simulate saving process
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // Haptic feedback for success
      HapticFeedback.mediumImpact();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: Colors.white,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              const Text('Expense saved successfully!'),
            ],
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Navigate back to dashboard
      Navigator.pushReplacementNamed(context, '/expense-dashboard');
    }
  }

  void _cancelExpense() {
    if (_amountController.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty ||
        _capturedReceipt != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard Changes?'),
          content: const Text(
              'You have unsaved changes. Are you sure you want to discard them?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'Discard',
                style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
              ),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: _cancelExpense,
          icon: CustomIconWidget(
            iconName: 'close',
            color: theme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        title: Text(
          'Add Expense',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isFormValid && !_isSaving ? _saveExpense : null,
            child: _isSaving
                ? SizedBox(
                    width: 5.w,
                    height: 2.5.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  )
                : Text(
                    'Save',
                    style: TextStyle(
                      color: _isFormValid
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              // Amount Input
              AmountInputWidget(
                controller: _amountController,
                onAmountChanged: (value) => _validateForm(),
                currency: '\$',
              ),
              SizedBox(height: 3.h),

              // Category Selector
              CategorySelectorWidget(
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                  _validateForm();
                },
              ),
              SizedBox(height: 3.h),

              // Description Input
              DescriptionInputWidget(
                controller: _descriptionController,
                onDescriptionChanged: (value) => _validateForm(),
                onVoiceInput: _handleVoiceInput,
              ),
              SizedBox(height: 3.h),

              // Date Picker
              DatePickerWidget(
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
              SizedBox(height: 3.h),

              // Payment Method
              PaymentMethodWidget(
                selectedMethod: _selectedPaymentMethod,
                onMethodSelected: (method) {
                  setState(() {
                    _selectedPaymentMethod = method;
                  });
                  _validateForm();
                },
              ),
              SizedBox(height: 3.h),

              // Receipt Capture
              ReceiptCaptureWidget(
                capturedImage: _capturedReceipt,
                onImageCaptured: (image) {
                  setState(() {
                    _capturedReceipt = image;
                  });
                },
              ),
              SizedBox(height: 3.h),

              // Location Toggle
              LocationToggleWidget(
                isLocationEnabled: _isLocationEnabled,
                currentLocation: _currentLocation,
                onLocationToggled: (enabled) {
                  setState(() {
                    _isLocationEnabled = enabled;
                  });
                },
              ),
              SizedBox(height: 3.h),

              // Recurring Expense
              RecurringExpenseWidget(
                isRecurring: _isRecurringExpense,
                frequency: _recurringFrequency,
                endDate: _recurringEndDate,
                onRecurringToggled: (enabled) {
                  setState(() {
                    _isRecurringExpense = enabled;
                    if (!enabled) {
                      _recurringFrequency = null;
                      _recurringEndDate = null;
                    }
                  });
                },
                onFrequencyChanged: (frequency) {
                  setState(() {
                    _recurringFrequency = frequency;
                  });
                },
                onEndDateChanged: (date) {
                  setState(() {
                    _recurringEndDate = date;
                  });
                },
              ),
              SizedBox(height: 3.h),

              // Split Expense
              SplitExpenseWidget(
                isSplitEnabled: _isSplitExpense,
                splitContacts: _splitContacts,
                totalAmount: amount,
                onSplitToggled: (enabled) {
                  setState(() {
                    _isSplitExpense = enabled;
                    if (!enabled) {
                      _splitContacts.clear();
                    }
                  });
                },
                onSplitContactsChanged: (contacts) {
                  setState(() {
                    _splitContacts = contacts;
                  });
                },
              ),
              SizedBox(height: 3.h),

              // Barcode Scanner
              BarcodeScannerWidget(
                scannedBarcode: _scannedBarcode?.isNotEmpty == true
                    ? _scannedBarcode
                    : null,
                onBarcodeScanned: (barcode) {
                  setState(() {
                    _scannedBarcode = barcode;
                  });
                },
              ),
              SizedBox(height: 6.h),
            ],
          ),
        ),
      ),
    );
  }
}
