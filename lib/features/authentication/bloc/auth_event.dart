import 'package:equatable/equatable.dart';
import 'package:secupass/features/home_screen/domain/entities/pin_entity.dart';

sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

//loading:
class AuthInitEvent extends AuthEvent {}

class AuthLoadingEvent extends AuthEvent {}

//if the app runs for the first time:
class AuthFirstAppRunEvent extends AuthEvent {}

//get PIN from the user to enter the app:
class AuthInputPinEvent extends AuthEvent {
  final int pin;
  AuthInputPinEvent({required this.pin});
  @override
  List<Object?> get props => [pin];
}

//successful login: PIN ADDED
class AuthenticatedEvent extends AuthEvent {
  final String msg;
  AuthenticatedEvent({required this.msg});
  @override
  List<Object?> get props => [msg];
}

//failed login: PIN NOT ADDED
class AuthenticationErrorEvent extends AuthEvent {
  final String errorMsg;
  AuthenticationErrorEvent({required this.errorMsg});
  @override
  List<Object?> get props => [errorMsg];
}

//.................................

class AddPinEvent extends AuthEvent {
  final PinEntity pin;
  AddPinEvent({required this.pin});
  @override
  List<Object?> get props => [pin];
}

//.................................

class UpdatePinEvent extends AuthEvent {
  final int id;
  final int pin;
  UpdatePinEvent({required this.id, required this.pin});
  @override
  List<Object?> get props => [id, pin];
}

//.................................
class AuthVerifyPinEvent extends AuthEvent {
  final int pin;
  AuthVerifyPinEvent({required this.pin});
  @override
  List<Object?> get props => [pin];
}
