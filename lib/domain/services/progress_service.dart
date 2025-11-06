import '../../data/repos/progress_repo.dart';

class ProgressService {
  ProgressService(this._repo);

  final ProgressRepository _repo;

  Future<double> overall() {
    return _repo.overallPercent();
  }

  Future<void> mark({required String contentId, required double percent}) {
    return _repo.markCompleted(contentId: contentId, percent: percent);
  }
}
