import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/dao/progress_dao.dart';
import '../data/repos/progress_repo.dart';
import '../domain/services/progress_service.dart';
import 'prefs_providers.dart';

final progressDaoProvider = FutureProvider<ProgressDao>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return ProgressDao(db);
});

final progressRepositoryProvider = FutureProvider<ProgressRepository>((ref) async {
  final dao = await ref.watch(progressDaoProvider.future);
  return ProgressRepository(dao);
});

final progressServiceProvider = FutureProvider<ProgressService>((ref) async {
  final repo = await ref.watch(progressRepositoryProvider.future);
  return ProgressService(repo);
});

final overallProgressProvider = FutureProvider<double>((ref) async {
  final service = await ref.watch(progressServiceProvider.future);
  return service.overall();
});
