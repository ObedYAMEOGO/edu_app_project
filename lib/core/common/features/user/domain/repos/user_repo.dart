import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/authentication/domain/entities/user.dart';

abstract class UserRepo {
  const UserRepo();

  // move this to chat functionality
  ResultFuture<LocalUser> getUserById(String userId);
  // move this to exams
  ResultFuture<void> addPoints({required String userId, required int points});
}
