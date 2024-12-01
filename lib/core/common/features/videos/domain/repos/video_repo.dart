
import 'package:edu_app_project/core/common/features/videos/domain/entities/video.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';

abstract class VideoRepo {
  const VideoRepo();

  // We could make this a stream, but for the sakes of tutorials,
  // we'll keep it simple
  ResultFuture<List<Video>> getVideos(String courseId);

  ResultFuture<void> addVideo(Video video);
}
