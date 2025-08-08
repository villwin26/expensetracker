import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Bottom Navigation Bar implementing Contemporary Financial Minimalism
/// Provides intuitive navigation for expense tracking with contextual actions
/// and clean professional appearance optimized for mobile interactions
class CustomBottomBar extends StatefulWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when navigation item is tapped
  final ValueChanged<int> onTap;

  /// Type of bottom bar variant
  final CustomBottomBarType type;

  /// Whether to show labels
  final bool showLabels;

  /// Background color override
  final Color? backgroundColor;

  /// Selected item color override
  final Color? selectedItemColor;

  /// Unselected item color override
  final Color? unselectedItemColor;

  /// Elevation override
  final double? elevation;

  /// Whether to show notification badges
  final bool showNotificationBadges;

  /// Notification counts for each tab
  final Map<int, int> notificationCounts;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.type = CustomBottomBarType.standard,
    this.showLabels = true,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
    this.showNotificationBadges = false,
    this.notificationCounts = const {},
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Determine colors based on theme
    final bgColor =
        widget.backgroundColor ?? (isDark ? colorScheme.surface : Colors.white);
    final selectedColor = widget.selectedItemColor ?? const Color(0xFF2B5CE6);
    final unselectedColor = widget.unselectedItemColor ??
        (isDark ? const Color(0xFFB0B0B0) : const Color(0xFF6C757D));

    switch (widget.type) {
      case CustomBottomBarType.standard:
        return _buildStandardBottomBar(
            bgColor, selectedColor, unselectedColor, isDark);

      case CustomBottomBarType.withFab:
        return _buildBottomBarWithFab(
            bgColor, selectedColor, unselectedColor, isDark);

      case CustomBottomBarType.minimal:
        return _buildMinimalBottomBar(
            bgColor, selectedColor, unselectedColor, isDark);
    }
  }

  Widget _buildStandardBottomBar(
    Color bgColor,
    Color selectedColor,
    Color unselectedColor,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          onTap: _handleNavigation,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: selectedColor,
          unselectedItemColor: unselectedColor,
          elevation: 0,
          showSelectedLabels: widget.showLabels,
          showUnselectedLabels: widget.showLabels,
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.1,
          ),
          items: _getNavigationItems(selectedColor, unselectedColor),
        ),
      ),
    );
  }

  Widget _buildBottomBarWithFab(
    Color bgColor,
    Color selectedColor,
    Color unselectedColor,
    bool isDark,
  ) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, -2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: SafeArea(
            child: BottomNavigationBar(
              currentIndex: widget.currentIndex > 1
                  ? widget.currentIndex - 1
                  : widget.currentIndex,
              onTap: (index) =>
                  _handleNavigation(index >= 2 ? index + 1 : index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              selectedItemColor: selectedColor,
              unselectedItemColor: unselectedColor,
              elevation: 0,
              showSelectedLabels: widget.showLabels,
              showUnselectedLabels: widget.showLabels,
              selectedLabelStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.1,
              ),
              items: _getFabNavigationItems(selectedColor, unselectedColor),
            ),
          ),
        ),
        Positioned(
          top: -28,
          child: AnimatedBuilder(
            animation: _fabAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _fabAnimation.value,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: selectedColor.withValues(alpha: 0.3),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: () => _handleFabTap(),
                      onTapDown: (_) => _fabAnimationController.forward(),
                      onTapUp: (_) => _fabAnimationController.reverse(),
                      onTapCancel: () => _fabAnimationController.reverse(),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMinimalBottomBar(
    Color bgColor,
    Color selectedColor,
    Color unselectedColor,
    bool isDark,
  ) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _getMinimalNavigationItems(selectedColor, unselectedColor),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _getNavigationItems(
    Color selectedColor,
    Color unselectedColor,
  ) {
    return [
      BottomNavigationBarItem(
        icon: _buildIconWithBadge(
          Icons.dashboard_outlined,
          Icons.dashboard_rounded,
          0,
        ),
        label: 'Dashboard',
        tooltip: 'Expense Dashboard',
      ),
      BottomNavigationBarItem(
        icon: _buildIconWithBadge(
          Icons.account_balance_wallet_outlined,
          Icons.account_balance_wallet_rounded,
          1,
        ),
        label: 'Budget',
        tooltip: 'Budget Setup',
      ),
      BottomNavigationBarItem(
        icon: _buildIconWithBadge(
          Icons.add_circle_outline_rounded,
          Icons.add_circle_rounded,
          2,
        ),
        label: 'Add',
        tooltip: 'Add Expense',
      ),
      BottomNavigationBarItem(
        icon: _buildIconWithBadge(
          Icons.analytics_outlined,
          Icons.analytics_rounded,
          3,
        ),
        label: 'Analytics',
        tooltip: 'Expense Analytics',
      ),
      BottomNavigationBarItem(
        icon: _buildIconWithBadge(
          Icons.settings_outlined,
          Icons.settings_rounded,
          4,
        ),
        label: 'Settings',
        tooltip: 'Settings',
      ),
    ];
  }

  List<BottomNavigationBarItem> _getFabNavigationItems(
    Color selectedColor,
    Color unselectedColor,
  ) {
    return [
      BottomNavigationBarItem(
        icon: _buildIconWithBadge(
          Icons.dashboard_outlined,
          Icons.dashboard_rounded,
          0,
        ),
        label: 'Dashboard',
        tooltip: 'Expense Dashboard',
      ),
      BottomNavigationBarItem(
        icon: _buildIconWithBadge(
          Icons.account_balance_wallet_outlined,
          Icons.account_balance_wallet_rounded,
          1,
        ),
        label: 'Budget',
        tooltip: 'Budget Setup',
      ),
      BottomNavigationBarItem(
        icon: _buildIconWithBadge(
          Icons.analytics_outlined,
          Icons.analytics_rounded,
          3,
        ),
        label: 'Analytics',
        tooltip: 'Expense Analytics',
      ),
      BottomNavigationBarItem(
        icon: _buildIconWithBadge(
          Icons.settings_outlined,
          Icons.settings_rounded,
          4,
        ),
        label: 'Settings',
        tooltip: 'Settings',
      ),
    ];
  }

  List<Widget> _getMinimalNavigationItems(
    Color selectedColor,
    Color unselectedColor,
  ) {
    final items = [
      _MinimalNavItem(
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
        label: 'Dashboard',
        isSelected: widget.currentIndex == 0,
        selectedColor: selectedColor,
        unselectedColor: unselectedColor,
        onTap: () => _handleNavigation(0),
        notificationCount: widget.notificationCounts[0] ?? 0,
        showBadge: widget.showNotificationBadges,
      ),
      _MinimalNavItem(
        icon: Icons.account_balance_wallet_outlined,
        selectedIcon: Icons.account_balance_wallet_rounded,
        label: 'Budget',
        isSelected: widget.currentIndex == 1,
        selectedColor: selectedColor,
        unselectedColor: unselectedColor,
        onTap: () => _handleNavigation(1),
        notificationCount: widget.notificationCounts[1] ?? 0,
        showBadge: widget.showNotificationBadges,
      ),
      _MinimalNavItem(
        icon: Icons.add_circle_outline_rounded,
        selectedIcon: Icons.add_circle_rounded,
        label: 'Add',
        isSelected: widget.currentIndex == 2,
        selectedColor: selectedColor,
        unselectedColor: unselectedColor,
        onTap: () => _handleNavigation(2),
        notificationCount: widget.notificationCounts[2] ?? 0,
        showBadge: widget.showNotificationBadges,
      ),
      _MinimalNavItem(
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings_rounded,
        label: 'Settings',
        isSelected: widget.currentIndex == 3,
        selectedColor: selectedColor,
        unselectedColor: unselectedColor,
        onTap: () => _handleNavigation(3),
        notificationCount: widget.notificationCounts[3] ?? 0,
        showBadge: widget.showNotificationBadges,
      ),
    ];

    return items;
  }

  Widget _buildIconWithBadge(
    IconData icon,
    IconData selectedIcon,
    int index,
  ) {
    final isSelected = widget.currentIndex == index;
    final notificationCount = widget.notificationCounts[index] ?? 0;
    final showBadge = widget.showNotificationBadges && notificationCount > 0;

    return Stack(
      children: [
        Icon(
          isSelected ? selectedIcon : icon,
          size: 24,
        ),
        if (showBadge)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: const Color(0xFFDC3545),
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Text(
                notificationCount > 9 ? '9+' : notificationCount.toString(),
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void _handleNavigation(int index) {
    HapticFeedback.lightImpact();

    // Map navigation index to route
    final routes = [
      '/expense-dashboard', // Dashboard
      '/budget-setup', // Budget
      '/add-expense', // Add Expense
      '/expense-dashboard', // Analytics (placeholder)
      '/settings', // Settings
    ];

    if (index < routes.length) {
      Navigator.pushNamed(context, routes[index]);
    }

    widget.onTap(index);
  }

  void _handleFabTap() {
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(context, '/add-expense');
    widget.onTap(2); // Add expense index
  }
}

/// Minimal navigation item widget for clean bottom bar
class _MinimalNavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;
  final int notificationCount;
  final bool showBadge;

  const _MinimalNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
    required this.notificationCount,
    required this.showBadge,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Icon(
                      isSelected ? selectedIcon : icon,
                      size: 24,
                      color: isSelected ? selectedColor : unselectedColor,
                    ),
                    if (showBadge && notificationCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDC3545),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            notificationCount > 9
                                ? '9+'
                                : notificationCount.toString(),
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                    color: isSelected ? selectedColor : unselectedColor,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Enum defining different types of bottom bar variants
enum CustomBottomBarType {
  /// Standard bottom navigation bar with all tabs
  standard,

  /// Bottom bar with floating action button for add expense
  withFab,

  /// Minimal bottom bar with essential navigation only
  minimal,
}
