import 'package:bloc/bloc.dart';
import 'package:edu_app_project/core/common/features/user/domain/usecases/add_points.dart';
import 'package:edu_app_project/core/common/features/user/domain/usecases/get_user_by_id.dart';
import 'package:edu_app_project/src/authentication/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({
    required AddPoints addPoints,
    required GetUserById getUserById,
  })  : _addPoints = addPoints,
        _getUserById = getUserById,
        super(const UserInitial());

  final AddPoints _addPoints;
  final GetUserById _getUserById;

  bool _isClosed = false;

  Future<void> getUser(String userId) async {
    if (_isClosed) return;
    emit(const GettingUser());
    final result = await _getUserById(userId);
    result.fold((failure) {
      if (_isClosed) return;
      emit(UserError('${failure.statusCode}: ${failure.message}'));
    }, (user) {
      if (_isClosed) return;
      emit(UserFound(user));
    });
  }

  Future<void> addPoints({required String userId, required int points}) async {
    if (_isClosed) return;
    emit(const AddingPoints());
    final result = await _addPoints(
      AddPointsParams(
        userId: userId,
        points: points,
      ),
    );
    result.fold((failure) {
      if (_isClosed) return;
      emit(UserError('${failure.statusCode}: ${failure.message}'));
    }, (_) {
      if (_isClosed) return;
      emit(const PointsAdded());
    });
  }

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }
}
