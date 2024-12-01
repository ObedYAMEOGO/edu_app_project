import 'package:edu_app_project/src/authentication/data/models/user_model.dart';
import 'package:edu_app_project/src/leaderboard/data/datasources/leaderboard_remote_data_src.dart';
import 'package:edu_app_project/src/leaderboard/data/models/leaderboard_user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late LeaderboardRemoteDataSrc remoteDataSource;
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    final user = MockUser(
      uid: 'uid',
      email: 'email',
      displayName: 'displayName',
    );
    final googleSignIn = MockGoogleSignIn();
    final signInAccount = await googleSignIn.signIn();
    final googleAuth = await signInAccount!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    auth = MockFirebaseAuth(mockUser: user);
    await auth.signInWithCredential(credential);

    remoteDataSource =
        LeaderboardRemoteDataSrcImpl(firestore: firestore, auth: auth);
  });

  group('getLeaderboard', () {
    test(
      'should emit [List<LeaderboardUserModel>] when call is successful',
      () async {
        const emptyUser = LocalUserModel.empty();
        final users = [
          emptyUser,
          emptyUser.copyWith(
            uid: 'second uid',
            fullName: 'Second User',
            points: 100,
          ),
        ];
        for (final user in users) {
          await firestore.collection('users').add(user.toMap());
        }

        // ACT
        final result = remoteDataSource.getLeaderboard();

        expect(
          result,
          emitsInOrder([
            equals([
              LeaderboardUserModel(
                userId: 'second uid',
                image: emptyUser.profilePic!,
                points: 100,
                name: 'Second User',
              ),
              LeaderboardUserModel(
                userId: emptyUser.uid,
                image: emptyUser.profilePic!,
                points: emptyUser.points,
                name: emptyUser.fullName,
              ),
            ]),
          ]),
        );
      },
    );

    test(
      'should emit empty list when call is unsuccessful',
      () {
        final result = remoteDataSource.getLeaderboard();
        expect(result, emitsInOrder([]));
      },
    );
  });
}
