import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:edu_app_project/src/leaderboard/domain/entities/leaderboard_user.dart';
import 'package:edu_app_project/src/leaderboard/domain/usecases/get_leaderboard.dart';
import 'package:equatable/equatable.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit(this._getLeaderboard) : super(const LeaderboardInitial());

  final GetLeaderboard _getLeaderboard;

  Stream<Either<LeaderboardError, List<LeaderboardUser>>> getLeaderboard() {
    return _getLeaderboard().map(
      (result) {
        return result.fold(
          (failure) => Left(
            LeaderboardError('${failure.statusCode}: ${failure.message}'),
          ),
          Right.new,
        );
      },
    );
  }
}
