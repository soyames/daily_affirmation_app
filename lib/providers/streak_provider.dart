// lib/providers/streak_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakData {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastVisitDate;
  final int totalDays;
  final int dailyAffirmationsUsed;
  final DateTime? lastAffirmationDate;

  StreakData({
    required this.currentStreak,
    required this.longestStreak,
    this.lastVisitDate,
    required this.totalDays,
    this.dailyAffirmationsUsed = 0,
    this.lastAffirmationDate,
  });

  StreakData copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastVisitDate,
    int? totalDays,
    int? dailyAffirmationsUsed,
    DateTime? lastAffirmationDate,
  }) {
    return StreakData(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastVisitDate: lastVisitDate ?? this.lastVisitDate,
      totalDays: totalDays ?? this.totalDays,
      dailyAffirmationsUsed: dailyAffirmationsUsed ?? this.dailyAffirmationsUsed,
      lastAffirmationDate: lastAffirmationDate ?? this.lastAffirmationDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastVisitDate': lastVisitDate?.millisecondsSinceEpoch,
      'totalDays': totalDays,
      'dailyAffirmationsUsed': dailyAffirmationsUsed,
      'lastAffirmationDate': lastAffirmationDate?.millisecondsSinceEpoch,
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
      lastAffirmationDate: json['lastAffirmationDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastAffirmationDate'])
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
            } else if (value != 'null') {
              data[key] = int.parse(value);
            }
          }
        }
        state = StreakData.fromJson(data);
      } catch (e) {
        // If parsing fails, start fresh
        state = StreakData(currentStreak: 0, longestStreak: 0, totalDays: 0, dailyAffirmationsUsed: 0);
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
    
    if (state.lastVisitDate == null) {
      // First visit ever
      state = state.copyWith(
        currentStreak: 1,
        longestStreak: 1,
        lastVisitDate: today,
        totalDays: 1,
      );
    } else {
      final lastVisit = DateTime(
        state.lastVisitDate!.year,
        state.lastVisitDate!.month,
        state.lastVisitDate!.day,
      );
      
      final daysDifference = today.difference(lastVisit).inDays;
      
      if (daysDifference == 0) {
        // Same day, no change needed
        return;
      } else if (daysDifference == 1) {
        // Consecutive day, increment streak
        final newStreak = state.currentStreak + 1;
        state = state.copyWith(
          currentStreak: newStreak,
          longestStreak: newStreak > state.longestStreak ? newStreak : state.longestStreak,
          lastVisitDate: today,
          totalDays: state.totalDays + 1,
        );
      } else {
        // Streak broken, reset to 1
        state = state.copyWith(
          currentStreak: 1,
          lastVisitDate: today,
          totalDays: state.totalDays + 1,
        );
      }
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

    // Check if it's a new day
    if (state.lastAffirmationDate == null) {
      // First affirmation ever
      state = state.copyWith(
        dailyAffirmationsUsed: 1,
        lastAffirmationDate: today,
      );
    } else {
      final lastAffirmationDay = DateTime(
        state.lastAffirmationDate!.year,
        state.lastAffirmationDate!.month,
        state.lastAffirmationDate!.day,
      );

      if (today.isAtSameMomentAs(lastAffirmationDay)) {
        // Same day, increment usage
        state = state.copyWith(
          dailyAffirmationsUsed: state.dailyAffirmationsUsed + 1,
        );
      } else {
        // New day, reset usage
        state = state.copyWith(
          dailyAffirmationsUsed: 1,
          lastAffirmationDate: today,
        );
      }
    }

    await _saveStreak();
  }

  bool canGenerateNewAffirmation() {
    // Users with 5+ day streak have unlimited affirmations
    if (state.currentStreak >= 5) {
      return true;
    }

    // Check if it's a new day (reset daily limit)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (state.lastAffirmationDate == null) {
      return true; // First time user
    }

    final lastAffirmationDay = DateTime(
      state.lastAffirmationDate!.year,
      state.lastAffirmationDate!.month,
      state.lastAffirmationDate!.day,
    );

    if (!today.isAtSameMomentAs(lastAffirmationDay)) {
      return true; // New day
    }

    // Same day, check limit
    return state.dailyAffirmationsUsed < 20;
  }

  int getRemainingAffirmations() {
    if (state.currentStreak >= 5) {
      return -1; // Unlimited
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (state.lastAffirmationDate == null) {
      return 20; // First time user
    }

    final lastAffirmationDay = DateTime(
      state.lastAffirmationDate!.year,
      state.lastAffirmationDate!.month,
      state.lastAffirmationDate!.day,
    );

    if (!today.isAtSameMomentAs(lastAffirmationDay)) {
      return 20; // New day
    }

    return 20 - state.dailyAffirmationsUsed;
  }

  String getStreakMessage() {
    if (state.currentStreak == 0) {
      return "Start your journey today! 🌟";
    } else if (state.currentStreak == 1) {
      return "Great start! Keep it up! 💪";
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
