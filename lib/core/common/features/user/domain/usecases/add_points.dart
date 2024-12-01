import 'package:edu_app_project/core/common/features/user/domain/repos/user_repo.dart';
import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:equatable/equatable.dart';

class AddPoints extends FutureUsecaseWithParams<void, AddPointsParams> {
  const AddPoints(this._repo);

  final UserRepo _repo;

  @override
  ResultFuture<void> call(AddPointsParams params) =>
      _repo.addPoints(userId: params.userId, points: params.points);
}

class AddPointsParams extends Equatable {
  const AddPointsParams({required this.userId, required this.points});

  const AddPointsParams.empty()
      : userId = '',
        points = 0;

  final String userId;
  final int points;

  @override
  List<Object?> get props => [userId, points];
}
