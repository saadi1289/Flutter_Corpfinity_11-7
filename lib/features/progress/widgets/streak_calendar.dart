import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../core/constants/dimensions.dart';

/// Calendar widget showing completed activity days
class StreakCalendar extends StatelessWidget {
  final List<DateTime> completedDays;
  final int currentStreak;
  final int longestStreak;

  const StreakCalendar({
    super.key,
    required this.completedDays,
    required this.currentStreak,
    required this.longestStreak,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats row
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('Current Streak', '$currentStreak days', AppColors.calmBlue),
              _buildStatCard('Longest Streak', '$longestStreak days', AppColors.softGreen),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),
        
        // Calendar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getMonthYearString(currentMonth),
                style: AppTypography.headingMedium,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              _buildCalendarGrid(currentMonth),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.headingLarge.copyWith(color: color),
          ),
          const SizedBox(height: AppDimensions.spacing4),
          Text(
            label,
            style: AppTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final firstWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday

    return Column(
      children: [
        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
              .map((day) => SizedBox(
                    width: 40,
                    child: Center(
                      child: Text(
                        day,
                        style: AppTypography.captionBold,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        
        // Calendar days
        _buildDaysGrid(daysInMonth, firstWeekday, month),
      ],
    );
  }

  Widget _buildDaysGrid(int daysInMonth, int firstWeekday, DateTime month) {
    final List<Widget> rows = [];
    int dayCounter = 1;
    
    // Calculate total weeks needed
    final totalCells = daysInMonth + firstWeekday;
    final totalWeeks = (totalCells / 7).ceil();

    for (int week = 0; week < totalWeeks; week++) {
      final List<Widget> dayWidgets = [];
      
      for (int weekday = 0; weekday < 7; weekday++) {
        final cellIndex = week * 7 + weekday;
        
        if (cellIndex < firstWeekday || dayCounter > daysInMonth) {
          // Empty cell
          dayWidgets.add(const SizedBox(width: 40, height: 40));
        } else {
          // Day cell
          final date = DateTime(month.year, month.month, dayCounter);
          final isCompleted = _isDateCompleted(date);
          dayWidgets.add(_buildDayCell(dayCounter, isCompleted));
          dayCounter++;
        }
      }
      
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spacing4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dayWidgets,
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildDayCell(int day, bool isCompleted) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.softGreen : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isCompleted ? AppColors.softGreen : AppColors.neutralGray,
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          '$day',
          style: AppTypography.bodyMedium.copyWith(
            color: isCompleted ? AppColors.white : AppColors.darkText,
            fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  bool _isDateCompleted(DateTime date) {
    return completedDays.any((completedDate) =>
        completedDate.year == date.year &&
        completedDate.month == date.month &&
        completedDate.day == date.day);
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
