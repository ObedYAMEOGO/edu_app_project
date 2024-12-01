import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/common/features/videos/domain/entities/video.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.videoURL,
    required super.courseId,
    required super.uploadDate,
    super.tutor,
    super.thumbnail,
    super.title,
    super.videoIsFile,
    super.thumbnailIsFile,
  });

  VideoModel.empty([DateTime? date])
      : this(
          id: '_empty.id',
          videoURL: '_empty.videoURL',
          uploadDate: date ?? DateTime.now(),
          courseId: '_empty.courseId',
        );

  VideoModel.fromMap(DataMap map)
      : super(
          id: map['id'] as String,
          thumbnail: map['thumbnail'] as String?,
          videoURL: map['videoURL'] as String,
          title: map['title'] as String?,
          tutor: map['tutor'] as String?,
          uploadDate: (map['uploadDate'] is int)
              ? DateTime.fromMillisecondsSinceEpoch(map['uploadDate'] as int)
              : (map['uploadDate'] as Timestamp).toDate(),
          courseId: map['courseId'] as String,
        );

  VideoModel copyWith({
    String? id,
    String? thumbnail,
    String? videoURL,
    String? courseId,
    DateTime? uploadDate,
    String? title,
    String? tutor,
    bool? videoIsFile,
    bool? thumbnailIsFile,
  }) {
    return VideoModel(
      id: id ?? this.id,
      thumbnail: thumbnail ?? this.thumbnail,
      videoURL: videoURL ?? this.videoURL,
      title: title ?? this.title,
      tutor: tutor ?? this.tutor,
      uploadDate: uploadDate ?? this.uploadDate,
      videoIsFile: videoIsFile ?? this.videoIsFile,
      thumbnailIsFile: thumbnailIsFile ?? this.thumbnailIsFile,
      courseId: courseId ?? this.courseId,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'thumbnail': thumbnail,
      'videoURL': videoURL,
      'title': title,
      'tutor': tutor,
      'uploadDate': uploadDate.millisecondsSinceEpoch,
      'courseId': courseId,
    };
  }
}
