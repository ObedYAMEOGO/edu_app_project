
import 'package:edu_app_project/core/common/features/videos/domain/entities/video.dart';
import 'package:edu_app_project/core/common/features/videos/domain/repos/video_repo.dart';
import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';

class AddVideo extends FutureUsecaseWithParams<void, Video> {
  const AddVideo(this._repo);

  final VideoRepo _repo;

  @override
  ResultFuture<void> call(Video params) => _repo.addVideo(params);
}
