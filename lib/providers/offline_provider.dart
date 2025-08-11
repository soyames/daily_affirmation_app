// lib/providers/offline_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import 'affirmation_provider.dart';

class OfflineAffirmation {
  final int affirmationIndex;
  final String imageUrl;
  final String? photographerName;
  final String? photographerProfileUrl;
  final DateTime cachedAt;

  OfflineAffirmation({
    required this.affirmationIndex,
    required this.imageUrl,
    this.photographerName,
    this.photographerProfileUrl,
    required this.cachedAt,
  });

  Map<String, dynamic> toJson() => {
        'affirmationIndex': affirmationIndex,
        'imageUrl': imageUrl,
        'photographerName': photographerName,
        'photographerProfileUrl': photographerProfileUrl,
        'cachedAt': cachedAt.millisecondsSinceEpoch,
      };

  factory OfflineAffirmation.fromJson(Map<String, dynamic> json) {
    return OfflineAffirmation(
      affirmationIndex: json['affirmationIndex'] as int,
      imageUrl: json['imageUrl'] as String,
      photographerName: json['photographerName'] as String?,
      photographerProfileUrl: json['photographerProfileUrl'] as String?,
      cachedAt: DateTime.fromMillisecondsSinceEpoch(json['cachedAt'] as int),
    );
  }

  Affirmation toAffirmation() {
    return Affirmation(
      affirmationIndex: affirmationIndex,
      imageUrl: imageUrl,
      photographerName: photographerName,
      photographerProfileUrl: photographerProfileUrl,
    );
  }
}

class OfflineCache {
  final List<OfflineAffirmation> cachedAffirmations;
  final bool isOfflineMode;

  OfflineCache({
    required this.cachedAffirmations,
    required this.isOfflineMode,
  });

  OfflineCache copyWith({
    List<OfflineAffirmation>? cachedAffirmations,
    bool? isOfflineMode,
  }) {
    return OfflineCache(
      cachedAffirmations: cachedAffirmations ?? this.cachedAffirmations,
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
    );
  }
}

class OfflineCacheNotifier extends StateNotifier<OfflineCache> {
  OfflineCacheNotifier() : super(OfflineCache(cachedAffirmations: [], isOfflineMode: false)) {
    _loadCache();
  }

  static const String _cacheKey = 'offline_affirmations';
  static const String _offlineModeKey = 'offline_mode';
  static const int maxCacheSize = 50; // Maximum number of cached affirmations
  static const int cacheExpiryDays = 7; // Cache expires after 7 days

  Future<void> _loadCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cacheJson = prefs.getStringList(_cacheKey);
    final isOfflineMode = prefs.getBool(_offlineModeKey) ?? false;

    if (cacheJson != null) {
      try {
        final cachedAffirmations = cacheJson.map((jsonString) {
          return OfflineAffirmation.fromJson(json.decode(jsonString));
        }).toList();

        // Remove expired cache entries
        final now = DateTime.now();
        final validCache = cachedAffirmations.where((affirmation) {
          return now.difference(affirmation.cachedAt).inDays < cacheExpiryDays;
        }).toList();

        state = OfflineCache(
          cachedAffirmations: validCache,
          isOfflineMode: isOfflineMode,
        );

        // Save cleaned cache
        if (validCache.length != cachedAffirmations.length) {
          await _saveCache();
        }
      } catch (e) {
        // If parsing fails, start with empty cache
        state = OfflineCache(cachedAffirmations: [], isOfflineMode: isOfflineMode);
      }
    } else {
      state = OfflineCache(cachedAffirmations: [], isOfflineMode: isOfflineMode);
    }
  }

  Future<void> _saveCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cacheJson = state.cachedAffirmations.map((affirmation) {
      return json.encode(affirmation.toJson());
    }).toList();
    await prefs.setStringList(_cacheKey, cacheJson);
    await prefs.setBool(_offlineModeKey, state.isOfflineMode);
  }

  Future<void> cacheAffirmation(Affirmation affirmation) async {
    final offlineAffirmation = OfflineAffirmation(
      affirmationIndex: affirmation.affirmationIndex,
      imageUrl: affirmation.imageUrl,
      photographerName: affirmation.photographerName,
      photographerProfileUrl: affirmation.photographerProfileUrl,
      cachedAt: DateTime.now(),
    );

    // Check if already cached
    final existingIndex = state.cachedAffirmations.indexWhere(
      (cached) => cached.affirmationIndex == affirmation.affirmationIndex,
    );

    List<OfflineAffirmation> updatedCache;
    if (existingIndex != -1) {
      // Update existing cache entry
      updatedCache = [...state.cachedAffirmations];
      updatedCache[existingIndex] = offlineAffirmation;
    } else {
      // Add new cache entry
      updatedCache = [...state.cachedAffirmations, offlineAffirmation];
      
      // Remove oldest entries if cache is full
      if (updatedCache.length > maxCacheSize) {
        updatedCache.sort((a, b) => a.cachedAt.compareTo(b.cachedAt));
        updatedCache = updatedCache.sublist(updatedCache.length - maxCacheSize);
      }
    }

    state = state.copyWith(cachedAffirmations: updatedCache);
    await _saveCache();
  }

  Affirmation? getRandomCachedAffirmation() {
    if (state.cachedAffirmations.isEmpty) return null;
    
    final randomIndex = Random().nextInt(state.cachedAffirmations.length);
    return state.cachedAffirmations[randomIndex].toAffirmation();
  }

  Future<void> toggleOfflineMode() async {
    state = state.copyWith(isOfflineMode: !state.isOfflineMode);
    await _saveCache();
  }

  Future<void> clearCache() async {
    state = state.copyWith(cachedAffirmations: []);
    await _saveCache();
  }

  bool hasAffirmationCached(int affirmationIndex) {
    return state.cachedAffirmations.any(
      (cached) => cached.affirmationIndex == affirmationIndex,
    );
  }

  int get cacheSize => state.cachedAffirmations.length;
  
  double get cacheUsagePercentage => (cacheSize / maxCacheSize) * 100;

  String get cacheStatusMessage {
    if (state.cachedAffirmations.isEmpty) {
      return "No affirmations cached";
    }
    return "$cacheSize/$maxCacheSize affirmations cached";
  }
}

final offlineCacheProvider = StateNotifierProvider<OfflineCacheNotifier, OfflineCache>((ref) {
  return OfflineCacheNotifier();
});
