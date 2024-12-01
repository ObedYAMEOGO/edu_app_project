import 'package:edu_app_project/core/common/features/course/data/datasources/course_remote_data_src.dart';
import 'package:edu_app_project/core/common/features/course/data/models/course_model.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late CourseRemoteDataSrc remoteDataSource;
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

    remoteDataSource = CourseRemoteDataSrcImpl(
      firestore: firestore,
      auth: auth,
      storage: storage,
    );
  });

  group('addCourse', () {
    test(
      'should add the given course to the firestore collection',
      () async {
        final course = CourseModel.empty();
        await remoteDataSource.addCourse(course);
        final result = await firestore.collection('courses').get();
        expect(result.docs.length, 1);
        final courseRef = result.docs.first;
        expect(courseRef.data()['id'], courseRef.id);

        final groupResult = await firestore.collection('groups').get();
        expect(groupResult.docs.length, 1);
        final groupRef = groupResult.docs.first;
        expect(groupRef.data()['id'], groupRef.id);

        expect(courseRef.data()['groupId'], groupRef.id);
        expect(groupRef.data()['courseId'], courseRef.id);
      },
    );
  });

  group('getCourses', () {
    test(
      'should return a List<Course> when the call is successful',
      () async {
        // Arrange
        final firstDate = DateTime.now();
        final secondDate = DateTime.now().add(const Duration(seconds: 20));
        final expectedCourses = [
          CourseModel.empty().copyWith(createdAt: firstDate),
          CourseModel.empty().copyWith(
            id: '1',
            title: 'Course 1',
            createdAt: secondDate,
          ),
        ];

        // Create a fake collection, document, and query with the expected
        // courses
        for (final course in expectedCourses) {
          await firestore.collection('courses').add(course.toMap());
        }

        // Act
        final result = await remoteDataSource.getCourses();

        // Assert
        expect(result, expectedCourses);
      },
    );
  });

  group('getCourse', () {
    test(
      'should return a Course when the call is successful',
      () async {
        // Arrange
        final docRef = firestore.collection('courses').doc();

        final course = CourseModel.empty().copyWith(id: '1', title: 'Course 1');

        await docRef.set(course.toMap());

        // Act
        final result = await remoteDataSource.getCourse(docRef.id);

        // Assert
        expect(result, course);
      },
    );

    test(
      'should throw a ServerException when the call is unsuccessful',
      () async {
        // Arrange
        const courseId = '1';

        // Act
        final call = remoteDataSource.getCourse;

        // Assert
        expect(() => call(courseId), throwsA(isA<ServerException>()));
      },
    );
  });
}
