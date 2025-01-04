import 'package:edu_app_project/core/common/features/category/domain/entities/category.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.categoryId,
    required super.categoryTitle,
    super.categoryImage,
    super.isImageFile = false,
    super.categoryCourseIds = const [],
  });

  CategoryModel.empty()
      : this(
          categoryId: '',
          categoryTitle: '',
        );

  CategoryModel.fromMap(DataMap map)
      : super(
          categoryId: map['categoryId'] as String,
          categoryTitle: map['categoryTitle'] as String,
          categoryImage: map['categoryImage'] as String?,
          categoryCourseIds:
              (map['categoryCourseIds'] as List<dynamic>).cast<String>(),
        );

  CategoryModel copyWith({
    String? categoryId,
    String? categoryTitle,
    String? categoryImage,
    bool? isImageFile,
    List<String>? categoryCourseIds,
  }) {
    return CategoryModel(
      categoryId: categoryId ?? this.categoryId,
      categoryTitle: categoryTitle ?? this.categoryTitle,
      categoryImage: categoryImage ?? this.categoryImage,
      isImageFile: isImageFile ?? this.isImageFile,
      categoryCourseIds: categoryCourseIds ?? this.categoryCourseIds,
    );
  }

  DataMap toMap() => {
        'categoryId': categoryId,
        'categoryTitle': categoryTitle,
        'categoryImage': categoryImage,
        'isImageFile': isImageFile,
        'categoryCourseIds': categoryCourseIds,
      };
}
