import 'package:collection/collection.dart';

import '../../core/utils/date_utils.dart';
import '../local/dao/progress_dao.dart';
import '../models/progress.dart';

class ProgressRepository {
  ProgressRepository(this._dao);

  final ProgressDao _dao;

  Future<double> overallPercent() async {
    final items = await _dao.fetchAll();
    if (items.isEmpty) {
      return 0;
    }
    return items.map((e) => e.percent).average;
  }

  Future<Progress?> getByContent(String contentId) async {
    final items = await _dao.fetchAll();
    return items.firstWhereOrNull((element) => element.contentId == contentId);
  }

  Future<void> markCompleted({
    required String contentId,
    required double percent,
  }) async {
    final id = 'progress-$contentId';
    final record = Progress(
      id: id,
      contentId: contentId,
      completed: percent >= 1,
      percent: percent.clamp(0, 1),
      updatedAt: AppDateUtils.encodeDate(DateTime.now()),
    );
    await _dao.save(record);
  }
}
