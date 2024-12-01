
import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/notifications/domain/repos/notification_repo.dart';

class ClearAllRead extends FutureUsecaseWithoutParams<void> {
  const ClearAllRead(this._repo);

  final NotificationRepo _repo;

  @override
  ResultFuture<void> call() => _repo.clearAllRead();
}
