import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/common/features/course/data/models/course_model.dart';
import 'package:edu_app_project/core/common/features/course/domain/entities/course.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/src/chat/data/models/group_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class CourseRemoteDataSrc {
  Future<List<CourseModel>> getCourses();

  Future<CourseModel> getCourse(String courseId);

  Future<void> addCourse(Course course);
}

class CourseRemoteDataSrcImpl implements CourseRemoteDataSrc {
  const CourseRemoteDataSrcImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required FirebaseStorage storage,
  })  : _firestore = firestore,
        _auth = auth,
        _storage = storage;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  @override
  Future<void> addCourse(Course course) async {
    // we will add a new course to firestore, course collection, then we will
    // create a new group chat for this course and add it to the group
    // collection
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'User is not authenticated',
          statusCode: '401',
        );
      }
      final courseRef = _firestore.collection('courses').doc();
      final groupRef = _firestore.collection('groups').doc();
      var courseModel = (course as CourseModel).copyWith(
        id: courseRef.id,
        groupId: groupRef.id,
      );
      if (courseModel.imageIsFile) {
        final imageRef = _storage.ref().child(
              'courses/${courseModel.id}/profile_image/${courseModel.title}-pfp',
            );
        await imageRef.putFile(File(courseModel.image!)).then((value) async {
          final url = await value.ref.getDownloadURL();
          courseModel = courseModel.copyWith(image: url);
        });
      }
      await courseRef.set(courseModel.toMap());

      final group = GroupModel(
        id: groupRef.id,
        name: course.title,
        groupImageUrl: courseModel.image,
        members: const [],
        courseId: courseRef.id,
      );
      return groupRef.set(group.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<CourseModel> getCourse(String courseId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'User is not authenticated',
          statusCode: '401',
        );
      }
      final courseDoc =
          await _firestore.collection('courses').doc(courseId).get();
      if (!courseDoc.exists) {
        throw const ServerException(
          message: 'Course not found',
          statusCode: '404',
        );
      }
      final course = CourseModel.fromMap(courseDoc.data()!);
      return course;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<List<CourseModel>> getCourses() {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'User is not authenticated',
          statusCode: '401',
        );
      }
      return _firestore.collection('courses').get().then(
            (value) =>
                value.docs.map((e) => CourseModel.fromMap(e.data())).toList(),
          );
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }
}
