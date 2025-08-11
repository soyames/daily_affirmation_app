// lib/widgets/streak_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/streak_provider.dart';

class StreakWidget extends ConsumerWidget {
  const StreakWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakData = ref.watch(streakProvider);
    final streakNotifier = ref.read(streakProvider.notifier);
    final remaining = streakNotifier.getRemainingAffirmations();
    final isUnlimited = remaining == -1;

    // Responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;

    final fontSize = isSmallScreen ? 14.0 : isTablet ? 18.0 : 16.0;
    final padding = isSmallScreen ? 8.0 : isTablet ? 16.0 : 12.0;
    final margin = isSmallScreen ? 12.0 : 16.0;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => const StreakDialog(),
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: margin, top: 8),
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.withValues(alpha: 0.8),
              Colors.blue.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Streak info
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  streakNotifier.getStreakEmoji(),
                  style: TextStyle(fontSize: fontSize),
                ),
                SizedBox(width: isSmallScreen ? 3 : 4),
                Text(
                  '${streakData.currentStreak}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'Day Streak',
              style: TextStyle(
                color: Colors.white70,
                fontSize: isSmallScreen ? 8.0 : isTablet ? 12.0 : 10.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            // Affirmation count
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isUnlimited
                    ? Colors.green.withValues(alpha: 0.3)
                    : remaining > 5
                        ? Colors.blue.withValues(alpha: 0.3)
                        : remaining > 0
                            ? Colors.orange.withValues(alpha: 0.3)
                            : Colors.red.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isUnlimited ? '∞' : '$remaining',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 12.0 : isTablet ? 16.0 : 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isUnlimited ? 'Unlimited' : 'Left Today',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isSmallScreen ? 7.0 : isTablet ? 10.0 : 8.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekProgress(List<bool> weekProgress) {
    final weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        final isCompleted = index < weekProgress.length ? weekProgress[index] : false;
        
        return Column(
          children: [
            Text(
              weekDays[index],
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted 
                    ? Colors.white 
                    : Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.purple,
                      size: 16,
                    )
                  : null,
            ),
          ],
        );
      }),
    );
  }
}

class StreakDialog extends ConsumerWidget {
  const StreakDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakData = ref.watch(streakProvider);
    final streakNotifier = ref.read(streakProvider.notifier);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.withOpacity(0.9),
              Colors.blue.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              streakNotifier.getStreakEmoji(),
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 16),
            Text(
              'Your Progress',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildStatRow('Current Streak', '${streakData.currentStreak} days', Icons.local_fire_department),
            const SizedBox(height: 12),
            _buildStatRow('Longest Streak', '${streakData.longestStreak} days', Icons.emoji_events),
            const SizedBox(height: 12),
            _buildStatRow('Total Days', '${streakData.totalDays} days', Icons.calendar_today),
            const SizedBox(height: 24),
            Text(
              streakNotifier.getStreakMessage(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (streakData.currentStreak > 0)
                  TextButton(
                    onPressed: () {
                      _showResetConfirmation(context, ref);
                    },
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showResetConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text(
          'Reset Streak?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to reset your current streak? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(streakProvider.notifier).resetStreak();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
