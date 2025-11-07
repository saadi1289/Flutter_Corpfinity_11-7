import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_toggle.dart';
import '../widgets/language_selector.dart';

/// ProfileScreen displays user profile and settings
/// 
/// Features:
/// - Profile header with photo, name, and total points
/// - Notification preferences toggles
/// - Voice guidance toggle
/// - Privacy settings section
/// - Language selector dropdown
/// - Logout button
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load settings when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          final user = profileProvider.currentUser;

          if (user == null) {
            return const Center(
              child: Text('No user data available'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                ProfileHeader(
                  name: user.name,
                  photoUrl: user.photoUrl,
                  totalPoints: user.totalPoints,
                ),

                const SizedBox(height: AppDimensions.spacing32),

                // Notification Settings Section
                SettingsSection(
                  title: 'Notifications',
                  children: [
                    SettingsToggle(
                      title: 'Enable Notifications',
                      subtitle: 'Receive wellness reminders and updates',
                      value: user.notifications.enabled,
                      onChanged: (value) {
                        profileProvider.updateNotificationPreferences(
                          enabled: value,
                        );
                      },
                    ),
                    if (user.notifications.enabled) ...[
                      SettingsToggle(
                        title: 'Daily Reminders',
                        subtitle: 'Get reminded to complete activities',
                        value: user.notifications.dailyReminders,
                        onChanged: (value) {
                          profileProvider.updateNotificationPreferences(
                            dailyReminders: value,
                          );
                        },
                      ),
                      SettingsToggle(
                        title: 'Achievement Alerts',
                        subtitle: 'Get notified when you earn badges',
                        value: user.notifications.achievementAlerts,
                        onChanged: (value) {
                          profileProvider.updateNotificationPreferences(
                            achievementAlerts: value,
                          );
                        },
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: AppDimensions.spacing24),

                // App Settings Section
                SettingsSection(
                  title: 'App Settings',
                  children: [
                    SettingsToggle(
                      title: 'Voice Guidance',
                      subtitle: 'Enable audio instructions for activities',
                      value: profileProvider.voiceGuidanceEnabled,
                      onChanged: (value) {
                        profileProvider.updateVoiceGuidance(value);
                      },
                    ),
                    LanguageSelector(
                      selectedLanguage: profileProvider.selectedLanguage,
                      onLanguageChanged: (language) {
                        profileProvider.updateLanguage(language);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.spacing24),

                // Privacy Settings Section
                SettingsSection(
                  title: 'Privacy',
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.privacy_tip_outlined,
                        color: AppColors.calmBlue,
                      ),
                      title: const Text(
                        'Privacy Policy',
                        style: AppTypography.bodyLarge,
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppColors.mediumGray,
                      ),
                      onTap: () {
                        // TODO: Navigate to privacy policy screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Privacy Policy - Coming soon'),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.security_outlined,
                        color: AppColors.calmBlue,
                      ),
                      title: const Text(
                        'Data & Security',
                        style: AppTypography.bodyLarge,
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppColors.mediumGray,
                      ),
                      onTap: () {
                        // TODO: Navigate to data & security screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data & Security - Coming soon'),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.spacing32),

                // Enhanced Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing24,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.error.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: AppDimensions.buttonHeightLarge,
                      child: OutlinedButton(
                        onPressed: profileProvider.isLoading
                            ? null
                            : () => _handleLogout(context, profileProvider),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          backgroundColor: AppColors.white,
                          side: BorderSide(
                            color: AppColors.error.withOpacity(0.5),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                          ),
                        ),
                        child: profileProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.logout_rounded),
                                  const SizedBox(width: AppDimensions.spacing8),
                                  Text(
                                    'Logout',
                                    style: AppTypography.buttonLarge.copyWith(
                                      color: AppColors.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppDimensions.spacing32),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Handle logout with confirmation dialog
  Future<void> _handleLogout(
    BuildContext context,
    ProfileProvider profileProvider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await profileProvider.logout();
        
        if (context.mounted) {
          // Navigate to welcome screen after logout
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/welcome',
            (route) => false,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(profileProvider.errorMessage ?? 'Logout failed'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}
