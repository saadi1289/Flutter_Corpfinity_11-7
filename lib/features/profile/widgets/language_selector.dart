import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';
import '../providers/profile_provider.dart';

/// LanguageSelector allows users to select their preferred language
class LanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String> onLanguageChanged;

  const LanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing8,
      ),
      leading: const Icon(
        Icons.language,
        color: AppColors.calmBlue,
      ),
      title: const Text(
        'Language',
        style: AppTypography.bodyLarge,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: AppDimensions.spacing4),
        child: Text(
          selectedLanguage,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.mediumGray,
          ),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.mediumGray,
      ),
      onTap: () => _showLanguageDialog(context),
    );
  }

  /// Show language selection dialog
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppDimensions.spacing16,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: ProfileProvider.availableLanguages.length,
            itemBuilder: (context, index) {
              final language = ProfileProvider.availableLanguages[index];
              final isSelected = language == selectedLanguage;

              return ListTile(
                title: Text(
                  language,
                  style: AppTypography.bodyLarge.copyWith(
                    color: isSelected ? AppColors.calmBlue : AppColors.darkText,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check,
                        color: AppColors.calmBlue,
                      )
                    : null,
                onTap: () {
                  onLanguageChanged(language);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
