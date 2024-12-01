import 'package:edu_app_project/src/scholarship/data/datasources/scholarship_remote_data_source.dart';
import 'package:edu_app_project/src/scholarship/data/models/scholarship_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late ScholarshipRemoteDataSrc remoteDataSource;
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

    remoteDataSource = ScholarshipRemoteDataSrcImpl(
      firestore: firestore,
      storage: storage,
      auth: auth,
    );
  });

  group('addScholarship', () {
    test(
      'should add the given scholarship to the firestore collection',
      () async {
        final scholarship = ScholarshipModel.empty();

        await remoteDataSource.addScholarship(scholarship);

        final firestoreData = await firestore.collection('scholarships').get();
        expect(firestoreData.docs.length, 1);

        final scholarshipRef = firestoreData.docs.first;
        expect(scholarshipRef.data()['id'], scholarshipRef.id);
      },
    );
  });

  group('getScholarships', () {
    test(
      'should return a List<Scholarship> when the call is successful',
      () async {
        final firstDeadline = DateTime.now();
        final secondDeadline = DateTime.now().add(const Duration(seconds: 20));
        final expectedScholarships = [
          ScholarshipModel.empty().copyWith(applicationDeadline: firstDeadline),
          ScholarshipModel.empty().copyWith(
            applicationDeadline: secondDeadline,
            id: '1',
            name: 'Scholarship 1',
          ),
        ];

        for (final scholarship in expectedScholarships) {
          await firestore.collection('scholarships').add(scholarship.toMap());
        }

        final result = await remoteDataSource.getScholarships();

        expect(result.length, expectedScholarships.length);

        for (int i = 0; i < result.length; i++) {
          final resultScholarship = result[i];
          final expectedScholarship = expectedScholarships[i];

          expect(resultScholarship.name, expectedScholarship.name);
          expect(
              resultScholarship.description, expectedScholarship.description);
          expect(resultScholarship.applicationDeadline,
              expectedScholarship.applicationDeadline);
        }
      },
    );
  });
}
