part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitialState extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthOtpCodeSentState extends AuthState {}

final class AuthOtpCodeVerifiedState extends AuthState {
  AuthOtpCodeVerifiedState(this.currentUser);
  final User currentUser;
}

final class AuthVerifiedAndRegisteredState extends AuthState {
  AuthVerifiedAndRegisteredState(this.userModel);
  final UserModel userModel;
}

final class AuthNotRegisteredState extends AuthState {}

final class AuthVerifiedButNotRegisteredState extends AuthState {
  AuthVerifiedButNotRegisteredState(this.currentUser, this.phoneNumber);
  final User currentUser;
  final String phoneNumber;
}

final class AuthErrorState extends AuthState {
  AuthErrorState(this.error);
  final String error;
}
