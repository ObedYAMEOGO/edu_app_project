import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/leaderboard/domain/entities/leaderboard_user.dart';
import 'package:edu_app_project/src/leaderboard/domain/repos/leaderboard_repo.dart';

class GetLeaderboard extends StreamUsecaseWithoutParams<List<LeaderboardUser>> {
  const GetLeaderboard(this._repo);

  final LeaderboardRepo _repo;

  @override
  ResultStream<List<LeaderboardUser>> call() => _repo.getLeaderboard();
}
