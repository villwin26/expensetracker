import 'package:flutter/material.dart';
import '../presentation/settings/settings.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/budget_setup/budget_setup.dart';
import '../presentation/expense_dashboard/expense_dashboard.dart';
import '../presentation/add_expense/add_expense.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String settings = '/settings';
  static const String splash = '/splash-screen';
  static const String budgetSetup = '/budget-setup';
  static const String expenseDashboard = '/expense-dashboard';
  static const String addExpense = '/add-expense';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    settings: (context) => const Settings(),
    splash: (context) => const SplashScreen(),
    budgetSetup: (context) => const BudgetSetup(),
    expenseDashboard: (context) => const ExpenseDashboard(),
    addExpense: (context) => const AddExpense(),
    // TODO: Add your other routes here
  };
}
