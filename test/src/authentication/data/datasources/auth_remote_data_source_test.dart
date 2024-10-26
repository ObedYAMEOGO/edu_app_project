


import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/enums/update_user.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/src/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:edu_app_project/src/authentication/data/models/user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  String _uid = 'Test uid';

  @override
  String get uid => _uid;

  set uid(String value) {
    if (_uid != value) _uid = value;
  }
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;
  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) _user = value;
  }
}

class MockAuthCredential extends Mock implements AuthCredential {}

void main() {
  late MockFirebaseAuth authClient;
  late FakeFirebaseFirestore cloudStoreClient;
  late MockFirebaseStorage dbClient;
  late AuthRemoteDataSource dataSource;
  late MockUser mockUser;
  late DocumentReference<Map<String, dynamic>> docReference;
  late MockUserCredential tUserCredential;
  const tUser = LocalUserModel.empty();

  setUpAll(() async {
    cloudStoreClient = FakeFirebaseFirestore();
    docReference = await cloudStoreClient.collection('users').add(
          tUser.toMap(),
        );
    await cloudStoreClient.collection('users').doc(docReference.id).update(
      {'uid': docReference.id},
    );
    mockUser = MockUser()..uid = docReference.id;
    tUserCredential = MockUserCredential(mockUser);
    dbClient = MockFirebaseStorage();
    authClient = MockFirebaseAuth();
    when(() => authClient.currentUser).thenReturn(mockUser);
    dataSource = AuthRemoteDataSourceImpl(
      authClient: authClient,
      cloudStoreClient: cloudStoreClient,
      dbClient: dbClient,
    );
  });

  const tPassword = 'Test password';
  const tFullName = 'Test full name';
  const tEmail = 'Test email';
  final tFirebaseAuthException = FirebaseAuthException(
    code: 'Utilisateur introuvable',
    message: 'Aucun utilisateur correspondant a cet identifiant.',
  );

  group('forgotPassword', () {
    test(
      'should complete successfully when no [Exception] is thrown',
      () async {
        when(
          () => authClient.sendPasswordResetEmail(email: any(named: 'email')),
        ).thenAnswer((_) async => Future.value());

        final call = dataSource.forgotPassword(tEmail);

        expect(call, completes);

        verify(() => authClient.sendPasswordResetEmail(email: tEmail))
            .called(1);

        verifyNoMoreInteractions(authClient);
      },
    );

    test(
      'should throw [ServerException] when [FirebaseAuthException] is thrown',
      () async {
        when(
          () => authClient.sendPasswordResetEmail(email: any(named: 'email')),
        ).thenThrow(tFirebaseAuthException);

        final call = dataSource.forgotPassword;

        expect(() => call(tEmail), throwsA(isA<ServerException>()));

        verify(() => authClient.sendPasswordResetEmail(email: tEmail))
            .called(1);

        verifyNoMoreInteractions(authClient);
      },
    );
  });

  group('signIn', () {
    test(
      'should return [LocalUserModel] when no [Exception] is thrown',
      () async {
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => tUserCredential);

        final result = await dataSource.signIn(
          email: tEmail,
          password: tPassword,
        );
        expect(result.uid, tUserCredential.user!.uid);
        expect(result.points, tUser.points);

        verify(
          () => authClient.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);

        verifyNoMoreInteractions(authClient);
      },
    );

    test(
      'should throw [ServerException] when user is null after signing in',
      () async {
        final userCred = MockUserCredential();
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userCred);

        final call = dataSource.signIn;

        expect(
          () => call(email: tEmail, password: tPassword),
          throwsA(isA<ServerException>()),
        );

        verify(
          () => authClient.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);

        verifyNoMoreInteractions(authClient);
      },
    );

    test(
      'should throw [ServerException] when [FirebaseAuthException] is thrown',
      () async {
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(tFirebaseAuthException);

        final call = dataSource.signIn;

        expect(
          () => call(email: tEmail, password: tPassword),
          throwsA(isA<ServerException>()),
        );

        verify(
          () => authClient.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);

        verifyNoMoreInteractions(authClient);
      },
    );
  });

  group('signUp', () {
    test(
      'should complete successfully when no [Exception] is thrown',
      () async {
        when(
          () => authClient.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => tUserCredential);

        when(() => tUserCredential.user?.updateDisplayName(any())).thenAnswer(
          (_) async => Future.value(),
        );

        when(() => tUserCredential.user?.updatePhotoURL(any())).thenAnswer(
          (_) async => Future.value(),
        );

        final call = dataSource.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
        );

        expect(call, completes);

        verify(
          () => authClient.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);

        await untilCalled(() => tUserCredential.user?.updateDisplayName(any()));
        await untilCalled(() => tUserCredential.user?.updatePhotoURL(any()));

        verify(() => tUserCredential.user?.updateDisplayName(tFullName))
            .called(1);
        verify(() => tUserCredential.user?.updatePhotoURL(any())).called(1);

        verifyNoMoreInteractions(authClient);
      },
    );

    test(
      'should throw [ServerException] when [FirebaseAuthException] is thrown',
      () async {
        when(
          () => authClient.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(tFirebaseAuthException);

        final call = dataSource.signUp;

        expect(
          () => call(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
          ),
          throwsA(isA<ServerException>()),
        );
        verify(
          () => authClient.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
      },
    );
  });

  group('updateUser', () {
    setUp(() {
      when(() => authClient.currentUser).thenReturn(mockUser);
      registerFallbackValue(MockAuthCredential());
    });

    ///   displayName,
    //   email,
    //   password,
    //   bio,
    //   profilePic,
    test(
      'should update user displayName successfully when no [Exception] '
      'is thrown',
      () async {
        when(() => mockUser.updateDisplayName(any()))
            .thenAnswer((_) async => Future.value());

        await dataSource.updateUser(
          action: UpdateUserAction.displayName,
          userData: tFullName,
        );

        // this wasn't working before because I was using the authClient
        // .currentUser instead of the mockUser, so it would say I'm
        // expecting 1 call, but it was detecting 2 actually, this is because
        // it was reading every call made to the authClient.currentUser
        // instead of directly checking for calls made to updateDisplayName

        verify(() => mockUser.updateDisplayName(tFullName)).called(1);

        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.updateEmail(any()));
        verifyNever(() => mockUser.updatePassword(any()));

        final user =
            await cloudStoreClient.collection('users').doc(mockUser.uid).get();
        expect(user.data()!['fullName'], tFullName);
      },
    );

    test(
      'should update user email successfully when no [Exception] '
      'is thrown',
      () async {
        when(() => mockUser.updateEmail(any()))
            .thenAnswer((_) async => Future.value());

        await dataSource.updateUser(
          action: UpdateUserAction.email,
          userData: tEmail,
        );

        verify(() => mockUser.updateEmail(tEmail)).called(1);

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.updatePassword(any()));

        final user =
            await cloudStoreClient.collection('users').doc(mockUser.uid).get();

        expect(user.data()!['email'], tEmail);
      },
    );

    test(
      'should update user password successfully when no [Exception] '
      'is thrown',
      () async {
        when(() => mockUser.updatePassword(any()))
            .thenAnswer((_) async => Future.value());

        when(() => mockUser.reauthenticateWithCredential(any())).thenAnswer(
          (_) async => Future.value(tUserCredential),
        );

        await dataSource.updateUser(
          action: UpdateUserAction.password,
          userData: jsonEncode(
            {'oldPassword': 'oldPassword', 'newPassword': tPassword},
          ),
        );

        verify(() => mockUser.updatePassword(tPassword)).called(1);

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.updateEmail(any()));

        final user =
            await cloudStoreClient.collection('users').doc(mockUser.uid).get();

        expect(user.data()!['password'], null);
      },
    );

    test(
      'should update user bio successfully when no [Exception] '
      'is thrown',
      () async {
        const newBio = 'new bio';

        await dataSource.updateUser(
          action: UpdateUserAction.bio,
          userData: newBio,
        );
        final user = await cloudStoreClient
            .collection('users')
            .doc(
              docReference.id,
            )
            .get();

        expect(user.data()!['bio'], newBio);

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.updateEmail(any()));
        verifyNever(() => mockUser.updatePassword(any()));
      },
    );

    test(
      'should update user profilePic successfully when no [Exception] '
      'is thrown',
      () async {
        final newProfilePic = File('assets/images/onBoarding_background.png');

        when(() => mockUser.updatePhotoURL(any()))
            .thenAnswer((_) async => Future.value());

        await dataSource.updateUser(
          action: UpdateUserAction.profilePic,
          userData: newProfilePic,
        );

        verify(() => mockUser.updatePhotoURL(any())).called(1);

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updateEmail(any()));
        verifyNever(() => mockUser.updatePassword(any()));

        // make sure that something exists in the profile_pics folder

        expect(dbClient.storedFilesMap.isNotEmpty, isTrue);
      },
    );
  });
}
