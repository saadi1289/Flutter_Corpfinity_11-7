import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/utils/validators.dart';

/// SignInScreen allows users to sign in with email and password
/// 
/// Features:
/// - Email and password form validation
/// - Frontend-only authentication (no backend API calls)
/// - Direct navigation to home screen on successful login
/// - Link to sign up screen for new users
/// - Social sign-in options (Google, Microsoft, Apple)
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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

  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Simulate a brief loading state for better UX
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        setState(() => _isLoading = false);
        // Navigate directly to home screen (frontend-only)
        context.go('/home');
      }
    }
  }

  Future<void> _handleSocialSignIn(String provider) async {
    // Placeholder for social sign-in
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() => _isLoading = false);
      // Navigate directly to home screen (frontend-only)
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.appGradient,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingHorizontal,
                vertical: AppDimensions.screenPaddingVertical,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with shadow
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const AppLogo.large(),
                  ),
                  
                  const SizedBox(height: AppDimensions.spacing32),
                  
                  // Welcome Card
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header
                          Text(
                            'Welcome Back',
                            style: AppTypography.displayLarge.copyWith(
                              fontSize: 28,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppDimensions.spacing8),
                          Text(
                            'Sign in to continue your wellness journey',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.mediumGray,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: AppDimensions.spacing32),
                          
                          // Social Sign-In Buttons
                          _SocialSignInButton(
                            icon: Icons.g_mobiledata,
                            label: 'Continue with Google',
                            onPressed: _isLoading ? null : () => _handleSocialSignIn('Google'),
                            backgroundColor: AppColors.white,
                            borderColor: AppColors.neutralGray,
                          ),
                          
                          const SizedBox(height: AppDimensions.spacing12),
                          
                          _SocialSignInButton(
                            icon: Icons.business,
                            label: 'Continue with Microsoft',
                            onPressed: _isLoading ? null : () => _handleSocialSignIn('Microsoft'),
                            backgroundColor: AppColors.white,
                            borderColor: AppColors.neutralGray,
                          ),
                          
                          const SizedBox(height: AppDimensions.spacing12),
                          
                          _SocialSignInButton(
                            icon: Icons.apple,
                            label: 'Continue with Apple',
                            onPressed: _isLoading ? null : () => _handleSocialSignIn('Apple'),
                            backgroundColor: AppColors.darkText,
                            textColor: AppColors.white,
                          ),
                          
                          const SizedBox(height: AppDimensions.spacing24),
                          
                          // Divider
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'OR',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.mediumGray,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          
                          const SizedBox(height: AppDimensions.spacing24),
                          
                          // Form
                          Form(
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
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    hintText: 'Enter your email',
                                    prefixIcon: Icon(Icons.email_outlined),
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
                                  ),
                                  validator: Validators.validatePassword,
                                  onFieldSubmitted: (_) => _handleSignIn(),
                                ),
                                
                                const SizedBox(height: AppDimensions.spacing8),
                                
                                // Forgot Password
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: _isLoading ? null : () {
                                      // Placeholder for forgot password
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.calmBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: AppDimensions.spacing16),
                                
                                // Login button
                                CustomButton(
                                  text: 'Sign In',
                                  onPressed: _isLoading ? null : _handleSignIn,
                                  isLoading: _isLoading,
                                  variant: ButtonVariant.primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppDimensions.spacing24),
                  
                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.darkText,
                        ),
                      ),
                      GestureDetector(
                        onTap: _isLoading ? null : () => context.go('/auth/signup'),
                        child: Text(
                          'Sign Up',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.darkText,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Social sign-in button widget
class _SocialSignInButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color? borderColor;
  final Color? textColor;

  const _SocialSignInButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.white,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(
            color: borderColor ?? backgroundColor,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: textColor ?? AppColors.darkText,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: textColor ?? AppColors.darkText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
