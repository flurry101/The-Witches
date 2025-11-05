import 'package:flutter/foundation.dart';
import 'package:metropulse/services/station_service.dart';

/// Simple global store for the Home search query. Using a ValueNotifier avoids
/// introducing additional Riverpod provider complexity for this small feature.
class HomeSearchStore {
  /// Current query typed on the Home dashboard. Other parts of the app can
  /// listen to this notifier to react to queries.
  static final ValueNotifier<String?> query = ValueNotifier<String?>(null);

  /// Find the best-matching station id for the given query (exact -> startsWith -> contains).
  static Future<String?> findBestMatch(String? rawQuery) async {
    if (rawQuery == null) return null;
    final q = rawQuery.trim();
    if (q.isEmpty) return null;

    final stations = await StationService.getAllStations();
    final lower = q.toLowerCase();

    for (final s in stations) {
      if (s.name.toLowerCase() == lower) return s.id;
    }
    for (final s in stations) {
      if (s.name.toLowerCase().startsWith(lower)) return s.id;
    }
    for (final s in stations) {
      if (s.name.toLowerCase().contains(lower)) return s.id;
    }
    return null;
  }
}