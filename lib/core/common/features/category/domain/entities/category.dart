import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({
    required this.categoryId,
    required this.categoryTitle,
    this.categoryImage,
    this.isImageFile = false,
    this.categoryCourseIds = const [],
  });

  Category.empty()
      : this(
          categoryId: '',
          categoryTitle: '',
        );

  final String categoryId;
  final String categoryTitle;
  final String? categoryImage;
  final bool isImageFile;
  final List<String> categoryCourseIds;

  @override
  List<dynamic> get props => [categoryId];
}
