import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/common/features/course/domain/entities/course.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.courseCategoryId,
    required super.title,
    required super.groupId,
    required super.createdAt,
    required super.updatedAt,
    required super.numberOfVideos,
    required super.numberOfExams,
    required super.numberOfMaterials,
    super.description,
    super.image,
    super.imageIsFile,
  });

  CourseModel.empty([DateTime? date])
      : this(
          id: '_empty.id',
          courseCategoryId: '_empty.courseCategoryId',
          title: '_empty.title',
          description: '_empty.description',
          numberOfExams: 0,
          numberOfMaterials: 0,
          numberOfVideos: 0,
          groupId: '_empty.groupId',
          createdAt: date ?? DateTime.now(),
          updatedAt: date ?? DateTime.now(),
        );

  CourseModel.fromMap(DataMap map)
      : super(
          id: map['id'] as String,
          courseCategoryId: map['courseCategoryId'] as String,
          title: map['title'] as String,
          description: map['description'] as String?,
          groupId: map['groupId'] as String,
          numberOfExams: (map['numberOfExams'] as num).toInt(),
          numberOfMaterials: (map['numberOfMaterials'] as num).toInt(),
          numberOfVideos: (map['numberOfVideos'] as num).toInt(),
          image: map['image'] as String?,
          createdAt: (map['createdAt'] as Timestamp).toDate(),
          updatedAt: (map['updatedAt'] as Timestamp).toDate(),
        );

  CourseModel copyWith({
    String? id,
    String? courseCategoryId,
    String? title,
    String? description,
    String? groupId,
    int? numberOfVideos,
    int? numberOfExams,
    int? numberOfMaterials,
    String? image,
    bool? imageIsFile,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      courseCategoryId: courseCategoryId ?? this.courseCategoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      groupId: groupId ?? this.groupId,
      image: image ?? this.image,
      numberOfVideos: numberOfVideos ?? this.numberOfVideos,
      numberOfExams: numberOfExams ?? this.numberOfExams,
      numberOfMaterials: numberOfMaterials ?? this.numberOfMaterials,
      imageIsFile: imageIsFile ?? this.imageIsFile,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  DataMap toMap({Timestamp? createdAt, Timestamp? updatedAt}) {
    return {
      'id': id,
      'courseCategoryId': courseCategoryId,
      'title': title,
      'description': description,
      'groupId': groupId,
      'image': image,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'numberOfVideos': numberOfVideos,
      'numberOfExams': numberOfExams,
      'numberOfMaterials': numberOfMaterials,
    };
  }
}
