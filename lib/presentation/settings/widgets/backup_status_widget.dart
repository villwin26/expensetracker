import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class BackupStatusWidget extends StatelessWidget {
  final bool isBackedUp;
  final DateTime? lastBackupDate;
  final VoidCallback? onBackupPressed;
  final VoidCallback? onRestorePressed;

  const BackupStatusWidget({
    super.key,
    required this.isBackedUp,
    this.lastBackupDate,
    this.onBackupPressed,
    this.onRestorePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isBackedUp
                      ? const Color(0xFF00C851).withValues(alpha: 0.1)
                      : const Color(0xFFFF8800).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: isBackedUp ? 'cloud_done' : 'cloud_off',
                    size: 20,
                    color: isBackedUp
                        ? const Color(0xFF00C851)
                        : const Color(0xFFFF8800),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBackedUp ? 'Backup Complete' : 'Backup Pending',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lastBackupDate != null
                          ? 'Last backup: ${_formatDate(lastBackupDate!)}'
                          : 'No backup available',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBackupPressed,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'backup',
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Backup Now',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: isBackedUp ? onRestorePressed : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'restore',
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Restore',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}