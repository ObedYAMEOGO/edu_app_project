import 'package:dartz/dartz.dart';
import 'package:edu_app_project/src/leaderboard/domain/entities/leaderboard_user.dart';
import 'package:edu_app_project/src/leaderboard/domain/usecases/get_leaderboard.dart';

class LeaderboardNotifier {
  const LeaderboardNotifier(this._getLeaderboard);

  final GetLeaderboard _getLeaderboard;

  Stream<Either<String, List<LeaderboardUser>>> getLeaderboard() {
    return _getLeaderboard().map(
      (result) {
        return result.fold(
          (failure) => Left('${failure.statusCode}: ${failure.message}'),
          Right.new,
        );
      },
    );
  }
}
