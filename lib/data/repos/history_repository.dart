import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/prophet_profile.dart';

class HistoryRepository {
  HistoryRepository();

  final Map<String, List<ProphetProfile>> _prophetCache = {};

  Future<List<ProphetProfile>> loadProphets(String locale) async {
    if (_prophetCache.containsKey(locale)) {
      return _prophetCache[locale]!;
    }
    final raw = await rootBundle.loadString('assets/content/$locale/history/prophets.json');
    final data = jsonDecode(raw) as List<dynamic>;
    final profiles = data
        .map((item) => ProphetProfile.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
    _prophetCache[locale] = profiles;
    return profiles;
  }

  Future<ProphetProfile?> loadProphet(String locale, String id) async {
    final profiles = await loadProphets(locale);
    return profiles.firstWhereOrNull((element) => element.id == id);
  }
}
