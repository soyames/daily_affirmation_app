// lib/providers/affirmation_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'offline_provider.dart';
import 'streak_provider.dart';

// Affirmation Data Model
class Affirmation {
  final int affirmationIndex;
  final String imageUrl;
  final String? photographerName;
  final String? photographerProfileUrl;

  Affirmation({
    required this.affirmationIndex,
    required this.imageUrl,
    this.photographerName,
    this.photographerProfileUrl,
  });

  Map<String, dynamic> toJson() => {
        'affirmationIndex': affirmationIndex,
        'imageUrl': imageUrl,
        'photographerName': photographerName,
        'photographerProfileUrl': photographerProfileUrl,
      };

  factory Affirmation.fromJson(Map<String, dynamic> json) {
    return Affirmation(
      affirmationIndex: json['affirmationIndex'] as int,
      imageUrl: json['imageUrl'] as String,
      photographerName: json['photographerName'] as String?,
      photographerProfileUrl: json['photographerProfileUrl'] as String?,
    );
  }
}

// A more robust state class that includes the affirmation and its favorite status
class AffirmationState {
  final Affirmation currentAffirmation;
  final bool isFavorited;

  AffirmationState({required this.currentAffirmation, this.isFavorited = false});
}

// NEW: Provider to manage the list of favorited affirmations
class FavoritesNotifier extends StateNotifier<List<Affirmation>> {
  FavoritesNotifier() : super([]);

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoritesJson = prefs.getStringList('favorites');
    if (favoritesJson != null) {
      state = favoritesJson.map((jsonString) {
        return Affirmation.fromJson(json.decode(jsonString));
      }).toList();
    }
  }

  Future<void> toggleFavorite(Affirmation affirmation) async {
    final isFavorited = state.any((fav) => fav.affirmationIndex == affirmation.affirmationIndex);
    
    if (isFavorited) {
      state = state.where((fav) => fav.affirmationIndex != affirmation.affirmationIndex).toList();
    } else {
      state = [...state, affirmation];
    }
    
    _saveFavorites();
  }
  
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favoritesJson = state.map((affirmation) {
      return json.encode(affirmation.toJson());
    }).toList();
    await prefs.setStringList('favorites', favoritesJson);
  }
}

// Original AffirmationNotifier, now depends on FavoritesNotifier
class AffirmationNotifier extends StateNotifier<AsyncValue<AffirmationState>> {
  AffirmationNotifier(this.ref) : super(const AsyncValue.loading()) {
    getNewAffirmation();
  }
  
  final Ref ref;
  static const int numberOfAffirmations = 106;

  /// Adds UTM parameters to Unsplash URLs for proper attribution
  String _addUTMParameters(String url) {
    final uri = Uri.parse(url);
    final queryParams = Map<String, String>.from(uri.queryParameters);

    // Add UTM parameters as required by Unsplash API guidelines
    queryParams['utm_source'] = 'daily_affirmation_app';
    queryParams['utm_medium'] = 'referral';

    return uri.replace(queryParameters: queryParams).toString();
  }
  
  Future<void> getNewAffirmation() async {
    state = const AsyncValue.loading();
    try {
      final favoritesList = ref.read(favoritesProvider);
      final offlineCache = ref.read(offlineCacheProvider);

      // Check if offline mode is enabled and we have cached affirmations
      if (offlineCache.isOfflineMode && offlineCache.cachedAffirmations.isNotEmpty) {
        final cachedAffirmation = ref.read(offlineCacheProvider.notifier).getRandomCachedAffirmation();
        if (cachedAffirmation != null) {
          final isFavorited = favoritesList.any((fav) => fav.affirmationIndex == cachedAffirmation.affirmationIndex);
          state = AsyncValue.data(AffirmationState(
            currentAffirmation: cachedAffirmation,
            isFavorited: isFavorited,
          ));
          return;
        }
      }

      final randomAffirmationIndex = Random().nextInt(numberOfAffirmations) + 1;

      final apiKey = dotenv.env['UNSPLASH_ACCESS_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('Unsplash API key not found. Please check your .env file.');
      }

      final response = await http.get(Uri.parse('https://api.unsplash.com/photos/random?query=nature,landscape,abstract'),
          headers: {'Authorization': 'Client-ID $apiKey'});

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final imageUrl = data['urls']['regular'];
        final photographerName = data['user']['name'];
        final rawPhotographerProfileUrl = data['user']['links']['html'];
        final photographerProfileUrl = _addUTMParameters(rawPhotographerProfileUrl);
        final downloadUrl = data['links']['download_location'];

        await http.get(Uri.parse('$downloadUrl?client_id=$apiKey'));

        final newAffirmation = Affirmation(
          affirmationIndex: randomAffirmationIndex,
          imageUrl: imageUrl,
          photographerName: photographerName,
          photographerProfileUrl: photographerProfileUrl,
        );
        
        final isFavorited = favoritesList.any((fav) => fav.affirmationIndex == newAffirmation.affirmationIndex);
        
        state = AsyncValue.data(AffirmationState(
          currentAffirmation: newAffirmation,
          isFavorited: isFavorited,
        ));

        // Cache the affirmation for offline use
        ref.read(offlineCacheProvider.notifier).cacheAffirmation(newAffirmation);

        // Record affirmation usage for daily limits
        ref.read(streakProvider.notifier).recordAffirmationUsage();
      } else {
        final errorBody = response.body.isNotEmpty ? response.body : 'No error details provided';
        throw Exception('Failed to load image from Unsplash. Status code: ${response.statusCode}. Error: $errorBody');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Force refresh the current affirmation state
  void forceRefresh() {
    getNewAffirmation();
  }
}

final affirmationProvider = StateNotifierProvider<AffirmationNotifier, AsyncValue<AffirmationState>>((ref) {
  return AffirmationNotifier(ref);
});

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Affirmation>>((ref) {
  return FavoritesNotifier()..loadFavorites();
});