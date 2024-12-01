import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/src/leaderboard/data/models/leaderboard_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class LeaderboardRemoteDataSrc {
  const LeaderboardRemoteDataSrc();

  Stream<List<LeaderboardUserModel>> getLeaderboard();
}

class LeaderboardRemoteDataSrcImpl implements LeaderboardRemoteDataSrc {
  const LeaderboardRemoteDataSrcImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _store = firestore,
        _auth = auth;

  final FirebaseFirestore _store;
  final FirebaseAuth _auth;

  @override
  Stream<List<LeaderboardUserModel>> getLeaderboard() {
    try {
      if (_auth.currentUser == null) {
        return Stream.error(
          const ServerException(
            message: 'User not authenticated',
            statusCode: '401',
          ),
        );
      }
      final leaderboardStream = _store
          .collection('users')
          .orderBy('points', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => LeaderboardUserModel.fromMap(doc.data()))
                .take(10)
                .toList(),
          );
      return leaderboardStream.handleError(
        (Object error) {
          if (error is FirebaseException) {
            throw ServerException(
              message: error.message ?? 'Unknown Error Occurred',
              statusCode: error.code,
            );
          } else {
            throw ServerException(message: error.toString(), statusCode: '500');
          }
        },
      );
    } on FirebaseException catch (e) {
      return Stream.error(
        ServerException(
          message: e.message ?? 'Unknown Error Occurred',
          statusCode: e.code,
        ),
      );
    } catch (e) {
      return Stream.error(
        ServerException(message: e.toString(), statusCode: '500'),
      );
    }
  }
}
