import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/backup_status_widget.dart';
import './widgets/currency_selector_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/settings_toggle_widget.dart';
import './widgets/user_profile_widget.dart';
import 'widgets/backup_status_widget.dart';
import 'widgets/currency_selector_widget.dart';
import 'widgets/settings_item_widget.dart';
import 'widgets/settings_section_widget.dart';
import 'widgets/settings_toggle_widget.dart';
import 'widgets/user_profile_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // User profile data
  final String _userName = "Sarah Johnson";
  final String _userEmail = "sarah.johnson@email.com";
  final String? _userAvatar =
      "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face";

  // Security settings
  bool _biometricEnabled = true;
  bool _autoLockEnabled = true;
  int _autoLockMinutes = 5;

  // Notification settings
  bool _budgetAlertsEnabled = true;
  bool _spendingRemindersEnabled = true;
  bool _weeklySummaryEnabled = false;
  bool _pushNotificationsEnabled = true;

  // Currency and localization
  String _selectedCurrency = "USD";
  bool _autoConversionEnabled = true;

  // Backup settings
  bool _isBackedUp = true;
  DateTime? _lastBackupDate = DateTime.now().subtract(const Duration(hours: 6));
  bool _autoBackupEnabled = true;

  // Export settings
  bool _autoReportEnabled = false;
  String _reportFrequency = "Monthly";

  // Privacy settings
  bool _dataAnalyticsEnabled = false;
  bool _crashReportingEnabled = true;

  // App preferences
  String _selectedTheme = "System";
  String _defaultCategory = "Food & Dining";
  bool _quickAddEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            size: 24,
            color: theme.colorScheme.onSurface,
          ),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showHelpDialog,
            icon: CustomIconWidget(
              iconName: 'help_outline',
              size: 24,
              color: theme.colorScheme.onSurface,
            ),
            tooltip: 'Help',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            UserProfileWidget(
              name: _userName,
              email: _userEmail,
              avatarUrl: _userAvatar,
              onEditPressed: _showEditProfileDialog,
            ),

            // Account Section
            SettingsSectionWidget(
              title: 'Account',
              children: [
                SettingsItemWidget(
                  title: 'Personal Information',
                  subtitle: 'Update your profile details',
                  iconName: 'person',
                  onTap: _showEditProfileDialog,
                  isFirst: true,
                ),
                SettingsItemWidget(
                  title: 'Linked Accounts',
                  subtitle: 'Manage connected bank accounts',
                  iconName: 'account_balance',
                  onTap: () => _showComingSoonDialog('Linked Accounts'),
                ),
                SettingsItemWidget(
                  title: 'Subscription',
                  subtitle: 'Manage your premium subscription',
                  iconName: 'card_membership',
                  onTap: () => _showComingSoonDialog('Subscription'),
                  isLast: true,
                ),
              ],
            ),

            // Security Section
            SettingsSectionWidget(
              title: 'Security',
              children: [
                SettingsToggleWidget(
                  title: 'Biometric Authentication',
                  subtitle: 'Use fingerprint or face recognition',
                  iconName: 'fingerprint',
                  value: _biometricEnabled,
                  onChanged: (value) =>
                      setState(() => _biometricEnabled = value),
                  isFirst: true,
                ),
                SettingsItemWidget(
                  title: 'Change PIN',
                  subtitle: 'Update your security PIN',
                  iconName: 'lock',
                  onTap: _showChangePinDialog,
                ),
                SettingsToggleWidget(
                  title: 'Auto-Lock',
                  subtitle: 'Lock app after $_autoLockMinutes minutes',
                  iconName: 'lock_clock',
                  value: _autoLockEnabled,
                  onChanged: (value) =>
                      setState(() => _autoLockEnabled = value),
                  isLast: true,
                ),
              ],
            ),

            // Notifications Section
            SettingsSectionWidget(
              title: 'Notifications',
              children: [
                SettingsToggleWidget(
                  title: 'Push Notifications',
                  subtitle: 'Receive app notifications',
                  iconName: 'notifications',
                  value: _pushNotificationsEnabled,
                  onChanged: (value) =>
                      setState(() => _pushNotificationsEnabled = value),
                  isFirst: true,
                ),
                SettingsToggleWidget(
                  title: 'Budget Alerts',
                  subtitle: 'Get notified when approaching budget limits',
                  iconName: 'warning',
                  value: _budgetAlertsEnabled,
                  onChanged: (value) =>
                      setState(() => _budgetAlertsEnabled = value),
                ),
                SettingsToggleWidget(
                  title: 'Spending Reminders',
                  subtitle: 'Daily reminders to track expenses',
                  iconName: 'schedule',
                  value: _spendingRemindersEnabled,
                  onChanged: (value) =>
                      setState(() => _spendingRemindersEnabled = value),
                ),
                SettingsToggleWidget(
                  title: 'Weekly Summary',
                  subtitle: 'Receive weekly spending reports',
                  iconName: 'summarize',
                  value: _weeklySummaryEnabled,
                  onChanged: (value) =>
                      setState(() => _weeklySummaryEnabled = value),
                  isLast: true,
                ),
              ],
            ),

            // Currency & Localization Section
            SettingsSectionWidget(
              title: 'Currency & Localization',
              children: [
                SettingsItemWidget(
                  title: 'Primary Currency',
                  subtitle: 'Default currency for expenses',
                  iconName: 'attach_money',
                  trailing: CurrencySelectorWidget(
                    selectedCurrency: _selectedCurrency,
                    onCurrencyChanged: (currency) =>
                        setState(() => _selectedCurrency = currency),
                  ),
                  isFirst: true,
                ),
                SettingsToggleWidget(
                  title: 'Auto Currency Conversion',
                  subtitle: 'Automatically convert foreign expenses',
                  iconName: 'currency_exchange',
                  value: _autoConversionEnabled,
                  onChanged: (value) =>
                      setState(() => _autoConversionEnabled = value),
                ),
                SettingsItemWidget(
                  title: 'Date Format',
                  subtitle: 'MM/DD/YYYY',
                  iconName: 'calendar_today',
                  onTap: () => _showComingSoonDialog('Date Format'),
                  isLast: true,
                ),
              ],
            ),

            // Backup & Sync Section
            SettingsSectionWidget(
              title: 'Backup & Sync',
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: BackupStatusWidget(
                    isBackedUp: _isBackedUp,
                    lastBackupDate: _lastBackupDate,
                    onBackupPressed: _performBackup,
                    onRestorePressed: _showRestoreDialog,
                  ),
                ),
                SettingsToggleWidget(
                  title: 'Auto Backup',
                  subtitle: 'Automatically backup data daily',
                  iconName: 'backup',
                  value: _autoBackupEnabled,
                  onChanged: (value) =>
                      setState(() => _autoBackupEnabled = value),
                  isLast: true,
                ),
              ],
            ),

            // Export Settings Section
            SettingsSectionWidget(
              title: 'Export Settings',
              children: [
                SettingsToggleWidget(
                  title: 'Auto Report Generation',
                  subtitle: 'Generate reports automatically',
                  iconName: 'description',
                  value: _autoReportEnabled,
                  onChanged: (value) =>
                      setState(() => _autoReportEnabled = value),
                  isFirst: true,
                ),
                SettingsItemWidget(
                  title: 'Report Frequency',
                  subtitle: _reportFrequency,
                  iconName: 'schedule',
                  onTap: _showReportFrequencyDialog,
                ),
                SettingsItemWidget(
                  title: 'Export Data',
                  subtitle: 'Download your expense data',
                  iconName: 'download',
                  onTap: _showExportDialog,
                  isLast: true,
                ),
              ],
            ),

            // Privacy Section
            SettingsSectionWidget(
              title: 'Privacy',
              children: [
                SettingsToggleWidget(
                  title: 'Data Analytics',
                  subtitle: 'Help improve the app with usage data',
                  iconName: 'analytics',
                  value: _dataAnalyticsEnabled,
                  onChanged: (value) =>
                      setState(() => _dataAnalyticsEnabled = value),
                  isFirst: true,
                ),
                SettingsToggleWidget(
                  title: 'Crash Reporting',
                  subtitle: 'Send crash reports to improve stability',
                  iconName: 'bug_report',
                  value: _crashReportingEnabled,
                  onChanged: (value) =>
                      setState(() => _crashReportingEnabled = value),
                ),
                SettingsItemWidget(
                  title: 'Privacy Policy',
                  subtitle: 'View our privacy policy',
                  iconName: 'privacy_tip',
                  onTap: () => _showComingSoonDialog('Privacy Policy'),
                ),
                SettingsItemWidget(
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  iconName: 'delete_forever',
                  titleColor: const Color(0xFFDC3545),
                  onTap: _showDeleteAccountDialog,
                  isLast: true,
                ),
              ],
            ),

            // App Preferences Section
            SettingsSectionWidget(
              title: 'App Preferences',
              children: [
                SettingsItemWidget(
                  title: 'Theme',
                  subtitle: _selectedTheme,
                  iconName: 'palette',
                  onTap: _showThemeDialog,
                  isFirst: true,
                ),
                SettingsItemWidget(
                  title: 'Default Category',
                  subtitle: _defaultCategory,
                  iconName: 'category',
                  onTap: _showDefaultCategoryDialog,
                ),
                SettingsToggleWidget(
                  title: 'Quick Add Shortcuts',
                  subtitle: 'Enable quick expense entry shortcuts',
                  iconName: 'flash_on',
                  value: _quickAddEnabled,
                  onChanged: (value) =>
                      setState(() => _quickAddEnabled = value),
                  isLast: true,
                ),
              ],
            ),

            // Support Section
            SettingsSectionWidget(
              title: 'Support',
              children: [
                SettingsItemWidget(
                  title: 'Help Center',
                  subtitle: 'Find answers to common questions',
                  iconName: 'help_center',
                  onTap: () => _showComingSoonDialog('Help Center'),
                  isFirst: true,
                ),
                SettingsItemWidget(
                  title: 'Contact Support',
                  subtitle: 'Get help from our support team',
                  iconName: 'support_agent',
                  onTap: _showContactSupportDialog,
                ),
                SettingsItemWidget(
                  title: 'Tutorial',
                  subtitle: 'Replay the app tutorial',
                  iconName: 'school',
                  onTap: () => _showComingSoonDialog('Tutorial'),
                  isLast: true,
                ),
              ],
            ),

            // About Section
            SettingsSectionWidget(
              title: 'About',
              children: [
                SettingsItemWidget(
                  title: 'App Version',
                  subtitle: '2.1.0 (Build 2025080801)',
                  iconName: 'info',
                  isFirst: true,
                ),
                SettingsItemWidget(
                  title: 'Terms of Service',
                  subtitle: 'View our terms and conditions',
                  iconName: 'description',
                  onTap: () => _showComingSoonDialog('Terms of Service'),
                ),
                SettingsItemWidget(
                  title: 'Acknowledgments',
                  subtitle: 'Third-party libraries and credits',
                  iconName: 'favorite',
                  onTap: _showAcknowledgmentsDialog,
                  isLast: true,
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
              ),
              controller: TextEditingController(text: _userName),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email Address',
                hintText: 'Enter your email',
              ),
              controller: TextEditingController(text: _userEmail),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Profile updated successfully');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Change PIN',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Current PIN',
                hintText: 'Enter current PIN',
              ),
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'New PIN',
                hintText: 'Enter new PIN',
              ),
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Confirm New PIN',
                hintText: 'Confirm new PIN',
              ),
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('PIN changed successfully');
            },
            child: const Text('Change PIN'),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Theme',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Light'),
              value: 'Light',
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() => _selectedTheme = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Dark'),
              value: 'Dark',
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() => _selectedTheme = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('System'),
              value: 'System',
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() => _selectedTheme = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDefaultCategoryDialog() {
    final categories = [
      'Food & Dining',
      'Transportation',
      'Shopping',
      'Entertainment',
      'Bills & Utilities',
      'Healthcare',
      'Travel',
      'Education',
      'Personal Care',
      'Other',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Default Category',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return RadioListTile<String>(
                title: Text(category),
                value: category,
                groupValue: _defaultCategory,
                onChanged: (value) {
                  setState(() => _defaultCategory = value!);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showReportFrequencyDialog() {
    final frequencies = ['Weekly', 'Monthly', 'Quarterly'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Report Frequency',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: frequencies
              .map((frequency) => RadioListTile<String>(
                    title: Text(frequency),
                    value: frequency,
                    groupValue: _reportFrequency,
                    onChanged: (value) {
                      setState(() => _reportFrequency = value!);
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Export Data',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Choose the format to export your expense data:',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              _exportData('CSV');
            },
            child: const Text('CSV'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _exportData('PDF');
            },
            child: const Text('PDF'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFDC3545),
          ),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Account deletion request submitted');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC3545),
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showContactSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Contact Support',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Get help from our support team:'),
            const SizedBox(height: 16),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'email',
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text('support@expensetracker.com'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'phone',
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text('+1 (555) 123-4567'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Support request sent');
            },
            child: const Text('Send Email'),
          ),
        ],
      ),
    );
  }

  void _showAcknowledgmentsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Acknowledgments',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const SingleChildScrollView(
          child: Text(
            'ExpenseTracker is built with the following open-source libraries:\n\n'
            '• Flutter - Google\n'
            '• Material Design - Google\n'
            '• Google Fonts - Google\n'
            '• FL Chart - Iman Khoshabi\n'
            '• Shared Preferences - Flutter Team\n'
            '• Path Provider - Flutter Team\n'
            '• Image Picker - Flutter Team\n\n'
            'Special thanks to all contributors and the Flutter community.',
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Help & Support',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Need help with ExpenseTracker? Visit our help center or contact support for assistance with tracking expenses, setting budgets, and managing your financial data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoonDialog('Help Center');
            },
            child: const Text('Get Help'),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Restore Data',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'This will restore your data from the last backup. Any changes made since the backup will be lost. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performRestore();
            },
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Coming Soon',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text('$feature feature is coming soon in a future update.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _performBackup() {
    // Simulate backup process
    setState(() {
      _isBackedUp = true;
      _lastBackupDate = DateTime.now();
    });
    _showSuccessMessage('Backup completed successfully');
  }

  void _performRestore() {
    // Simulate restore process
    _showSuccessMessage('Data restored successfully');
  }

  void _exportData(String format) {
    // Simulate export process
    _showSuccessMessage('Data exported as $format');
  }

  void _showSuccessMessage(String message) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF00C851),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
