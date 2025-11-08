import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/i18n/locale_provider.dart';
import '../data/models/prophet_profile.dart';
import '../data/repos/history_repository.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository();
});

final prophetProfilesProvider = FutureProvider.autoDispose<List<ProphetProfile>>((ref) async {
  final locale = ref.watch(localeProvider).languageCode;
  final repository = ref.watch(historyRepositoryProvider);
  return repository.loadProphets(locale);
});

final prophetProfileProvider = FutureProvider.autoDispose.family<ProphetProfile, String>((ref, String id) async {
  final locale = ref.watch(localeProvider).languageCode;
  final repository = ref.watch(historyRepositoryProvider);
  final profile = await repository.loadProphet(locale, id);
  if (profile == null) {
    throw Exception('Prophet not found');
  }
  return profile;
});
