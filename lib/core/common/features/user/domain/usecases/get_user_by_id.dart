import 'package:edu_app_project/core/common/features/user/domain/repos/user_repo.dart';
import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/authentication/domain/entities/user.dart';

class GetUserById extends FutureUsecaseWithParams<LocalUser, String> {
  const GetUserById(this._repo);

  final UserRepo _repo;

  @override
  ResultFuture<LocalUser> call(String params) => _repo.getUserById(params);
}
