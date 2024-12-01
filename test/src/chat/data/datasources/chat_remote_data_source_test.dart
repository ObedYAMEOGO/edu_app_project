import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/src/chat/data/datasources/chat_remote_data_source.dart';
import 'package:edu_app_project/src/chat/data/models/group_model.dart';
import 'package:edu_app_project/src/chat/data/models/message_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late ChatRemoteDataSourceImpl remoteDataSource;
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  late MockFirebaseStorage storage;

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
    storage = MockFirebaseStorage();

    remoteDataSource = ChatRemoteDataSourceImpl(
      firestore: firestore,
      auth: auth,
      storage: storage,
    );
  });

  group('getMessages', () {
    test('should return a stream of messages when the call is successful', () {
      // Arrange
      const groupId = 'groupId';
      final firstDate = DateTime.now();
      final secondDate = DateTime.now().add(const Duration(seconds: 20));
      final expectedMessages = [
        MessageModel.empty().copyWith(timestamp: firstDate),
        MessageModel.empty().copyWith(
          id: '1',
          message: 'Message 1',
          timestamp: secondDate,
        ),
      ];

      // Create a fake collection, document, and query with the expected
      // messages
      firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .add(expectedMessages[0].toMap());
      firestore.collection('groups').doc(groupId).collection('messages').add(
            expectedMessages[1].toMap(),
          );

      // Act
      final result = remoteDataSource.getMessages(groupId);

      // Assert
      expect(result, emitsInOrder([equals(expectedMessages)]));
    });

    test('should return a stream of empty list when an error occurs', () {
      // Arrange
      const groupId = 'groupId';

      // Act
      final result = remoteDataSource.getMessages(groupId);

      // Assert
      expect(
        result,
        emits(equals(<MessageModel>[])),
      );
    });
  });

  group('getGroups', () {
    test('should return a stream of groups when the call is successful', () {
      // Arrange
      // const groupId = 'groupId';
      final firstDate = DateTime.now();
      final secondDate = DateTime.now().add(const Duration(seconds: 20));
      final expectedGroups = [
        GroupModel.empty().copyWith(
          id: '1',
          courseId: '1',
          name: 'Group 1',
          lastMessageTimestamp: firstDate,
        ),
        GroupModel.empty().copyWith(
          id: '2',
          courseId: '2',
          name: 'Group 2',
          lastMessageTimestamp: secondDate,
        ),
      ];

      // Create a fake collection, document, and query with the expected
      // groups
      firestore.collection('groups').add(expectedGroups[0].toMap());
      firestore.collection('groups').add(expectedGroups[1].toMap());
      // Act
      final result = remoteDataSource.getGroups();

      // Assert
      expect(result, emitsInOrder([equals(expectedGroups)]));
    });

    test('should return a stream of empty list when there are no groups', () {
      // Arrange
      // const groupId = 'groupId';

      // Act
      final result = remoteDataSource.getGroups();

      // Assert
      expect(
        result,
        emits(equals(<GroupModel>[])),
      );
    });
  });

  group('sendMessage', () {
    test('should complete successfully when the call is successful', () async {
      // Arrange
      final message = MessageModel.empty().copyWith(
        id: '1',
        message: 'Message 1',
        timestamp: DateTime.now(),
      );

      // create group for [remoteDataSource.sendMessage] to work
      await firestore
          .collection('groups')
          .doc(message.groupId)
          .set(GroupModel.empty().copyWith(id: message.groupId).toMap());

      // Act
      await remoteDataSource.sendMessage(message);

      // Assert
      final messageDoc = await firestore
          .collection('groups')
          .doc(message.groupId)
          .collection('messages')
          .get();
      expect(messageDoc.docs.length, equals(1));
    });

    /*test('should throw a ServerException when an error occurs', () async {
      // Arrange
      final message = MessageModel.empty().copyWith(
        id: '1',
        message: 'Message 1',
        timestamp: DateTime.now(),
      );
      whenCalling(Invocation.method(#add, null)).on(firestore)
          .thenThrow(FirebaseException(plugin: 'bla'));

      // Act
      final call = remoteDataSource.sendMessage;

      // Assert
      expect(call(message), throwsA(isA<ServerException>()));
    });*/
  });

  group('joinGroup', () {
    test('should complete successfully when the call is successful', () async {
      // Arrange
      final groupDocRef = await firestore.collection('groups').add({
        'members': <String>[],
      });

      final userDocRef = await firestore.collection('users').add({
        'groups': <String>[],
      });

      final groupId = groupDocRef.id;
      final userId = userDocRef.id;

      // Act
      await remoteDataSource.joinGroup(groupId: groupId, userId: userId);

      // Assert
      final groupDoc = await firestore.collection('groups').doc(groupId).get();
      final userDoc = await firestore.collection('users').doc(userId).get();
      expect(groupDoc.data()!['members'], contains(userId));
      expect(userDoc.data()!['groups'], contains(groupId));
    });

    /*test('should throw a ServerException when an error occurs', () async {
      // Arrange
      const groupId = 'groupId';
      const userId = 'userId';
      whenCalling(Invocation.method(#update, null)).on(firestore)
          .thenThrow(FirebaseException(plugin: 'bla'));

      // Act
      final call = remoteDataSource.joinGroup;

      // Assert
      expect(call(groupId, userId), throwsA(isA<ServerException>()));
    });*/
  });

  group('leaveGroup', () {
    test('should complete successfully when the call is successful', () async {
      // Arrange

      final groupDocRef = await firestore.collection('groups').add({
        'members': <String>[],
      });

      final groupId = groupDocRef.id;

      final userDocRef = await firestore.collection('users').add({
        'groups': <String>[groupId],
      });

      final userId = userDocRef.id;

      await groupDocRef.update({
        'groups': FieldValue.arrayUnion([userId]),
      });

      // Act
      await remoteDataSource.leaveGroup(
        groupId: groupId,
        userId: userId,
      );

      // Assert
      final groupDoc = await firestore.collection('groups').doc(groupId).get();
      final userDoc = await firestore.collection('users').doc(userId).get();
      expect(groupDoc.data()!['members'], isNot(contains(userId)));
      expect(userDoc.data()!['groups'], isNot(contains(groupId)));
    });

    /*test('should throw a ServerException when an error occurs', () async {
      // Arrange
      const groupId = 'groupId';
      const userId = 'userId';
      whenCalling(Invocation.method(#update, null)).on(firestore)
          .thenThrow(FirebaseException(plugin: 'bla'));

      // Act
      final call = remoteDataSource.leaveGroup;

      // Assert
      expect(call(groupId, userId), throwsA(isA<ServerException>()));
    });*/
  });
}
