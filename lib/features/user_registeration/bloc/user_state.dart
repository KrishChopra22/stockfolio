part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitialState extends UserState {}

final class UserLoadingState extends UserState {}

final class UserDataFetchedState extends UserState {
  UserDataFetchedState(this.userModel);
  final UserModel userModel;
}

final class UserDataSavedState extends UserState {
  UserDataSavedState(this.userModel);
  final UserModel userModel;
}

final class UserErrorState extends UserState {
  UserErrorState(this.error);
  final String error;
}
