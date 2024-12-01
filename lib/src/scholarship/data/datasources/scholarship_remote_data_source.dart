import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/utils/datasource_utils.dart';
import 'package:edu_app_project/src/scholarship/data/models/scholarship_model.dart';
import 'package:edu_app_project/src/scholarship/domain/entities/scholarship.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class ScholarshipRemoteDataSrc {
  Future<void> addScholarship(Scholarship scholarship);
  Future<List<ScholarshipModel>> getScholarships();
}

class ScholarshipRemoteDataSrcImpl implements ScholarshipRemoteDataSrc {
  const ScholarshipRemoteDataSrcImpl({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _storage = storage,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  @override
  Future<void> addScholarship(Scholarship scholarship) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);

      if (scholarship is! ScholarshipModel) {
        throw ServerException(
          message: 'Invalid scholarship type',
          statusCode: '400',
        );
      }

      var scholarshipModel = scholarship.copyWith(
        id: _firestore.collection('scholarships').doc().id,
      );

      if (scholarshipModel.imageIsFile) {
        final imageRef = _storage.ref().child(
              'scholarships/${scholarshipModel.id}/profile_image'
              '/${scholarshipModel.name}-pfp',
            );

        final logoRef = _storage.ref().child(
              'scholarships/${scholarshipModel.id}/logo_image'
              '/${scholarshipModel.name}-logo',
            );

        if (File(scholarshipModel.image).existsSync()) {
          final uploadTask =
              await imageRef.putFile(File(scholarshipModel.image));
          scholarshipModel = scholarshipModel.copyWith(
            image: await uploadTask.ref.getDownloadURL(),
          );
        }

        if (File(scholarshipModel.logoImage).existsSync()) {
          final uploadTask =
              await logoRef.putFile(File(scholarshipModel.logoImage));
          scholarshipModel = scholarshipModel.copyWith(
            logoImage: await uploadTask.ref.getDownloadURL(),
          );
        }
      }

      await _firestore
          .collection('scholarships')
          .doc(scholarshipModel.id)
          .set(scholarshipModel.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown Firebase error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: ${e.toString()}',
        statusCode: '500',
      );
    }
  }

  @override
  Future<List<ScholarshipModel>> getScholarships() async {
    try {
      await DataSourceUtils.authorizeUser(_auth);

      final snapshot = await _firestore.collection('scholarships').get();

      return snapshot.docs.map((doc) {
        return ScholarshipModel.fromMap(doc.data()..['id'] = doc.id);
      }).toList();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown Firebase error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: ${e.toString()}',
        statusCode: '500',
      );
    }
  }
}
