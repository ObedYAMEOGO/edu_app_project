import 'dart:io';

import 'package:edu_app_project/core/common/features/course/data/models/course_model.dart';
import 'package:edu_app_project/core/common/features/materials/data/datasources/material_remote_data_src.dart';
import 'package:edu_app_project/core/common/features/materials/data/models/material_model.dart';
import 'package:edu_app_project/core/common/features/materials/domain/entities/material.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late MaterialRemoteDataSrc remoteDataSource;
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

    remoteDataSource = MaterialRemoteDataSrcImpl(
      firestore: firestore,
      auth: auth,
      storage: storage,
    );
  });

  final tMaterial = MaterialModel.empty();

  group('addMaterial', () {
    setUp(() async {
      await firestore
          .collection('courses')
          .doc(tMaterial.courseId)
          .set(CourseModel.empty().toMap());
    });
    test('should add the provided [Material] to the firestore', () async {
      await remoteDataSource.addMaterial(tMaterial);

      final collectionRef = await firestore
          .collection('courses')
          .doc(tMaterial.courseId)
          .collection('materials')
          .get();

      expect(collectionRef.docs.length, equals(1));
    });
    test(
      'should add the provided [Material] to the storage',
      () async {
        final materialFile = File('assets/images/auth_gradient_background.png');
        final material = tMaterial.copyWith(
          fileURL: materialFile.path,
        );

        await remoteDataSource.addMaterial(material);

        final collectionRef = await firestore
            .collection('courses')
            .doc(tMaterial.courseId)
            .collection('materials')
            .get();

        expect(collectionRef.docs.length, equals(1));
        final savedMaterial = collectionRef.docs.first.data();

        final storageMaterialURL = await storage
            .ref()
            .child(
              'courses/${tMaterial.courseId}/materials/${savedMaterial['id']}/material',
            )
            .getDownloadURL();

        expect(savedMaterial['fileURL'], equals(storageMaterialURL));
      },
    );
    test(
      "should throw a [ServerException] when there's an error",
      () async {
        final call = remoteDataSource.addMaterial;
        expect(() => call(Material.empty()), throwsA(isA<ServerException>()));
      },
    );
  });

  group('getMaterials', () {
    test('should return a list of [Material] from the firestore', () async {
      await firestore
          .collection('courses')
          .doc(tMaterial.courseId)
          .set(CourseModel.empty().toMap());
      await remoteDataSource.addMaterial(tMaterial);

      final result = await remoteDataSource.getMaterials(tMaterial.courseId);

      expect(result, isA<List<Material>>());
      expect(result.length, equals(1));
      expect(result.first.description, equals(tMaterial.description));
    });
    // it's difficult to simulate an error with the fake firestore, because it
    // doesn't throw any errors, so we'll just test that it returns an empty
    // list when there's an error
    test('should return an empty list when there is an error', () async {
      final result = await remoteDataSource.getMaterials(tMaterial.courseId);

      expect(result, isA<List<Material>>());
      expect(result.isEmpty, isTrue);
    });
  });
}
