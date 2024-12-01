import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/common/features/materials/domain/entities/material.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';

class MaterialModel extends Material {
  const MaterialModel({
    required super.id,
    required super.courseId,
    required super.uploadDate,
    required super.fileURL,
    required super.fileExtension,
    required super.isFile,
    super.title,
    super.author,
    super.description,
  });

  MaterialModel.empty([DateTime? date])
      : this(
          id: '_empty.id',
          title: '_empty.title',
          description: '_empty.description',
          uploadDate: date ?? DateTime.now(),
          fileExtension: '_empty.fileExtension',
          isFile: true,
          courseId: '_empty.courseId',
          fileURL: '_empty.fileURL',
          author: '_empty.author',
        );

  MaterialModel.fromMap(DataMap map)
      : super(
          id: map['id'] as String,
          title: map['title'] as String?,
          description: map['description'] as String?,
          uploadDate: (map['uploadDate'] is int)
              ? DateTime.fromMillisecondsSinceEpoch(map['uploadDate'] as int)
              : (map['uploadDate'] as Timestamp).toDate(),
          fileExtension: map['fileExtension'] as String,
          isFile: map['isFile'] as bool,
          courseId: map['courseId'] as String,
          fileURL: map['fileURL'] as String,
          author: map['author'] as String?,
        );

  MaterialModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? uploadDate,
    String? fileExtension,
    bool? isFile,
    String? courseId,
    String? fileURL,
    String? author,
  }) {
    return MaterialModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      uploadDate: uploadDate ?? this.uploadDate,
      courseId: courseId ?? this.courseId,
      fileURL: fileURL ?? this.fileURL,
      isFile: isFile ?? this.isFile,
      author: author ?? this.author,
      fileExtension: fileExtension ?? this.fileExtension,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'uploadDate': uploadDate.millisecondsSinceEpoch,
      'courseId': courseId,
      'fileURL': fileURL,
      'author': author,
      'isFile': isFile,
      'fileExtension': fileExtension,
    };
  }
}
