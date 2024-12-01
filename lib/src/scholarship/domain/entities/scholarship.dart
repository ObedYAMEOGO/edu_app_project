import 'package:equatable/equatable.dart';

class Scholarship extends Equatable {
  const Scholarship({
    required this.id,
    required this.name,
    required this.description,
    required this.numberOfRecipients,
    required this.applicationDeadline,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.image,
    required this.availableFields,
    required this.country,
    required this.logoImage,
    required this.category,
    required this.videoUrl,
    this.imageIsFile = false,
    this.amount,
  });

  Scholarship.empty()
      : this(
          id: '_empty.id',
          name: '_empty.name',
          description: '_empty.description',
          amount: null,
          numberOfRecipients: 0,
          applicationDeadline: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isActive: false,
          image: '_empty.image',
          availableFields: const [],
          country: '_empty.country',
          logoImage: '_empty.logoImage',
          category: '_empty.category',
          videoUrl: '_empty.videoUrl',
        );

  final String id;
  final String name;
  final String description;
  final double? amount;
  final int numberOfRecipients;
  final DateTime applicationDeadline;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final String image;
  final bool imageIsFile;
  final List<String> availableFields;
  final String country;
  final String logoImage;
  final String category;
  final String videoUrl;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        amount,
        numberOfRecipients,
        applicationDeadline,
        createdAt,
        updatedAt,
        isActive,
        image,
        imageIsFile,
        availableFields,
        country,
        logoImage,
        category,
        videoUrl,
      ];
}
