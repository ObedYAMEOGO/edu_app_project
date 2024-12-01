import 'package:equatable/equatable.dart';

class LeaderboardUser extends Equatable {
  const LeaderboardUser({
    required this.name,
    required this.userId,
    required this.points,
    required this.image,
  });

  const LeaderboardUser.empty()
      : this(
          name: '_empty.name',
          userId: '_empty.userId',
          points: 0,
          image: '_empty.image',
        );

  final String name;
  final String userId;
  final int points;
  final String image;

  @override
  List<Object?> get props => [userId, name, points];
}
