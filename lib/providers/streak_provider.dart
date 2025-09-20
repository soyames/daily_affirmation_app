// lib/providers/streak_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'notification_provider.dart';


class StreakData {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastVisitDate;
  final int totalDays;
  final int dailyAffirmationsUsed;
  final int availableAffirmations;
  final DateTime? lastAffirmationDate;
  final DateTime? firstUseDate;

  StreakData({
    required this.currentStreak,
    required this.longestStreak,
    this.lastVisitDate,
    required this.totalDays,
    this.dailyAffirmationsUsed = 0,
    this.availableAffirmations = 20,
    this.lastAffirmationDate,
    this.firstUseDate,
  });

  StreakData copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastVisitDate,
    int? totalDays,
    int? dailyAffirmationsUsed,
    int? availableAffirmations,
    DateTime? lastAffirmationDate,
    DateTime? firstUseDate,
  }) {
    return StreakData(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastVisitDate: lastVisitDate ?? this.lastVisitDate,
      totalDays: totalDays ?? this.totalDays,
      dailyAffirmationsUsed: dailyAffirmationsUsed ?? this.dailyAffirmationsUsed,
      availableAffirmations: availableAffirmations ?? this.availableAffirmations,
      lastAffirmationDate: lastAffirmationDate ?? this.lastAffirmationDate,
      firstUseDate: firstUseDate ?? this.firstUseDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastVisitDate': lastVisitDate?.millisecondsSinceEpoch,
      'totalDays': totalDays,
      'dailyAffirmationsUsed': dailyAffirmationsUsed,
      'availableAffirmations': availableAffirmations,
      'lastAffirmationDate': lastAffirmationDate?.millisecondsSinceEpoch,
      'firstUseDate': firstUseDate?.millisecondsSinceEpoch,
    };
  }

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastVisitDate: json['lastVisitDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastVisitDate'])
          : null,
      totalDays: json['totalDays'] ?? 0,
      dailyAffirmationsUsed: json['dailyAffirmationsUsed'] ?? 0,
      availableAffirmations: json['availableAffirmations'] ?? 20,
      lastAffirmationDate: json['lastAffirmationDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastAffirmationDate'])
          : null,
      firstUseDate: json['firstUseDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['firstUseDate'])
          : null,
    );
  }
}

class StreakNotifier extends StateNotifier<StreakData> {
  StreakNotifier() : super(StreakData(currentStreak: 0, longestStreak: 0, totalDays: 0, dailyAffirmationsUsed: 0)) {
    _loadStreak();
  }

  static const String _streakKey = 'streak_data';

  Future<void> _loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final streakJson = prefs.getString(_streakKey);
    if (streakJson != null) {
      try {
        final Map<String, dynamic> data = {};
        final parts = streakJson.split(',');
        for (String part in parts) {
          final keyValue = part.split(':');
          if (keyValue.length == 2) {
            final key = keyValue[0].trim();
            final value = keyValue[1].trim();
            if (key == 'lastVisitDate' && value != 'null') {
              data[key] = int.parse(value);
            } else if (key == 'firstUseDate' && value != 'null') {
              data[key] = int.parse(value);
            } else if (value != 'null') {
              data[key] = int.parse(value);
            }
          }
        }
        state = StreakData.fromJson(data);
      } catch (e) {
        // If parsing fails, start fresh
        state = StreakData(currentStreak: 0, longestStreak: 0, totalDays: 0, dailyAffirmationsUsed: 0, firstUseDate: null);
      }
    }
  }

  Future<void> _saveStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final data = state.toJson();
    final streakString = 'currentStreak:${data['currentStreak']},longestStreak:${data['longestStreak']},lastVisitDate:${data['lastVisitDate']},totalDays:${data['totalDays']},dailyAffirmationsUsed:${data['dailyAffirmationsUsed']},lastAffirmationDate:${data['lastAffirmationDate']}';
    await prefs.setString(_streakKey, streakString);
  }

  Future<void> recordVisit() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int missedDays = 0;
    bool firstVisit = false;
    if (state.lastVisitDate == null) {
      // First visit ever
      state = state.copyWith(
        currentStreak: 1,
        longestStreak: 1,
        lastVisitDate: today,
        totalDays: 1,
        firstUseDate: today,
      );
      firstVisit = true;
    } else {
      final lastVisit = DateTime(
        state.lastVisitDate!.year,
        state.lastVisitDate!.month,
        state.lastVisitDate!.day,
      );
      missedDays = today.difference(lastVisit).inDays - 1;
      int newStreak = state.currentStreak;
      if (today.difference(lastVisit).inDays > 0) {
        // Always increment streak by 1 for each new day, never reset
        newStreak += 1;
        state = state.copyWith(
          currentStreak: newStreak,
          longestStreak: newStreak > state.longestStreak ? newStreak : state.longestStreak,
          lastVisitDate: today,
          totalDays: state.totalDays + 1,
        );
      } else {
        // Same day, no change needed
        return;
      }
      // If firstUseDate is not set, set it now (for users upgrading)
      if (state.firstUseDate == null) {
        state = state.copyWith(firstUseDate: today);
      }
    }
    // Save missed days for display and notify
    if (missedDays > 0) {
      // Add missedDays * 20 to quota and notify
      final newQuota = state.availableAffirmations + (missedDays * 20);
      state = state.copyWith(availableAffirmations: newQuota);
      // Send notification for quota addition
      await NotificationService.sendImmediateNotification(
        title: 'Affirmation Quota Added',
        body: 'You missed $missedDays day(s). ${{missedDays * 20}} extra affirmations added to your quota!'
      );
    }
    // Check for unlimited unlock (after 7 days)
    if (state.firstUseDate != null) {
      final daysSinceFirstUse = today.difference(DateTime(state.firstUseDate!.year, state.firstUseDate!.month, state.firstUseDate!.day)).inDays;
      if (daysSinceFirstUse == 7) {
        await NotificationService.sendImmediateNotification(
          title: 'Unlimited Affirmations Unlocked!',
          body: 'Congratulations! You can now enjoy unlimited daily affirmations.'
        );
      }
    }
    // On first visit, enable daily notification by default
    if (firstVisit) {
      // Schedule daily notification at 9:00 AM by default
      await NotificationService.scheduleDaily(hour: 9, minute: 0, enabled: true);
    }
    await _saveStreak();
  }

  Future<void> resetStreak() async {
    state = StreakData(currentStreak: 0, longestStreak: state.longestStreak, totalDays: 0, dailyAffirmationsUsed: 0);
    await _saveStreak();
  }

  Future<void> recordAffirmationUsage() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int available = state.availableAffirmations;
    int used = state.dailyAffirmationsUsed;

    // Only apply quota logic for first 7 days
    if (state.firstUseDate != null) {
      final daysSinceFirstUse = today.difference(DateTime(state.firstUseDate!.year, state.firstUseDate!.month, state.firstUseDate!.day)).inDays;
      if (daysSinceFirstUse < 7) {
        // Calculate missed days and roll over quota
        int missedDays = 0;
        if (state.lastAffirmationDate != null) {
          final lastDay = DateTime(state.lastAffirmationDate!.year, state.lastAffirmationDate!.month, state.lastAffirmationDate!.day);
          missedDays = today.difference(lastDay).inDays;
          if (missedDays > 0) {
            available += missedDays * 20;
            used = 0;
          }
        }
        // Use one affirmation
        if (available > 0) {
          available -= 1;
          used += 1;
        }
        state = state.copyWith(
          availableAffirmations: available,
          dailyAffirmationsUsed: used,
          lastAffirmationDate: today,
        );
      } else {
        // After 7 days, unlimited
        state = state.copyWith(
          availableAffirmations: -1,
          dailyAffirmationsUsed: 0,
          lastAffirmationDate: today,
        );
      }
    } else {
      // Fallback: treat as first use
      state = state.copyWith(
        availableAffirmations: 19,
        dailyAffirmationsUsed: 1,
        lastAffirmationDate: today,
      );
    }
    await _saveStreak();
  }

  bool canGenerateNewAffirmation() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (state.firstUseDate != null) {
      final daysSinceFirstUse = today.difference(DateTime(state.firstUseDate!.year, state.firstUseDate!.month, state.firstUseDate!.day)).inDays;
      if (daysSinceFirstUse >= 7) {
        return true; // Unlimited
      }
      return state.availableAffirmations > 0;
    }
    // Fallback: allow if available
    return state.availableAffirmations > 0;
  }

  int getRemainingAffirmations() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (state.firstUseDate != null) {
      final daysSinceFirstUse = today.difference(DateTime(state.firstUseDate!.year, state.firstUseDate!.month, state.firstUseDate!.day)).inDays;
      if (daysSinceFirstUse >= 7) {
        return -1; // Unlimited
      }
      return state.availableAffirmations;
    }
    return state.availableAffirmations;
  }

  String getStreakMessage({int? missedDays}) {
    final missed = missedDays ?? 0;
    if (state.currentStreak == 0) {
      return "Start your journey today! 🌟";
    } else if (state.currentStreak == 1) {
      return "Great start! Keep it up! 💪";
    } else if (missed > 0) {
      return "You've missed $missed day(s), but your streak continues! Current streak: ${state.currentStreak} days.";
    } else if (state.currentStreak < 7) {
      return "Building momentum! ${state.currentStreak} days strong! 🔥";
    } else if (state.currentStreak < 30) {
      return "Amazing streak! ${state.currentStreak} days of positivity! ⭐";
    } else {
      return "Incredible! ${state.currentStreak} days of daily affirmations! 🏆";
    }
  }

  String getStreakEmoji() {
    if (state.currentStreak == 0) return "🌱";
    if (state.currentStreak < 3) return "🌿";
    if (state.currentStreak < 7) return "🔥";
    if (state.currentStreak < 14) return "⭐";
    if (state.currentStreak < 30) return "💎";
    return "🏆";
  }

  List<bool> getWeekProgress() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    
    List<bool> progress = [];
    
    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      
      if (state.lastVisitDate != null) {
        final lastVisit = DateTime(
          state.lastVisitDate!.year,
          state.lastVisitDate!.month,
          state.lastVisitDate!.day,
        );
        
        // Check if this day is within the current streak
        final daysDiff = today.difference(day).inDays;
        final streakDaysDiff = today.difference(lastVisit).inDays;
        
        if (daysDiff >= 0 && daysDiff <= streakDaysDiff && daysDiff < state.currentStreak) {
          progress.add(true);
        } else {
          progress.add(false);
        }
      } else {
        progress.add(false);
      }
    }
    
    return progress;
  }
}

final streakProvider = StateNotifierProvider<StreakNotifier, StreakData>((ref) {
  return StreakNotifier();
});
