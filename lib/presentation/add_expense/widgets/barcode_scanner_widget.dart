import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class BarcodeScannerWidget extends StatefulWidget {
  final Function(String) onBarcodeScanned;
  final String? scannedBarcode;

  const BarcodeScannerWidget({
    super.key,
    required this.onBarcodeScanned,
    this.scannedBarcode,
  });

  @override
  State<BarcodeScannerWidget> createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
  bool _isScanning = false;

  // Mock product database for demonstration
  final Map<String, Map<String, dynamic>> _productDatabase = {
    '123456789012': {
      'name': 'Organic Milk 1L',
      'price': 4.99,
      'category': 'Food',
      'brand': 'Organic Valley',
    },
    '987654321098': {
      'name': 'Wireless Headphones',
      'price': 89.99,
      'category': 'Electronics',
      'brand': 'TechBrand',
    },
    '456789123456': {
      'name': 'Coffee Beans 500g',
      'price': 12.99,
      'category': 'Food',
      'brand': 'Premium Roast',
    },
    '789123456789': {
      'name': 'Notebook Set',
      'price': 15.99,
      'category': 'Office Supplies',
      'brand': 'StudyPro',
    },
  };

  Future<void> _simulateBarcodeScan() async {
    setState(() {
      _isScanning = true;
    });

    // Simulate scanning delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate successful scan with random barcode
    final barcodes = _productDatabase.keys.toList();
    final randomBarcode =
        barcodes[DateTime.now().millisecond % barcodes.length];

    if (mounted) {
      setState(() {
        _isScanning = false;
      });

      widget.onBarcodeScanned(randomBarcode);
      _showProductInfo(randomBarcode);
    }
  }

  void _showProductInfo(String barcode) {
    final product = _productDatabase[barcode];
    if (product == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            CustomIconWidget(
              iconName: 'inventory_2',
              color: Theme.of(context).colorScheme.primary,
              size: 12.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'Product Found!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Barcode: $barcode',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
            SizedBox(height: 3.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Brand: ${product['brand']}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Category: ${product['category']}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Price: \$${product['price'].toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Auto-fill expense details
                      _autoFillExpenseDetails(product);
                    },
                    child: const Text('Use Product'),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  void _autoFillExpenseDetails(Map<String, dynamic> product) {
    // This would typically call parent widget methods to fill form
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Auto-filled: ${product['name']} - \$${product['price']}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _showScannerModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
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
                    'Scan Barcode',
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
              child: Container(
                margin: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isScanning) ...[
                      const CircularProgressIndicator(),
                      SizedBox(height: 3.h),
                      Text(
                        'Scanning...',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Point camera at barcode',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.7),
                            ),
                      ),
                    ] else ...[
                      CustomIconWidget(
                        iconName: 'qr_code_scanner',
                        color: Theme.of(context).colorScheme.primary,
                        size: 20.w,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Barcode Scanner',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Scan product barcodes to quickly\nadd expense details',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.7),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      ElevatedButton.icon(
                        onPressed: _isScanning
                            ? null
                            : () {
                                Navigator.pop(context);
                                _simulateBarcodeScan();
                              },
                        icon: CustomIconWidget(
                          iconName: 'qr_code_scanner',
                          color: Colors.white,
                          size: 5.w,
                        ),
                        label: const Text('Start Scanning'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                        ),
                      ),
                    ],
                  ],
                ),
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
          Text(
            'Quick Entry',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          if (widget.scannedBarcode != null) ...[
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
                    iconName: 'check_circle',
                    color: theme.colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Barcode Scanned',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.scannedBarcode!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => widget.onBarcodeScanned(''),
                    icon: CustomIconWidget(
                      iconName: 'clear',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 5.w,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
          ],
          GestureDetector(
            onTap: _isScanning ? null : _showScannerModal,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: _isScanning
                    ? theme.colorScheme.surfaceContainerHighest
                    : theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isScanning
                      ? theme.colorScheme.outline.withValues(alpha: 0.3)
                      : theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  if (_isScanning) ...[
                    const CircularProgressIndicator(),
                    SizedBox(height: 2.h),
                    Text(
                      'Scanning...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else ...[
                    CustomIconWidget(
                      iconName: 'qr_code_scanner',
                      color: theme.colorScheme.primary,
                      size: 10.w,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Scan Barcode',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Quickly add product details',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
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
}
