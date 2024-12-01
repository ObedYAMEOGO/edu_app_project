import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/authentication/data/models/user_model.dart';
import 'package:edu_app_project/src/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:edu_app_project/src/notifications/data/models/notification_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late NotificationRemoteDataSrc remoteDataSource;
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

    remoteDataSource = NotificationRemoteDataSrcImpl(
      firestore: firestore,
      auth: auth,
    );
  });

  group('getNotifications', () {
    test(
      'should return a stream of notifications when the call is successful',
      () async {
        // Arrange
        final userId = auth.currentUser!.uid;
        final firstDate = DateTime.now();
        final secondDate = DateTime.now().add(const Duration(seconds: 20));
        final expectedNotifications = [
          NotificationModel.empty().copyWith(sentAt: firstDate),
          NotificationModel.empty().copyWith(
            id: '1',
            sentAt: secondDate,
          ),
        ];

        // Create a fake collection, document, and query with the expected
        // notifications
        await firestore
            .collection('users')
            .doc(userId)
            .collection('notifications')
            .add(expectedNotifications[0].toMap());
        await firestore
            .collection('users')
            .doc(userId)
            .collection('notifications')
            .add(expectedNotifications[1].toMap());

        // Act
        final result = remoteDataSource.getNotifications();

        // Assert
        expect(result, emitsInOrder([equals(expectedNotifications.reversed)]));
      },
    );

    test('should return a stream of empty list when an error occurs', () {
      // Act
      final result = remoteDataSource.getNotifications();

      // Assert
      expect(
        result,
        emits(equals(<NotificationModel>[])),
      );
    });
  });

  Future<QuerySnapshot<DataMap>> getNotifications() async => firestore
      .collection('users')
      .doc(auth.currentUser!.uid)
      .collection('notifications')
      .get();

  Future<DocumentReference> addNotification(
    NotificationModel notification,
  ) async {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('notifications')
        .add(notification.toMap());
  }

  group('clear', () {
    test(
      'should delete the specified [Notification] from the database',
      () async {
        // Create notifications sub-collection for current user
        await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('notifications')
            .add(NotificationModel.empty().toMap());
        // Add a notification to the sub-collection
        final notification = NotificationModel.empty().copyWith(id: '1');
        final docRef = await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('notifications')
            .add(notification.toMap());

        final collection = await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('notifications')
            .get();
        // Assert that the notification was added
        expect(
          collection.docs,
          hasLength(2),
        );
        // Act
        await remoteDataSource.clear(docRef.id);
        final notificationDoc = await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('notifications')
            .doc(docRef.id)
            .get();

        // Assert that the notification was deleted
        expect(
          notificationDoc.exists,
          isFalse,
        );
      },
    );
  });

  group('clearAll', () {
    test(
      "should delete every notification in the current user's sub-collection",
      () async {
        // Create notifications sub-collection for current user
        for (var i = 0; i < 5; i++) {
          await addNotification(
            NotificationModel.empty().copyWith(id: i.toString()),
          );
        }

        final collection = await getNotifications();
        // Assert that the notifications were added
        expect(
          collection.docs,
          hasLength(5),
        );

        // Act
        await remoteDataSource.clearAll();
        final notificationDocs = await getNotifications();

        // Assert that the notifications were deleted
        expect(
          notificationDocs.docs,
          isEmpty,
        );
      },
    );
  });

  group('clearAllRead', () {
    test(
      "should delete every notification in the current user's sub-collection",
      () async {
        // Create notifications sub-collection for current user
        for (var i = 0; i < 5; i++) {
          await addNotification(
            NotificationModel.empty().copyWith(
              id: i.toString(),
              seen: i.isEven,
            ),
          );
        }

        final collection = await getNotifications();
        // Assert that the notifications were added
        expect(
          collection.docs,
          hasLength(5),
        );

        // Act
        await remoteDataSource.clearAllRead();
        final notificationDocs = await getNotifications();

        // Assert that the notifications were deleted
        expect(
          notificationDocs.docs,
          hasLength(2),
        );
      },
    );
  });

  group('markAsRead', () {
    test(
      'should mark the specified notification as read',
      () async {
        var tId = '';
        // Create notifications sub-collection for current user
        for (var i = 0; i < 5; i++) {
          final docRef = await addNotification(
            NotificationModel.empty().copyWith(
              id: i.toString(),
              seen: i.isEven,
            ),
          );
          if (i == 1) {
            tId = docRef.id;
          }
        }

        final collection = await getNotifications();
        // Assert that the notifications were added
        expect(
          collection.docs,
          hasLength(5),
        );

        // Act
        await remoteDataSource.markAsRead(tId);
        final notificationDoc = await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('notifications')
            .doc(tId)
            .get();

        // Assert that the notification was marked as read
        expect(
          notificationDoc.data()!['seen'],
          isTrue,
        );
      },
    );
  });

  group('sendNotification', () {
    test(
      'should send a notification to the specified user',
      () async {
        // Arrange
        await firestore.collection('users').doc(auth.currentUser!.uid).set(
              const LocalUserModel.empty()
                  .copyWith(
                    uid: auth.currentUser!.uid,
                    email: auth.currentUser!.email,
                    fullName: auth.currentUser!.displayName,
                  )
                  .toMap(),
            );
        final notification = NotificationModel.empty().copyWith(
          id: '1',
          title: 'Test Unique title, cannot be duplicated',
          body: 'Test',
          sentAt: DateTime.now(),
        );
        final userId = auth.currentUser!.uid;

        // Act
        await remoteDataSource.sendNotification(notification);
        final snapshot = await firestore
            .collection('users')
            .doc(userId)
            .collection('notifications')
            .where('title', isEqualTo: notification.title)
            .get();

        // Assert
        expect(
          snapshot.docs,
          hasLength(1),
        );
      },
    );
  });
}
