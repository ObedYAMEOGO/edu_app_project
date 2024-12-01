import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/leaderboard/domain/entities/leaderboard_user.dart';

abstract class LeaderboardRepo {
  const LeaderboardRepo();

  ResultStream<List<LeaderboardUser>> getLeaderboard();
}
