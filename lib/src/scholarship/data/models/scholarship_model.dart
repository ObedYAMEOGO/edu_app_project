import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/scholarship/domain/entities/scholarship.dart';

class ScholarshipModel extends Scholarship {
  const ScholarshipModel({
    required super.id,
    required super.name,
    required super.description,
    required super.numberOfRecipients,
    required super.applicationDeadline,
    required super.createdAt,
    required super.updatedAt,
    required super.isActive,
    required super.image,
    required super.availableFields,
    required super.country,
    required super.logoImage,
    required super.category,
    required super.videoUrl,
    super.imageIsFile = false,
    super.amount,
  });

  ScholarshipModel.empty()
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
          logoImage: '_empty.logoImage',
          country: '_empty.country',
          category: '_empty.category',
          videoUrl: '_empty.videoUrl',
        );

  ScholarshipModel.fromMap(DataMap map)
      : super(
          id: map['id'] as String,
          name: map['name'] as String,
          country: map['country'] as String,
          description: map['description'] as String,
          numberOfRecipients: map['numberOfRecipients'] as int,
          applicationDeadline: map['applicationDeadline'] != null
              ? (map['applicationDeadline'] as Timestamp).toDate()
              : DateTime(1970), // Valeur par défaut si Timestamp est null
          createdAt: map['createdAt'] != null
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime(1970),
          updatedAt: map['updatedAt'] != null
              ? (map['updatedAt'] as Timestamp).toDate()
              : DateTime(1970),
          isActive: map['isActive'] as bool,
          image: map['image'] as String,
          logoImage: map['logoImage'] as String,
          availableFields: map['availableFields'] != null
              ? List<String>.from(map['availableFields'] as List<dynamic>)
              : [],
          imageIsFile: map['imageIsFile'] as bool,
          amount: map['amount'] as double?,
          category: map['category'] as String,
          videoUrl: map['videoUrl'] as String,
        );

  ScholarshipModel copyWith({
    String? id,
    String? country,
    String? name,
    String? description,
    String? logoImage,
    int? numberOfRecipients,
    DateTime? applicationDeadline,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? image,
    List<String>? availableFields,
    bool? imageIsFile,
    double? amount,
    String? category,
    String? videoUrl,
  }) {
    return ScholarshipModel(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      description: description ?? this.description,
      numberOfRecipients: numberOfRecipients ?? this.numberOfRecipients,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      image: image ?? this.image,
      availableFields: availableFields ?? this.availableFields,
      imageIsFile: imageIsFile ?? this.imageIsFile,
      amount: amount ?? this.amount,
      logoImage: logoImage ?? this.logoImage,
      category: category ?? this.category,
      videoUrl: videoUrl ?? this.videoUrl,
    );
  }

  DataMap toMap() => {
        'id': id,
        'name': name,
        'country': country,
        'description': description,
        'numberOfRecipients': numberOfRecipients,
        'applicationDeadline': applicationDeadline,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'isActive': isActive,
        'image': image,
        'availableFields': availableFields,
        'imageIsFile': imageIsFile,
        'amount': amount,
        'logoImage': logoImage,
        'category': category,
        'videoUrl': videoUrl,
      };
}
