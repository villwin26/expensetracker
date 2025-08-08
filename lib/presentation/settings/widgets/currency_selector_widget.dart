import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CurrencySelectorWidget extends StatelessWidget {
  final String selectedCurrency;
  final ValueChanged<String> onCurrencyChanged;

  const CurrencySelectorWidget({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _showCurrencyPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedCurrency,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(width: 4),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              size: 16,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    final currencies = [
      {'code': 'USD', 'name': 'US Dollar', 'symbol': '\$'},
      {'code': 'EUR', 'name': 'Euro', 'symbol': '€'},
      {'code': 'GBP', 'name': 'British Pound', 'symbol': '£'},
      {'code': 'JPY', 'name': 'Japanese Yen', 'symbol': '¥'},
      {'code': 'CAD', 'name': 'Canadian Dollar', 'symbol': 'C\$'},
      {'code': 'AUD', 'name': 'Australian Dollar', 'symbol': 'A\$'},
      {'code': 'CHF', 'name': 'Swiss Franc', 'symbol': 'CHF'},
      {'code': 'CNY', 'name': 'Chinese Yuan', 'symbol': '¥'},
      {'code': 'INR', 'name': 'Indian Rupee', 'symbol': '₹'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Currency',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            ...currencies.map((currency) => ListTile(
                  leading: Text(
                    currency['symbol']!,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    currency['name']!,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    currency['code']!,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                  trailing: selectedCurrency == currency['code']
                      ? CustomIconWidget(
                          iconName: 'check',
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    onCurrencyChanged(currency['code']!);
                    Navigator.pop(context);
                  },
                )),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}