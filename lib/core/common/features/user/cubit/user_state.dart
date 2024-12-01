part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class AddingPoints extends UserState {
  const AddingPoints();
}

class GettingUser extends UserState {
  const GettingUser();
}

class PointsAdded extends UserState {
  const PointsAdded();
}

class UserFound extends UserState {
  const UserFound(this.user);
  final LocalUser user;

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  const UserError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
