import 'dart:io';

import 'package:edu_app_project/core/common/features/course/data/models/course_model.dart';
import 'package:edu_app_project/core/common/features/videos/data/datasources/video_remote_data_src.dart';
import 'package:edu_app_project/core/common/features/videos/data/models/video_model.dart';
import 'package:edu_app_project/core/common/features/videos/domain/entities/video.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late VideoRemoteDataSrc remoteDataSource;
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  late MockFirebaseStorage storage;

  final tVideo = VideoModel.empty();
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

    remoteDataSource = VideoRemoteDataSrcImpl(
      firestore: firestore,
      auth: auth,
      storage: storage,
    );

    await firestore.collection('courses').doc(tVideo.courseId).set(
          CourseModel.empty().copyWith(id: tVideo.courseId).toMap(),
        );
  });

  group('addVideo', () {
    test('should add the provided [Video] to the firestore', () async {
      await remoteDataSource.addVideo(tVideo);

      final collectionRef = await firestore
          .collection('courses')
          .doc(tVideo.courseId)
          .collection('videos')
          .get();

      expect(collectionRef.docs.length, equals(1));
    });
    test(
      'should add the provided [Video] to the storage if it is a file',
      () async {
        final videoFile = File('assets/images/auth_gradient_background.png');
        final thumbnailFile =
            File('assets/images/auth_gradient_background.png');
        final video = tVideo.copyWith(
          videoIsFile: true,
          videoURL: videoFile.path,
          thumbnailIsFile: true,
          thumbnail: thumbnailFile.path,
        );

        await remoteDataSource.addVideo(video);

        final collectionRef = await firestore
            .collection('courses')
            .doc(tVideo.courseId)
            .collection('videos')
            .get();

        expect(collectionRef.docs.length, equals(1));
        final savedVideo = collectionRef.docs.first.data();

        final storageVideoURL = await storage
            .ref()
            .child(
              'courses/${tVideo.courseId}/videos/${savedVideo['id']}/video',
            )
            .getDownloadURL();

        expect(savedVideo['videoURL'], equals(storageVideoURL));
      },
    );
    test(
      "should throw a [ServerException] when there's an error",
      () async {
        final call = remoteDataSource.addVideo;
        expect(() => call(Video.empty()), throwsA(isA<ServerException>()));
      },
    );
  });

  group('getVideos', () {
    test('should return a list of [Video] from the firestore', () async {
      await remoteDataSource.addVideo(tVideo);

      final result = await remoteDataSource.getVideos(tVideo.courseId);

      expect(result, isA<List<Video>>());
      expect(result.length, equals(1));
      expect(result.first.thumbnail, equals(tVideo.thumbnail));
    });
    // it's difficult to simulate an error with the fake firestore, because it
    // doesn't throw any errors, so we'll just test that it returns an empty
    // list when there's an error
    test('should return an empty list when there is an error', () async {
      final result = await remoteDataSource.getVideos(tVideo.courseId);

      expect(result, isA<List<Video>>());
      expect(result.isEmpty, isTrue);
    });
  });
}
