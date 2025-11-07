import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/validators.dart';

/// SignInScreen allows users to sign in with email and password
/// 
/// Features:
/// - Email and password form validation
/// - Frontend-only authentication (no backend API calls)
/// - Direct navigation to home screen on successful login
/// - Link to sign up screen for new users
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
              
              // App Logo placeholder
              Icon(
                Icons.spa_outlined,
                size: 80,
                color: AppColors.calmBlue,
              ),
              
              const SizedBox(height: AppDimensions.spacing24),
              
              // Header
              Text(
                'Welcome to Corpfinity',
                style: AppTypography.displayLarge,
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
              
              const SizedBox(height: AppDimensions.spacing40),
              
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
                    
                    const SizedBox(height: AppDimensions.spacing24),
                    
                    // Login button
                    CustomButton(
                      text: 'Login',
                      onPressed: _isLoading ? null : _handleSignIn,
                      isLoading: _isLoading,
                      variant: ButtonVariant.primary,
                    ),
                    
                    const SizedBox(height: AppDimensions.spacing24),
                    
                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.mediumGray,
                          ),
                        ),
                        GestureDetector(
                          onTap: _isLoading ? null : () => context.go('/auth/signup'),
                          child: Text(
                            'Sign Up',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.calmBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
