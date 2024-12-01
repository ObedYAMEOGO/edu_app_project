import 'package:edu_app_project/core/enums/subscription_enum.dart';
import 'package:edu_app_project/core/utils/constants.dart';
import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
    required this.email,
    required this.points,
    required this.fullName,
    this.profilePic,
    this.bio,
    this.dateSubscribed,
    this.subscription,
    this.groupIds = const [],
    this.enrolledCourseIds = const [],
    this.following = const [],
    this.followers = const [],
  });

  const LocalUser.empty()
      : this(
          uid: '',
          email: '',
          points: 0,
          fullName: '',
          profilePic: '',
          bio: '',
          groupIds: const [],
          enrolledCourseIds: const [],
          following: const [],
          followers: const [],
        );

  @override
  String toString() {
    return 'LocalUser{uid: $uid, email: $email, bio: $bio, fullName: '
        '$fullName}';
  }

  final String uid;
  final String email;
  final String? profilePic;
  final DateTime? dateSubscribed;
  final Subscription? subscription;
  final String? bio;
  final int points;
  final String fullName;
  final List<String> groupIds;
  final List<String> enrolledCourseIds;
  final List<String> following;
  final List<String> followers;

  bool get isAdmin => kAdmins.contains(email);

  bool get subscribed {
    // Check if subscription and dateSubscribed are not null
    if (subscription != null && dateSubscribed != null) {
      // Calculate the difference in months between the current date
      // and dateSubscribed
      final monthsDifference =
          DateTime.now().difference(dateSubscribed!).inDays ~/ 30;

      // Check if the subscription is still active based on its code
      // and months difference
      return switch (subscription) {
        Subscription.MONTHLY => monthsDifference < 1,
        Subscription.QUARTERLY => monthsDifference < 3,
        Subscription.ANNUALLY => monthsDifference < 12,
        _ => false,
      };
    }

    // Return false if subscription or dateSubscribed is null
    return false;
  }

  @override
  List<dynamic> get props => [
        uid,
        email,
        profilePic,
        bio,
        points,
        fullName,
        groupIds.length,
        enrolledCourseIds.length,
        following.length,
        followers.length,
        subscription,
        dateSubscribed?.millisecondsSinceEpoch,
      ];
}
