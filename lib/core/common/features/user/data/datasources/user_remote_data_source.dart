import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/src/authentication/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRemoteDataSource {
  const UserRemoteDataSource();

  Future<LocalUserModel> getUserById(String userId);

  Future<void> addPoints({required String userId, required int points});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  const UserRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _store = firestore,
        _auth = auth;

  final FirebaseFirestore _store;
  final FirebaseAuth _auth;

  @override
  Future<void> addPoints({required String userId, required int points}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'User not authenticated',
          statusCode: '401',
        );
      }
      return await _store
          .collection('users')
          .doc(userId)
          .update({'points': FieldValue.increment(points)});
    } on ServerException {
      rethrow;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error',
        statusCode: e.code,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<LocalUserModel> getUserById(String userId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'User not authenticated',
          statusCode: '401',
        );
      }
      final userDoc = await _store.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw const ServerException(
          message: 'User not found',
          statusCode: '404',
        );
      }
      return LocalUserModel.fromMap(userDoc.data()!);
    } on ServerException {
      rethrow;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error',
        statusCode: e.code,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }
}
