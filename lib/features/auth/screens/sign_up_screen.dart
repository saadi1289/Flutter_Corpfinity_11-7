import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/error_handler.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';

/// SignUpScreen allows users to create an account using email/password or SSO
/// 
/// Features:
/// - Email and password form validation
/// - SSO options for Google and Microsoft
/// - Navigation to sign in screen
/// - White card container with 16px rounded corners and shadow
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final success = await ErrorHandler.handleAsync(
        context,
        () async {
          final authProvider = context.read<AuthProvider>();
          await authProvider.signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
        },
        onSuccess: () {
          if (mounted) {
            context.go('/auth/profile-setup');
          }
        },
      );
      
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleSSOSignUp(String providerName) async {
    setState(() => _isLoading = true);
    
    final success = await ErrorHandler.handleAsync(
      context,
      () async {
        final authProvider = context.read<AuthProvider>();
        final provider = providerName == 'google' 
            ? SSOProvider.google 
            : SSOProvider.microsoft;
        
        await authProvider.signInWithSSO(provider);
      },
      onSuccess: () {
        if (mounted) {
          context.go('/auth/profile-setup');
        }
      },
    );
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPaddingHorizontal,
            vertical: AppDimensions.screenPaddingVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.spacing32),
              
              // Header
              Text(
                'Create Account',
                style: AppTypography.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                'Start your wellness journey today',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.mediumGray,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppDimensions.spacing40),
              
              // White card container with form
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: AppDimensions.shadowBlurRadius,
                      offset: const Offset(0, AppDimensions.shadowOffsetY),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppDimensions.spacing24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        enabled: !_isLoading,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                          ),
                        ),
                        validator: Validators.validateEmail,
                      ),
                      
                      const SizedBox(height: AppDimensions.spacing16),
                      
                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        textInputAction: TextInputAction.done,
                        enabled: !_isLoading,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                          ),
                        ),
                        validator: Validators.validatePassword,
                        onFieldSubmitted: (_) => _handleSignUp(),
                      ),
                      
                      const SizedBox(height: AppDimensions.spacing24),
                      
                      // Sign Up button
                      CustomButton(
                        text: 'Sign Up',
                        onPressed: _isLoading ? null : _handleSignUp,
                        isLoading: _isLoading,
                        variant: ButtonVariant.primary,
                      ),
                      
                      const SizedBox(height: AppDimensions.spacing16),
                      
                      // Sign In Instead button
                      CustomButton(
                        text: 'Sign In Instead',
                        onPressed: _isLoading ? null : () => context.go('/auth/signin'),
                        variant: ButtonVariant.secondary,
                      ),
                      
                      const SizedBox(height: AppDimensions.spacing24),
                      
                      // Divider with "OR"
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacing12,
                            ),
                            child: Text(
                              'OR',
                              style: AppTypography.bodySmall,
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      
                      const SizedBox(height: AppDimensions.spacing24),
                      
                      // SSO Buttons
                      _buildSSOButton(
                        icon: Icons.g_mobiledata,
                        label: 'Continue with Google',
                        onPressed: _isLoading ? null : () => _handleSSOSignUp('google'),
                      ),
                      
                      const SizedBox(height: AppDimensions.spacing12),
                      
                      _buildSSOButton(
                        icon: Icons.business,
                        label: 'Continue with Microsoft',
                        onPressed: _isLoading ? null : () => _handleSSOSignUp('microsoft'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSSOButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.spacing12,
          horizontal: AppDimensions.spacing16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        side: BorderSide(
          color: AppColors.neutralGray,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppDimensions.iconSizeMedium),
          const SizedBox(width: AppDimensions.spacing12),
          Text(
            label,
            style: AppTypography.buttonMedium.copyWith(
              color: AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }
}
