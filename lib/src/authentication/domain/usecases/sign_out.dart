import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/authentication/domain/repos/auth_repo.dart';

class SignOut extends FutureUsecaseWithoutParams<void> {
  const SignOut(this._repo);
  final AuthRepo _repo;

  @override
  ResultFuture<void> call() => _repo.signOut();
}
