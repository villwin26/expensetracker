import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/custom_text_field_widget.dart';
import './widgets/password_strength_widget.dart';
import './widgets/social_login_widget.dart';
import './widgets/terms_privacy_widget.dart';

/// Registration Screen enables new user account creation with mobile-optimized
/// form inputs and validation. Features dismissible keyboard, scrollable content,
/// real-time validation, social authentication, and comprehensive error handling.
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Animation controllers
  late AnimationController _slideAnimationController;
  late AnimationController _welcomeAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _welcomeAnimation;

  // Form state
  bool _isPasswordStrong = false;
  bool _termsAccepted = false;
  bool _isLoading = false;
  bool _showWelcomeAnimation = false;

  // Validation errors
  String? _fullNameError;
  String? _emailError;
  String? _passwordError;
  String? _generalError;

  // Focus nodes for keyboard management
  final _fullNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupKeyboardDismissal();
    _setupFormListeners();
  }

  void _initializeAnimations() {
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _welcomeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _welcomeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _welcomeAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start slide animation
    _slideAnimationController.forward();
  }

  void _setupKeyboardDismissal() {
    _scrollController.addListener(() {
      FocusScope.of(context).unfocus();
    });
  }

  void _setupFormListeners() {
    _fullNameController.addListener(_validateFullName);
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  void _validateFullName() {
    final name = _fullNameController.text.trim();
    String? error;

    if (name.isEmpty) {
      error = null; // Don't show error for empty field
    } else if (name.length < 2) {
      error = 'Name must be at least 2 characters';
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      error = 'Name can only contain letters and spaces';
    }

    if (_fullNameError != error) {
      setState(() => _fullNameError = error);
    }
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    String? error;

    if (email.isEmpty) {
      error = null; // Don't show error for empty field
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      error = 'Please enter a valid email address';
    }

    if (_emailError != error) {
      setState(() => _emailError = error);
    }
  }

  void _validatePassword() {
    final password = _passwordController.text;
    String? error;

    if (password.isEmpty) {
      error = null; // Don't show error for empty field
    } else if (password.length < 8) {
      error = 'Password must be at least 8 characters';
    }

    if (_passwordError != error) {
      setState(() => _passwordError = error);
    }
  }

  bool _isFormValid() {
    return _fullNameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _fullNameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _isPasswordStrong &&
        _termsAccepted;
  }

  Future<void> _handleRegistration() async {
    if (!_isFormValid()) return;

    setState(() {
      _isLoading = true;
      _generalError = null;
    });

    // Add haptic feedback
    HapticFeedback.lightImpact();

    try {
      // Simulate registration API call
      await _performRegistration();

      // Show welcome animation
      if (mounted) {
        setState(() => _showWelcomeAnimation = true);
        _welcomeAnimationController.forward();

        // Navigate after animation
        await Future.delayed(const Duration(milliseconds: 1500));

        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/budget-setup',
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _generalError = _getErrorMessage(e);
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _performRegistration() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 2000));

    // Simulate different error scenarios
    final email = _emailController.text.trim().toLowerCase();

    if (email == 'test@existing.com') {
      throw RegistrationException('EMAIL_EXISTS');
    } else if (email.contains('network')) {
      throw RegistrationException('NETWORK_ERROR');
    } else if (email.contains('server')) {
      throw RegistrationException('SERVER_ERROR');
    }

    // Success scenario
    return;
  }

  String _getErrorMessage(dynamic error) {
    if (error is RegistrationException) {
      switch (error.code) {
        case 'EMAIL_EXISTS':
          return 'An account with this email already exists. Try logging in instead.';
        case 'NETWORK_ERROR':
          return 'Network connection error. Please check your internet connection.';
        case 'SERVER_ERROR':
          return 'Server temporarily unavailable. Please try again later.';
        default:
          return 'Registration failed. Please try again.';
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }

  Future<void> _handleSocialLogin(SocialProvider provider) async {
    setState(() => _isLoading = true);

    // Add haptic feedback
    HapticFeedback.lightImpact();

    try {
      // Simulate social login
      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        setState(() => _showWelcomeAnimation = true);
        _welcomeAnimationController.forward();

        await Future.delayed(const Duration(milliseconds: 1500));

        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/budget-setup',
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _generalError = 'Social login failed. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/splash-screen');
  }

  @override
  void dispose() {
    _slideAnimationController.dispose();
    _welcomeAnimationController.dispose();
    _scrollController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMainContent(),
          if (_showWelcomeAnimation) _buildWelcomeOverlay(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 6.w),
                  _buildBackButton(),
                  SizedBox(height: 6.w),
                  _buildHeader(),
                  SizedBox(height: 8.w),
                  _buildRegistrationForm(),
                  SizedBox(height: 6.w),
                  _buildTermsSection(),
                  SizedBox(height: 8.w),
                  _buildCreateAccountButton(),
                  SizedBox(height: 6.w),
                  _buildSocialLoginSection(),
                  SizedBox(height: 6.w),
                  _buildLoginPrompt(),
                  SizedBox(height: 8.w),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariantLight,
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: Icon(
          Icons.arrow_back_ios,
          size: 5.w,
          color: AppTheme.textPrimaryLight,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App Logo
        Center(
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor,
              borderRadius: BorderRadius.circular(5.w),
              boxShadow: [
                BoxShadow(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 16,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'account_balance_wallet',
                color: Colors.white,
                size: 10.w,
              ),
            ),
          ),
        ),

        SizedBox(height: 8.w),

        Text(
          'Create Account',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimaryLight,
          ),
        ),

        SizedBox(height: 2.w),

        Text(
          'Join thousands of users who trust ExpenseTracker to manage their finances securely and efficiently.',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondaryLight,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm() {
    return Column(
      children: [
        // General error message
        if (_generalError != null)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            margin: EdgeInsets.only(bottom: 6.w),
            decoration: BoxDecoration(
              color: AppTheme.errorLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(3.w),
              border: Border.all(
                color: AppTheme.errorLight.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppTheme.errorLight,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    _generalError!,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.errorLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Full Name field
        CustomTextFieldWidget(
          label: 'Full Name',
          hint: 'Enter your full name',
          controller: _fullNameController,
          errorText: _fullNameError,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          prefixIcon: Icon(
            Icons.person_outline,
            color: AppTheme.textSecondaryLight,
            size: 5.w,
          ),
          onChanged: (_) => _validateFullName(),
        ),

        SizedBox(height: 6.w),

        // Email field
        CustomTextFieldWidget(
          label: 'Email Address',
          hint: 'Enter your email address',
          controller: _emailController,
          errorText: _emailError,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(
            Icons.email_outlined,
            color: AppTheme.textSecondaryLight,
            size: 5.w,
          ),
          onChanged: (_) => _validateEmail(),
        ),

        SizedBox(height: 6.w),

        // Password field
        CustomTextFieldWidget(
          label: 'Password',
          hint: 'Create a strong password',
          controller: _passwordController,
          errorText: _passwordError,
          isPassword: true,
          prefixIcon: Icon(
            Icons.lock_outline,
            color: AppTheme.textSecondaryLight,
            size: 5.w,
          ),
          onChanged: (_) => _validatePassword(),
        ),

        // Password strength indicator
        PasswordStrengthWidget(
          password: _passwordController.text,
          onStrengthChanged: (isStrong) {
            setState(() => _isPasswordStrong = isStrong);
          },
        ),
      ],
    );
  }

  Widget _buildTermsSection() {
    return TermsPrivacyWidget(
      termsAccepted: _termsAccepted,
      onTermsChanged: (accepted) {
        setState(() => _termsAccepted = accepted);
      },
    );
  }

  Widget _buildCreateAccountButton() {
    final isEnabled = _isFormValid() && !_isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      height: 14.w,
      child: ElevatedButton(
        onPressed: isEnabled ? _handleRegistration : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? AppTheme.lightTheme.primaryColor
              : AppTheme.outlineLight,
          foregroundColor: Colors.white,
          elevation: isEnabled ? 2 : 0,
          shadowColor: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: 6.w,
                height: 6.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Create Account',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildSocialLoginSection() {
    return SocialLoginWidget(
      onSocialLogin: _handleSocialLogin,
      isLoading: _isLoading,
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: GestureDetector(
        onTap: _navigateToLogin,
        child: RichText(
          text: TextSpan(
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
            children: [
              const TextSpan(text: 'Already have an account? '),
              TextSpan(
                text: 'Sign In',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeOverlay() {
    return AnimatedBuilder(
      animation: _welcomeAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: AppTheme.lightTheme.primaryColor.withValues(
            alpha: _welcomeAnimation.value * 0.95,
          ),
          child: Center(
            child: FadeTransition(
              opacity: _welcomeAnimation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _welcomeAnimationController,
                    curve: Curves.elasticOut,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 25.w,
                      height: 25.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.w),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.successLight,
                          size: 15.w,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.w),
                    Text(
                      'Welcome!',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.w),
                    Text(
                      'Your account has been created successfully',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class RegistrationException implements Exception {
  final String code;
  RegistrationException(this.code);
}
