import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/models/user.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';
import '../../../core/widgets/main_scaffold.dart';
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
  // Controllers for editable user details
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _goalsController = TextEditingController();
  bool _formInitialized = false;
  // Local notification state for guest (unauthenticated) mode
  bool _notifEnabled = true;
  bool _dailyReminders = true;
  bool _achievementAlerts = true;

  @override
  void initState() {
    super.initState();
    // Load settings when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadSettings();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _goalsController.dispose();
    super.dispose();
  }

  Future<void> _saveUserDetails(
    BuildContext context,
    ProfileProvider profileProvider,
  ) async {
    final name = _nameController.text.trim();
    final companyText = _companyController.text.trim();
    final company = companyText.isEmpty ? null : companyText;

    // Parse comma-separated goals into a clean list
    final goals = _goalsController.text
        .split(',')
        .map((g) => g.trim())
        .where((g) => g.isNotEmpty)
        .toList();

    // If authenticated, persist changes via provider
    if (profileProvider.currentUser != null) {
      try {
        await profileProvider.updateProfile(
          name: name.isEmpty ? profileProvider.currentUser?.name : name,
          company: company,
          wellnessGoals: goals.isEmpty
              ? profileProvider.currentUser?.wellnessGoals
              : goals,
        );

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
          ),
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile. Please try again.'),
          ),
        );
      }
    } else {
      // Guest mode: update local state only and show full page without auth
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved (local preview)'),
        ),
      );
      setState(() {
        // No persistence in guest mode; controllers already hold latest values
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
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
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          final user = profileProvider.currentUser;
          final bool isGuest = user == null;
          final User effectiveUser = user ?? User(
            id: 'guest',
            email: 'guest@corpfinity.app',
            name: 'Your Name',
            company: null,
            photoUrl: null,
            wellnessGoals: const [],
            notifications: NotificationPreferences(),
            totalPoints: 0,
            createdAt: DateTime.now(),
          );

          // Initialize form controllers once with current user values
          if (!_formInitialized) {
            _nameController.text = effectiveUser.name;
            _companyController.text = effectiveUser.company ?? '';
            _goalsController.text = effectiveUser.wellnessGoals.join(', ');
            // Initialize local notification state
            _notifEnabled = effectiveUser.notifications.enabled;
            _dailyReminders = effectiveUser.notifications.dailyReminders;
            _achievementAlerts = effectiveUser.notifications.achievementAlerts;
            _formInitialized = true;
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                ProfileHeader(
                  name: effectiveUser.name,
                  photoUrl: effectiveUser.photoUrl,
                  totalPoints: effectiveUser.totalPoints,
                ),

                const SizedBox(height: AppDimensions.spacing32),

                // User Details (editable)
                SettingsSection(
                  title: 'Your Details',
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacing20,
                        vertical: AppDimensions.spacing16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email (read-only)
                          Row(
                            children: [
                              const Icon(
                                Icons.email_outlined,
                                color: AppColors.calmBlue,
                              ),
                              const SizedBox(width: AppDimensions.spacing12),
                              Expanded(
                                child: Text(
                                  effectiveUser.email,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.mediumGray,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.spacing16),

                          // Name
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              hintText: 'Enter your full name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacing16),

                          // Company
                          TextField(
                            controller: _companyController,
                            decoration: const InputDecoration(
                              labelText: 'Company (optional)',
                              hintText: 'Enter your company name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacing16),

                          // Wellness Goals
                          TextField(
                            controller: _goalsController,
                            minLines: 1,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              labelText: 'Wellness Goals',
                              hintText:
                                  'e.g., Stress Reduction, Better Sleep, Mindfulness',
                              helperText:
                                  'Separate multiple goals with commas',
                              border: OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: AppDimensions.spacing16),

                          // Save button
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: profileProvider.isLoading
                                  ? null
                                  : () => _saveUserDetails(
                                        context,
                                        profileProvider,
                                      ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.calmBlue,
                                foregroundColor: AppColors.white,
                              ),
                              icon: profileProvider.isLoading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(
                                          AppColors.white,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.save_rounded),
                              label: Text(
                                profileProvider.isLoading
                                    ? 'Saving...'
                                    : 'Save Changes',
                                style: AppTypography.buttonMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Notification Settings Section
                SettingsSection(
                  title: 'Notifications',
                  children: [
                    SettingsToggle(
                      title: 'Enable Notifications',
                      subtitle: 'Receive wellness reminders and updates',
                      value: _notifEnabled,
                      onChanged: (value) {
                        if (isGuest) {
                          setState(() => _notifEnabled = value);
                        } else {
                          profileProvider.updateNotificationPreferences(
                            enabled: value,
                          );
                        }
                      },
                    ),
                    if (_notifEnabled) ...[
                      SettingsToggle(
                        title: 'Daily Reminders',
                        subtitle: 'Get reminded to complete activities',
                        value: _dailyReminders,
                        onChanged: (value) {
                          if (isGuest) {
                            setState(() => _dailyReminders = value);
                          } else {
                            profileProvider.updateNotificationPreferences(
                              dailyReminders: value,
                            );
                          }
                        },
                      ),
                      SettingsToggle(
                        title: 'Achievement Alerts',
                        subtitle: 'Get notified when you earn badges',
                        value: _achievementAlerts,
                        onChanged: (value) {
                          if (isGuest) {
                            setState(() => _achievementAlerts = value);
                          } else {
                            profileProvider.updateNotificationPreferences(
                              achievementAlerts: value,
                            );
                          }
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
