// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/utils/datasource_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:edu_app_project/core/common/features/category/data/models/category_model.dart';
import 'package:edu_app_project/core/common/features/category/domain/entities/category.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<void> addCategory(Category category);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  CategoryRemoteDataSourceImpl({
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
  Future<void> addCategory(Category category) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      final categoryRef = _firestore.collection('categories').doc();
      var categoryModel =
          (category as CategoryModel).copyWith(categoryId: categoryRef.id);
      if (categoryModel.isImageFile) {
        final imageRef = _storage.ref().child(
              'categories/${categoryModel.categoryId}/category_image/${categoryModel.categoryTitle}-cp',
            );
        await imageRef
            .putFile(File(categoryModel.categoryImage!))
            .then((value) async {
          final url = await value.ref.getDownloadURL();
          categoryModel = categoryModel.copyWith(categoryImage: url);
        });
      }
      await categoryRef.set(categoryModel.toMap());
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
  Future<List<CategoryModel>> getCategories() async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      return _firestore.collection('categories').get().then(
            (value) =>
                value.docs.map((e) => CategoryModel.fromMap(e.data())).toList(),
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
