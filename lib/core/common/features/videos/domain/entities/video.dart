import 'package:equatable/equatable.dart';

class Video extends Equatable {
  const Video({
    required this.id,
    required this.videoURL,
    required this.uploadDate,
    required this.courseId,
    this.tutor,
    this.thumbnail,
    this.title,
    this.videoIsFile = false,
    this.thumbnailIsFile = false,
  });

  Video.empty([DateTime? date])
      : this(
          id: '_empty.id',
          videoURL: '_empty.videoURL',
          uploadDate: date ?? DateTime.now(),
          courseId: '_empty.courseId',
        );

  final String id;
  final String? thumbnail;
  final String videoURL;
  final String? title;
  final String? tutor;
  final String courseId;
  final DateTime uploadDate;
  final bool videoIsFile;
  final bool thumbnailIsFile;

  @override
  List<Object?> get props => [id];
}
