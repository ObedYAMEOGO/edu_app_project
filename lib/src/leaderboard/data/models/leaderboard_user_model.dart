import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/leaderboard/domain/entities/leaderboard_user.dart';

class LeaderboardUserModel extends LeaderboardUser {
  const LeaderboardUserModel({
    required super.name,
    required super.userId,
    required super.points,
    required super.image,
  });

  const LeaderboardUserModel.empty()
      : this(
          name: '_empty.name',
          userId: '_empty.userId',
          points: 0,
          image: '_empty.image',
        );

  LeaderboardUserModel.fromMap(DataMap map)
      : this(
          name: map['fullName'] as String,
          userId: map['uid'] as String,
          points: (map['points'] as num).toInt(),
          image: map['profilePic'] as String,
        );

  LeaderboardUserModel copyWith({
    String? name,
    String? userId,
    int? points,
    String? image,
  }) {
    return LeaderboardUserModel(
      name: name ?? this.name,
      userId: userId ?? this.userId,
      points: points ?? this.points,
      image: image ?? this.image,
    );
  }

  DataMap toMap() => {
        'fullName': name,
        'uid': userId,
        'points': points,
        'profilePic': image,
      };
}
