part of 'leaderboard_cubit.dart';

abstract class LeaderboardState extends Equatable {
  const LeaderboardState();

  @override
  List<Object> get props => [];
}

class LeaderboardInitial extends LeaderboardState {
  const LeaderboardInitial();
}

class LeaderboardError extends LeaderboardState {
  const LeaderboardError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
