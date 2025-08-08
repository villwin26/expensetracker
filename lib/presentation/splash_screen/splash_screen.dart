import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

/// Splash Screen providing branded app launch experience while initializing
/// financial data services and determining user authentication status.
/// Implements Contemporary Financial Minimalism design with smooth animations
/// and proper platform-specific handling for iOS and Android.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _currencyAnimationController;
  late AnimationController _fadeAnimationController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _currencyRotationAnimation;
  late Animation<double> _currencyOpacityAnimation;
  late Animation<double> _fadeAnimation;

  bool _isInitialized = false;
  String _loadingStatus = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialization();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Currency symbol animation controller
    _currencyAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Fade animation controller
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Currency rotation animation
    _currencyRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _currencyAnimationController,
      curve: Curves.easeInOut,
    ));

    // Currency opacity animation
    _currencyOpacityAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _currencyAnimationController,
      curve: Curves.easeInOut,
    ));

    // Fade animation for transition
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _logoAnimationController.forward();
    _currencyAnimationController.repeat();
  }

  Future<void> _startInitialization() async {
    try {
      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      );

      // Initialize app services with realistic timing
      await _performInitializationSteps();

      // Mark as initialized
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _loadingStatus = 'Ready!';
        });
      }

      // Wait a moment before navigation
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate to appropriate screen
      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      // Handle initialization errors gracefully
      if (mounted) {
        setState(() {
          _loadingStatus = 'Loading...';
        });
        // Retry or navigate to offline mode
        await Future.delayed(const Duration(milliseconds: 1000));
        if (mounted) {
          _navigateToNextScreen();
        }
      }
    }
  }

  Future<void> _performInitializationSteps() async {
    // Step 1: Check biometric authentication availability
    if (mounted) {
      setState(() => _loadingStatus = 'Checking security...');
    }
    await Future.delayed(const Duration(milliseconds: 400));

    // Step 2: Load user preferences
    if (mounted) {
      setState(() => _loadingStatus = 'Loading preferences...');
    }
    await Future.delayed(const Duration(milliseconds: 500));

    // Step 3: Sync cached expense data
    if (mounted) {
      setState(() => _loadingStatus = 'Syncing data...');
    }
    await Future.delayed(const Duration(milliseconds: 600));

    // Step 4: Prepare secure storage
    if (mounted) {
      setState(() => _loadingStatus = 'Preparing storage...');
    }
    await Future.delayed(const Duration(milliseconds: 400));

    // Step 5: Final preparations
    if (mounted) {
      setState(() => _loadingStatus = 'Almost ready...');
    }
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void _navigateToNextScreen() {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Start fade animation
    _fadeAnimationController.forward().then((_) {
      if (mounted) {
        // Navigation logic based on user status
        // For demo purposes, navigate to registration screen
        // In real app, this would check authentication status
        Navigator.pushReplacementNamed(context, '/registration-screen');
      }
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _currencyAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: _buildGradientBackground(),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildLogoSection(),
                            SizedBox(height: 8.h),
                            _buildLoadingSection(),
                          ],
                        ),
                      ),
                    ),
                    _buildFooterSection(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.lightTheme.primaryColor,
          AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
          AppTheme.lightTheme.primaryColor.withValues(alpha: 0.9),
          AppTheme.lightTheme.primaryColor,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ),
    );
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _logoAnimationController,
        _currencyAnimationController,
      ]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Currency symbol background animation
            Transform.rotate(
              angle: _currencyRotationAnimation.value * 3.14159,
              child: Opacity(
                opacity: _currencyOpacityAnimation.value,
                child: CustomIconWidget(
                  iconName: 'attach_money',
                  color: Colors.white.withValues(alpha: 0.2),
                  size: 40.w,
                ),
              ),
            ),
            // Main logo
            Transform.scale(
              scale: _logoScaleAnimation.value,
              child: Opacity(
                opacity: _logoOpacityAnimation.value,
                child: Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        offset: const Offset(0, 8),
                        blurRadius: 24,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'account_balance_wallet',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 12.w,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAppTitle() {
    return AnimatedBuilder(
      animation: _logoOpacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _logoOpacityAnimation.value,
          child: Column(
            children: [
              Text(
                'ExpenseTracker',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'Smart Financial Management',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        _buildAppTitle(),
        SizedBox(height: 6.h),
        _buildLoadingIndicator(),
        SizedBox(height: 2.h),
        _buildLoadingStatus(),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 8.w,
      height: 8.w,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.white.withValues(alpha: 0.9),
        ),
        backgroundColor: Colors.white.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildLoadingStatus() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        _loadingStatus,
        key: ValueKey(_loadingStatus),
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: Colors.white.withValues(alpha: 0.8),
          fontWeight: FontWeight.w400,
          letterSpacing: 0.3,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFooterSection() {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'security',
                color: Colors.white.withValues(alpha: 0.7),
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Bank-level Security',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Version 1.0.0 • © 2024 ExpenseTracker',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
              fontWeight: FontWeight.w400,
              fontSize: 10.sp,
              letterSpacing: 0.1,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
