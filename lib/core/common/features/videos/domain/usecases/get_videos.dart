
import 'package:edu_app_project/core/common/features/videos/domain/entities/video.dart';
import 'package:edu_app_project/core/common/features/videos/domain/repos/video_repo.dart';
import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';

class GetVideos extends FutureUsecaseWithParams<List<Video>, String> {
  const GetVideos(this._repo);

  final VideoRepo _repo;

  @override
  ResultFuture<List<Video>> call(String params) => _repo.getVideos(params);
}
