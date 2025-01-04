import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/enums/update_user.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/utils/constants.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/authentication/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<void> forgotPassword(String email);

  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });

  Future<void> updateUser({
    required UpdateUserAction action,
    dynamic userData,
  });

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
  })  : _authClient = authClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;

  @override
  @override
  Future<void> forgotPassword(String email) async {
    try {
      final querySnapshot = await _cloudStoreClient
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw ServerException(
          message: 'Aucun utilisateur trouvé avec cet e-mail',
          statusCode: '404',
        );
      }

      await _authClient.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Une erreur s\'est produite',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrint(s.toString());
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authClient.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user == null) {
        throw const ServerException(
          message: 'Une erreur s\'est produite',
          statusCode: 'Erreur inconnue',
        );
      }

      var userData = await _getUserData(user.uid);
      if (userData.exists) {
        return LocalUserModel.fromMap(userData.data()!);
      }
      // upload user
      await _setUserData(user, email);

      userData = await _getUserData(user.uid);
      return LocalUserModel.fromMap(userData.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Une erreur s\'est produite',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(s.toString());
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      final userCred = await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCred.user?.updateDisplayName(fullName);
      await userCred.user?.updatePhotoURL(kDefaultAvatar);
      await _setUserData(_authClient.currentUser!, email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrint(s.toString());
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> updateUser({
    required UpdateUserAction action,
    dynamic userData,
  }) async {
    try {
      switch (action) {
        case UpdateUserAction.email:
          // ignore: deprecated_member_use
          await _authClient.currentUser?.updateEmail(userData as String);
          await _updateUserData({'email': userData});
          break;
        case UpdateUserAction.displayName:
          await _authClient.currentUser?.updateDisplayName(userData as String);
          await _updateUserData({'fullName': userData});
          break;
        case UpdateUserAction.profilePic:
          final ref = _dbClient
              .ref()
              .child('profile_pics/${_authClient.currentUser?.uid}');
          await ref.putFile(userData as File);
          final url = await ref.getDownloadURL();
          await _authClient.currentUser?.updatePhotoURL(url);
          await _updateUserData({'profilePic': url});
          break;
        case UpdateUserAction.password:
          final newData = jsonDecode(userData as String) as DataMap;
          await _authClient.currentUser?.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: _authClient.currentUser?.email ?? '',
              password: newData['oldPassword'] as String,
            ),
          );
          await _authClient.currentUser?.updatePassword(
            newData['newPassword'] as String,
          );
          break;
        case UpdateUserAction.bio:
          await _cloudStoreClient
              .collection('users')
              .doc(_authClient.currentUser?.uid)
              .update({
            'bio': userData as String,
          });
          break;
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Une erreur s\'est produite',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrint(s.toString());
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authClient.signOut();
    } catch (e, s) {
      debugPrint(s.toString());
      throw ServerException(
        message: 'Une erreur s\'est produite pendant la connexion',
        statusCode: '500',
      );
    }
  }

  Future<DocumentSnapshot<DataMap>> _getUserData(String uid) async {
    return _cloudStoreClient.collection('users').doc(uid).get();
  }

  Future<void> _setUserData(User user, String fallbackEmail) async {
    await _cloudStoreClient.collection('users').doc(user.uid).set(
          LocalUserModel(
            uid: user.uid,
            email: user.email ?? fallbackEmail,
            fullName: user.displayName ?? '',
            profilePic: user.photoURL ?? '',
            points: 0,
          ).toMap(),
        );
  }

  Future<void> _updateUserData(DataMap data) async {
    await _cloudStoreClient
        .collection('users')
        .doc(_authClient.currentUser?.uid)
        .update(data);
  }
}
