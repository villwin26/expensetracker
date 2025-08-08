import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Social login widget providing Google and Apple Sign-In options
/// with platform-specific styling and secure authentication flows
class SocialLoginWidget extends StatelessWidget {
  final Function(SocialProvider) onSocialLogin;
  final bool isLoading;

  const SocialLoginWidget({
    super.key,
    required this.onSocialLogin,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "OR"
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.outlineLight,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'OR',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryLight,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.outlineLight,
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 6.w),

        // Social login buttons
        Column(
          children: [
            _buildGoogleSignInButton(),
            if (!kIsWeb &&
                Theme.of(context).platform == TargetPlatform.iOS) ...[
              SizedBox(height: 4.w),
              _buildAppleSignInButton(),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildGoogleSignInButton() {
    return Container(
      width: double.infinity,
      height: 14.w,
      child: OutlinedButton.icon(
        onPressed:
            isLoading ? null : () => onSocialLogin(SocialProvider.google),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppTheme.textPrimaryLight,
          side: BorderSide(
            color: AppTheme.outlineLight,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          padding: EdgeInsets.symmetric(horizontal: 6.w),
        ),
        icon: isLoading
            ? SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.textSecondaryLight,
                  ),
                ),
              )
            : _buildGoogleIcon(),
        label: Text(
          'Continue with Google',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }

  Widget _buildAppleSignInButton() {
    return Container(
      width: double.infinity,
      height: 14.w,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : () => onSocialLogin(SocialProvider.apple),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          padding: EdgeInsets.symmetric(horizontal: 6.w),
        ),
        icon: isLoading
            ? SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              )
            : Icon(
                Icons.apple,
                size: 6.w,
                color: Colors.white,
              ),
        label: Text(
          'Continue with Apple',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return Container(
      width: 5.w,
      height: 5.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.w),
        color: Colors.transparent,
      ),
      child: CustomIconWidget(
        iconName: 'g_translate', // Using a G icon as placeholder
        color: Colors.red,
        size: 5.w,
      ),
    );
  }
}

enum SocialProvider { google, apple }
