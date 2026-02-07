import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

//loading:
class AuthInitState extends AuthState {}

//if the app runs for the first time:
class AuthFirstAppRunState extends AuthState {}

//get PIN from the user to enter the app:
class AuthInputPinState extends AuthState {}

class AuthLoadingState extends AuthState {}

//successful login:
class AuthenticatedState extends AuthState {
  final String message;
  AuthenticatedState({required this.message});
}

//.................................................
//failed login:
class AuthenticationErrorState extends AuthState {
  final String error;
  int numOfTries;
  AuthenticationErrorState({required this.error, this.numOfTries = 0});
}

//.................................................
class AuthVerifyingPinState extends AuthState {}

class AuthPinVerifiedState extends AuthState {}

class AuthInvalidPinState extends AuthState {
  final String error;
  AuthInvalidPinState({required this.error});
}
