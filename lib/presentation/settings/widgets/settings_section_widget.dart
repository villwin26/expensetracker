import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_export.dart';

class SettingsSectionWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const SettingsSectionWidget({
    super.key,
    required this.title,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}