import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Terms and Privacy widget with tappable links
/// Provides checkboxes and clickable legal text for user agreement
class TermsPrivacyWidget extends StatefulWidget {
  final bool termsAccepted;
  final Function(bool) onTermsChanged;

  const TermsPrivacyWidget({
    super.key,
    required this.termsAccepted,
    required this.onTermsChanged,
  });

  @override
  State<TermsPrivacyWidget> createState() => _TermsPrivacyWidgetState();
}

class _TermsPrivacyWidgetState extends State<TermsPrivacyWidget> {
  void _showTermsOfService() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLegalDocumentSheet(
        title: 'Terms of Service',
        content: _getTermsOfServiceContent(),
      ),
    );
  }

  void _showPrivacyPolicy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLegalDocumentSheet(
        title: 'Privacy Policy',
        content: _getPrivacyPolicyContent(),
      ),
    );
  }

  Widget _buildLegalDocumentSheet({
    required String title,
    required String content,
  }) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6.w),
          topRight: Radius.circular(6.w),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 3.w),
            width: 12.w,
            height: 1.w,
            decoration: BoxDecoration(
              color: AppTheme.outlineLight,
              borderRadius: BorderRadius.circular(0.5.w),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(6.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: AppTheme.textSecondaryLight,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Text(
                content,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
            ),
          ),

          // Close button
          Padding(
            padding: EdgeInsets.all(6.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTermsOfServiceContent() {
    return '''
TERMS OF SERVICE

Last updated: January 2024

1. ACCEPTANCE OF TERMS
By accessing and using ExpenseTracker, you accept and agree to be bound by the terms and provision of this agreement.

2. DESCRIPTION OF SERVICE
ExpenseTracker provides personal financial management tools including expense tracking, budget management, and financial analytics.

3. USER ACCOUNTS
- You are responsible for maintaining the confidentiality of your account
- You agree to accept responsibility for all activities under your account
- You must provide accurate and complete information during registration

4. PRIVACY AND DATA PROTECTION
Your privacy is important to us. Please review our Privacy Policy, which also governs your use of the Service.

5. FINANCIAL DATA SECURITY
- We implement industry-standard security measures
- Financial data is encrypted both in transit and at rest
- We never store complete banking credentials

6. USER RESPONSIBILITIES
- Use the service for lawful purposes only
- Do not share your account credentials
- Report suspicious activity immediately
- Maintain accurate financial records

7. SERVICE AVAILABILITY
While we strive for continuous availability, we do not guarantee uninterrupted access to our services.

8. LIMITATION OF LIABILITY
ExpenseTracker shall not be liable for any indirect, incidental, special, consequential, or punitive damages.

9. MODIFICATIONS TO TERMS
We reserve the right to modify these terms at any time. Changes will be effective immediately upon posting.

10. GOVERNING LAW
These terms shall be governed by and construed in accordance with applicable local laws.

For questions about these Terms, please contact us at support@expensetracker.com
''';
  }

  String _getPrivacyPolicyContent() {
    return '''
PRIVACY POLICY

Last updated: January 2024

1. INFORMATION WE COLLECT

Personal Information:
- Name and email address
- Profile information you provide
- Account preferences and settings

Financial Data:
- Transaction information you input
- Budget and spending categories
- Financial goals and targets

Technical Information:
- Device information and identifiers
- Usage analytics and app performance
- IP address and location data (if enabled)

2. HOW WE USE YOUR INFORMATION

We use your information to:
- Provide and maintain our services
- Process transactions and send notifications
- Improve our services and user experience
- Provide customer support
- Comply with legal obligations

3. DATA SHARING AND DISCLOSURE

We do not sell, trade, or rent your personal information. We may share information:
- With service providers who assist our operations
- When required by law or legal process
- To protect rights, property, or safety
- With your consent

4. DATA SECURITY

Security Measures:
- End-to-end encryption for sensitive data
- Regular security audits and monitoring
- Secure data centers with restricted access
- Two-factor authentication options

5. DATA RETENTION

We retain your data:
- As long as your account is active
- As necessary to provide services
- To comply with legal obligations
- For legitimate business purposes

6. YOUR RIGHTS

You have the right to:
- Access your personal data
- Correct inaccurate information
- Delete your account and data
- Export your data
- Opt-out of marketing communications

7. COOKIES AND TRACKING

We use cookies and similar technologies to:
- Remember your preferences
- Analyze usage patterns
- Provide personalized experience
- Improve service performance

8. CHILDREN'S PRIVACY

Our services are not intended for users under 13 years of age. We do not knowingly collect personal information from children.

9. INTERNATIONAL DATA TRANSFERS

Your data may be processed in countries other than your own, with appropriate safeguards in place.

10. UPDATES TO POLICY

We may update this policy periodically. Continued use constitutes acceptance of changes.

Contact us at privacy@expensetracker.com for privacy-related questions.
''';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Checkbox
        Container(
          margin: EdgeInsets.only(top: 0.5.w),
          child: SizedBox(
            width: 6.w,
            height: 6.w,
            child: Checkbox(
              value: widget.termsAccepted,
              onChanged: (bool? value) => widget.onTermsChanged(value ?? false),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),

        SizedBox(width: 3.w),

        // Terms text with clickable links
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryLight,
                height: 1.4,
              ),
              children: [
                const TextSpan(
                  text: 'By creating an account, you agree to our ',
                ),
                TextSpan(
                  text: 'Terms of Service',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = _showTermsOfService,
                ),
                const TextSpan(
                  text: ' and ',
                ),
                TextSpan(
                  text: 'Privacy Policy',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = _showPrivacyPolicy,
                ),
                const TextSpan(
                  text: '.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}