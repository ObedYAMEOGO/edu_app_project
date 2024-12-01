import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/common/features/user/data/datasources/user_remote_data_source.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/src/authentication/data/models/user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late FirebaseAuth auth;
  late FirebaseFirestore firestore;
  late UserRemoteDataSource dataSource;

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
    dataSource = UserRemoteDataSourceImpl(
      auth: auth,
      firestore: firestore,
    );
  });

  group('getUserById', () {
    test('should return a user when the call is successful', () async {
      // Arrange
      const userId = 'uid';
      final expectedUser = const LocalUserModel.empty().copyWith(uid: userId);
      await firestore.collection('users').doc(userId).set(expectedUser.toMap());

      // Act
      final result = await dataSource.getUserById(userId);

      // Assert
      expect(result, equals(expectedUser));
    });

    test(
      'should throw ServerException when the call is unsuccessful',
      () async {
        // Arrange
        const userId = 'uid';

        // Act
        final call = dataSource.getUserById;

        // Assert
        expect(() => call(userId), throwsA(isA<ServerException>()));
      },
    );
  });

  group('addPoints', () {
    test('should increase user points when the call is successful', () async {
      // Arrange
      const userId = 'uid';
      const points = 10;
      final expectedUser = const LocalUserModel.empty().copyWith(uid: userId);
      await firestore.collection('users').doc(userId).set(expectedUser.toMap());

      // Act
      await dataSource.addPoints(userId: userId, points: points);

      // Assert
      final userDoc = await firestore.collection('users').doc(userId).get();
      expect(userDoc.data()!['points'], equals(expectedUser.points + points));
    });

    test(
      'should throw ServerException when the call is unsuccessful',
      () async {
        // Arrange
        const userId = 'uid';
        const points = 10;

        // Act
        final call = dataSource.addPoints;

        // Assert
        expect(
          () => call(userId: userId, points: points),
          throwsA(
            isA<ServerException>(),
          ),
        );
      },
    );
  });
}
