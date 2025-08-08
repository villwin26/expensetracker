import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


/// Custom AppBar widget implementing Contemporary Financial Minimalism design
/// Provides trust-building interface for expense tracking applications
/// with contextual actions and clean professional appearance
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Type of app bar variant to display
  final CustomAppBarType type;

  /// Title text to display in the app bar
  final String? title;

  /// Subtitle text for additional context
  final String? subtitle;

  /// Leading widget (typically back button or menu)
  final Widget? leading;

  /// List of action widgets to display on the right
  final List<Widget>? actions;

  /// Whether to show the back button automatically
  final bool automaticallyImplyLeading;

  /// Background color override
  final Color? backgroundColor;

  /// Foreground color override
  final Color? foregroundColor;

  /// Elevation override
  final double? elevation;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom title widget
  final Widget? titleWidget;

  /// Callback for leading button press
  final VoidCallback? onLeadingPressed;

  /// Whether to show search action
  final bool showSearch;

  /// Search callback
  final VoidCallback? onSearchPressed;

  /// Whether to show notification action
  final bool showNotifications;

  /// Notification callback
  final VoidCallback? onNotificationPressed;

  /// Notification badge count
  final int notificationCount;

  const CustomAppBar({
    super.key,
    this.type = CustomAppBarType.standard,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle = false,
    this.titleWidget,
    this.onLeadingPressed,
    this.showSearch = false,
    this.onSearchPressed,
    this.showNotifications = false,
    this.onNotificationPressed,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Determine colors based on theme
    final bgColor =
        backgroundColor ?? (isDark ? colorScheme.surface : Colors.white);
    final fgColor =
        foregroundColor ?? (isDark ? Colors.white : const Color(0xFF1A1D21));

    return AppBar(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: elevation ?? 0,
      shadowColor: isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.black.withValues(alpha: 0.1),
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: _buildLeading(context, fgColor),
      title: _buildTitle(context, fgColor),
      centerTitle: centerTitle,
      actions: _buildActions(context, fgColor),
      titleSpacing: type == CustomAppBarType.dashboard ? 16 : null,
      toolbarHeight: _getToolbarHeight(),
    );
  }

  Widget? _buildLeading(BuildContext context, Color foregroundColor) {
    if (leading != null) return leading;

    switch (type) {
      case CustomAppBarType.dashboard:
        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              color: foregroundColor,
              size: 24,
            ),
            onPressed: onLeadingPressed ??
                () {
                  Scaffold.of(context).openDrawer();
                },
            tooltip: 'Menu',
          ),
        );

      case CustomAppBarType.modal:
        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: foregroundColor,
              size: 24,
            ),
            onPressed: onLeadingPressed ??
                () {
                  Navigator.of(context).pop();
                },
            tooltip: 'Close',
          ),
        );

      case CustomAppBarType.standard:
      case CustomAppBarType.settings:
        if (automaticallyImplyLeading && Navigator.of(context).canPop()) {
          return Padding(
            padding: const EdgeInsets.only(left: 16),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: foregroundColor,
                size: 24,
              ),
              onPressed: onLeadingPressed ??
                  () {
                    Navigator.of(context).pop();
                  },
              tooltip: 'Back',
            ),
          );
        }
        return null;
    }
  }

  Widget? _buildTitle(BuildContext context, Color foregroundColor) {
    if (titleWidget != null) return titleWidget;

    switch (type) {
      case CustomAppBarType.dashboard:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title ?? 'Expense Dashboard',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: foregroundColor,
                letterSpacing: -0.2,
                height: 1.2,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: foregroundColor.withValues(alpha: 0.7),
                  letterSpacing: 0.1,
                  height: 1.3,
                ),
              ),
            ],
          ],
        );

      case CustomAppBarType.modal:
        return Text(
          title ?? 'Add Expense',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: foregroundColor,
            letterSpacing: -0.1,
            height: 1.2,
          ),
        );

      case CustomAppBarType.settings:
        return Text(
          title ?? 'Settings',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: foregroundColor,
            letterSpacing: -0.2,
            height: 1.2,
          ),
        );

      case CustomAppBarType.standard:
        if (title != null) {
          return Text(
            title!,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: foregroundColor,
              letterSpacing: -0.2,
              height: 1.2,
            ),
          );
        }
        return null;
    }
  }

  List<Widget>? _buildActions(BuildContext context, Color foregroundColor) {
    final List<Widget> actionWidgets = [];

    // Add search action if enabled
    if (showSearch) {
      actionWidgets.add(
        IconButton(
          icon: Icon(
            Icons.search_rounded,
            color: foregroundColor,
            size: 24,
          ),
          onPressed: onSearchPressed,
          tooltip: 'Search',
        ),
      );
    }

    // Add notification action if enabled
    if (showNotifications) {
      actionWidgets.add(
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: foregroundColor,
                size: 24,
              ),
              onPressed: onNotificationPressed,
              tooltip: 'Notifications',
            ),
            if (notificationCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC3545),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    notificationCount > 99
                        ? '99+'
                        : notificationCount.toString(),
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // Add type-specific actions
    switch (type) {
      case CustomAppBarType.dashboard:
        actionWidgets.addAll([
          IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              color: foregroundColor,
              size: 24,
            ),
            onPressed: () {
              // Navigate to filter/sort options
              _showFilterBottomSheet(context);
            },
            tooltip: 'Filter',
          ),
          IconButton(
            icon: Icon(
              Icons.account_circle_outlined,
              color: foregroundColor,
              size: 24,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            tooltip: 'Profile',
          ),
        ]);
        break;

      case CustomAppBarType.modal:
        actionWidgets.add(
          TextButton(
            onPressed: () {
              // Handle save action
              Navigator.of(context).pop();
            },
            child: Text(
              'Save',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2B5CE6),
                letterSpacing: 0.1,
              ),
            ),
          ),
        );
        break;

      case CustomAppBarType.settings:
        actionWidgets.add(
          IconButton(
            icon: Icon(
              Icons.help_outline_rounded,
              color: foregroundColor,
              size: 24,
            ),
            onPressed: () {
              _showHelpDialog(context);
            },
            tooltip: 'Help',
          ),
        );
        break;

      case CustomAppBarType.standard:
        break;
    }

    // Add custom actions
    if (actions != null) {
      actionWidgets.addAll(actions!);
    }

    // Add padding to the last action
    if (actionWidgets.isNotEmpty) {
      actionWidgets.add(const SizedBox(width: 8));
    }

    return actionWidgets.isEmpty ? null : actionWidgets;
  }

  double _getToolbarHeight() {
    switch (type) {
      case CustomAppBarType.dashboard:
        return subtitle != null ? 72 : 56;
      case CustomAppBarType.modal:
      case CustomAppBarType.settings:
      case CustomAppBarType.standard:
        return 56;
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
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
              'Filter & Sort',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            // Filter options would go here
            Text(
              'Filter options coming soon...',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply Filters'),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
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
        content: Text(
          'Need help with your expense tracking? Contact our support team or visit our help center.',
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Open help center or contact support
            },
            child: const Text('Get Help'),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_getToolbarHeight());
}

/// Enum defining different types of app bar variants
enum CustomAppBarType {
  /// Standard app bar with back button and title
  standard,

  /// Dashboard app bar with menu, title, subtitle, and profile actions
  dashboard,

  /// Modal app bar with close button and save action
  modal,

  /// Settings app bar with back button and help action
  settings,
}
