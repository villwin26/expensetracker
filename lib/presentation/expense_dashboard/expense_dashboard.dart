import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/budget_overview_widget.dart';
import './widgets/category_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/expense_item_widget.dart';
import './widgets/month_selector_widget.dart';
import './widgets/quick_filter_widget.dart';

class ExpenseDashboard extends StatefulWidget {
  const ExpenseDashboard({super.key});

  @override
  State<ExpenseDashboard> createState() => _ExpenseDashboardState();
}

class _ExpenseDashboardState extends State<ExpenseDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _currentMonth = DateTime.now();
  String _selectedFilter = 'All';
  bool _isLoading = false;

  // Mock data for expenses
  final List<Map<String, dynamic>> _expenses = [
    {
      'id': 1,
      'amount': 45.50,
      'category': 'Food & Dining',
      'categoryIcon': 'restaurant',
      'description': 'Lunch at Downtown Cafe',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'hasReceipt': true,
      'paymentMethod': 'Credit Card',
    },
    {
      'id': 2,
      'amount': 12.00,
      'category': 'Transport',
      'categoryIcon': 'directions_car',
      'description': 'Uber ride to office',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'hasReceipt': false,
      'paymentMethod': 'Digital Wallet',
    },
    {
      'id': 3,
      'amount': 89.99,
      'category': 'Shopping',
      'categoryIcon': 'shopping_bag',
      'description': 'Grocery shopping at SuperMart',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'hasReceipt': true,
      'paymentMethod': 'Debit Card',
    },
    {
      'id': 4,
      'amount': 150.00,
      'category': 'Bills & Utilities',
      'categoryIcon': 'receipt_long',
      'description': 'Monthly electricity bill',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'hasReceipt': true,
      'paymentMethod': 'Bank Transfer',
    },
    {
      'id': 5,
      'amount': 25.00,
      'category': 'Entertainment',
      'categoryIcon': 'movie',
      'description': 'Movie tickets',
      'date': DateTime.now().subtract(const Duration(days: 4)),
      'hasReceipt': false,
      'paymentMethod': 'Cash',
    },
  ];

  // Mock data for categories
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Food & Dining',
      'icon': 'restaurant',
      'spent': 245.50,
      'budget': 400.00,
    },
    {
      'name': 'Transport',
      'icon': 'directions_car',
      'spent': 85.00,
      'budget': 150.00,
    },
    {
      'name': 'Shopping',
      'icon': 'shopping_bag',
      'spent': 320.99,
      'budget': 300.00,
    },
    {
      'name': 'Bills & Utilities',
      'icon': 'receipt_long',
      'spent': 450.00,
      'budget': 500.00,
    },
    {
      'name': 'Entertainment',
      'icon': 'movie',
      'spent': 125.00,
      'budget': 200.00,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double get _totalSpent {
    return (_categories as List).fold(
        0.0, (sum, category) => sum + ((category['spent'] as double?) ?? 0.0));
  }

  double get _totalBudget {
    return (_categories as List).fold(
        0.0, (sum, category) => sum + ((category['budget'] as double?) ?? 0.0));
  }

  double get _budgetUtilization {
    return _totalBudget > 0 ? _totalSpent / _totalBudget : 0.0;
  }

  List<Map<String, dynamic>> get _filteredExpenses {
    if (_selectedFilter == 'All') return _expenses;
    return (_expenses as List)
        .where((expense) {
          final category = expense['category'] as String? ?? '';
          return category.toLowerCase().contains(_selectedFilter.toLowerCase());
        })
        .cast<Map<String, dynamic>>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            _buildCustomAppBar(theme),

            // Tab Bar
            _buildTabBar(theme),

            // Main Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDashboardTab(),
                  _buildBudgetTab(),
                  _buildAddExpenseTab(),
                  _buildAnalyticsTab(),
                  _buildSettingsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expense Dashboard',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                'Track your spending',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => _showFilterBottomSheet(),
                icon: CustomIconWidget(
                  iconName: 'tune',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/settings'),
                icon: CustomIconWidget(
                  iconName: 'account_circle',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor:
            theme.colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorColor: theme.colorScheme.primary,
        indicatorWeight: 3,
        tabs: const [
          Tab(
            icon: Icon(Icons.dashboard_outlined),
            text: 'Dashboard',
          ),
          Tab(
            icon: Icon(Icons.account_balance_wallet_outlined),
            text: 'Budget',
          ),
          Tab(
            icon: Icon(Icons.add_circle_outline),
            text: 'Add',
          ),
          Tab(
            icon: Icon(Icons.analytics_outlined),
            text: 'Analytics',
          ),
          Tab(
            icon: Icon(Icons.settings_outlined),
            text: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: _expenses.isEmpty
          ? SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 70.h,
                child: EmptyStateWidget(
                  onAddExpense: () => _navigateToAddExpense(),
                ),
              ),
            )
          : CustomScrollView(
              slivers: [
                // Month Selector
                SliverToBoxAdapter(
                  child: MonthSelectorWidget(
                    currentMonth: _currentMonth,
                    onPreviousMonth: _previousMonth,
                    onNextMonth: _nextMonth,
                  ),
                ),

                // Budget Overview
                SliverToBoxAdapter(
                  child: BudgetOverviewWidget(
                    totalSpent: _totalSpent,
                    totalBudget: _totalBudget,
                    budgetUtilization: _budgetUtilization,
                  ),
                ),

                // Categories Section
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 2.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Categories',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/budget-setup'),
                              child: const Text('View All'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(left: 4.w),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            return CategoryCardWidget(
                              category: _categories[index],
                              onQuickAdd: () =>
                                  _quickAddExpense(_categories[index]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Quick Filters
                SliverToBoxAdapter(
                  child: QuickFilterWidget(
                    selectedFilter: _selectedFilter,
                    onFilterChanged: (filter) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),
                ),

                // Recent Expenses Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Expenses',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Text(
                          '${_filteredExpenses.length} items',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Expenses List
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final expense = _filteredExpenses[index];
                      return ExpenseItemWidget(
                        expense: expense,
                        onEdit: () => _editExpense(expense),
                        onDelete: () => _deleteExpense(expense),
                        onDuplicate: () => _duplicateExpense(expense),
                        onViewReceipt: (expense['hasReceipt'] as bool? ?? false)
                            ? () => _viewReceipt(expense)
                            : null,
                      );
                    },
                    childCount: _filteredExpenses.length,
                  ),
                ),

                // Bottom Padding
                SliverToBoxAdapter(
                  child: SizedBox(height: 10.h),
                ),
              ],
            ),
    );
  }

  Widget _buildBudgetTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'account_balance_wallet',
            color: Theme.of(context).colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Budget Setup',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Configure your monthly budgets',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/budget-setup'),
            child: const Text('Go to Budget Setup'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddExpenseTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'add_circle',
            color: Theme.of(context).colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Add New Expense',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Track your spending quickly',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/add-expense'),
            child: const Text('Add Expense'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'analytics',
            color: Theme.of(context).colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Analytics',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'View spending insights and trends',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: () {
              // Analytics functionality coming soon
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Analytics feature coming soon!'),
                ),
              );
            },
            child: const Text('View Analytics'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'settings',
            color: Theme.of(context).colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Manage your preferences',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            child: const Text('Go to Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Add haptic feedback
    HapticFeedback.lightImpact();

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data refreshed successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
    HapticFeedback.lightImpact();
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
    HapticFeedback.lightImpact();
  }

  void _navigateToAddExpense() {
    Navigator.pushNamed(context, '/add-expense');
  }

  void _quickAddExpense(Map<String, dynamic> category) {
    Navigator.pushNamed(
      context,
      '/add-expense',
      arguments: {'preselectedCategory': category['name']},
    );
  }

  void _editExpense(Map<String, dynamic> expense) {
    Navigator.pushNamed(
      context,
      '/add-expense',
      arguments: {'expense': expense, 'isEdit': true},
    );
  }

  void _deleteExpense(Map<String, dynamic> expense) {
    setState(() {
      _expenses.removeWhere((e) => e['id'] == expense['id']);
    });

    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Expense "${expense['description']}" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _expenses.add(expense);
            });
          },
        ),
      ),
    );
  }

  void _duplicateExpense(Map<String, dynamic> expense) {
    final duplicatedExpense = Map<String, dynamic>.from(expense);
    duplicatedExpense['id'] = DateTime.now().millisecondsSinceEpoch;
    duplicatedExpense['date'] = DateTime.now();
    duplicatedExpense['description'] = '${expense['description']} (Copy)';

    setState(() {
      _expenses.insert(0, duplicatedExpense);
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Expense duplicated successfully'),
      ),
    );
  }

  void _viewReceipt(Map<String, dynamic> expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Receipt - ${expense['description']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomImageWidget(
              imageUrl:
                  'https://images.unsplash.com/photo-1554224155-6726b3ff858f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
              width: 60.w,
              height: 30.h,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 2.h),
            Text(
              'Amount: \$${(expense['amount'] as double).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12.w,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              margin: EdgeInsets.only(bottom: 3.h),
              alignment: Alignment.center,
            ),
            Text(
              'Filter & Sort Options',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),

            // Filter options would go here
            ListTile(
              leading: CustomIconWidget(
                iconName: 'date_range',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: const Text('Date Range'),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
                size: 20,
              ),
              onTap: () {
                Navigator.pop(context);
                // Show date range picker
              },
            ),

            ListTile(
              leading: CustomIconWidget(
                iconName: 'sort',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: const Text('Sort by Amount'),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
                size: 20,
              ),
              onTap: () {
                Navigator.pop(context);
                // Sort by amount
              },
            ),

            SizedBox(height: 3.h),
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
}
