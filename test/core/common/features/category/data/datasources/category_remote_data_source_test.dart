import 'package:edu_app_project/core/common/features/category/data/datasources/category_remote_data_source.dart';
import 'package:edu_app_project/core/common/features/category/data/models/category_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late CategoryRemoteDataSource remoteDataSource;
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

    remoteDataSource = CategoryRemoteDataSourceImpl(
      firestore: firestore,
      auth: auth,
      storage: storage,
    );
  });

  group('addCategory', () {
    test(
      'should add the given category to the Firestore collection',
      () async {
        // Arrange
        final category = CategoryModel.empty();

        // Act
        await remoteDataSource.addCategory(category);

        // Assert
        final result = await firestore.collection('categories').get();
        print(
            'Firestore documents: ${result.docs.map((e) => e.data()).toList()}');
        expect(result.docs.length, 1);
        final categoryRef = result.docs.first;
        expect(categoryRef.data()['categoryId'], categoryRef.id);
      },
    );
  });

  group('getCategories', () {
    test(
      'should return a List<CategoryModel> when the call is successful',
      () async {
        // Arrange
        final expectedCategories = [
          CategoryModel.empty()
              .copyWith(categoryId: '1', categoryTitle: 'Category 1'),
          CategoryModel.empty()
              .copyWith(categoryId: '2', categoryTitle: 'Category 2'),
        ];

        for (final category in expectedCategories) {
          await firestore.collection('categories').add(category.toMap());
        }

        // Act
        final result = await remoteDataSource.getCategories();

        // Assert
        expect(result, expectedCategories);
      },
    );
  });
}
