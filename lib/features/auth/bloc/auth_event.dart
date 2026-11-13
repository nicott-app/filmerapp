import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class LoginWithGoogle extends AuthEvent {}

class LoginWithApple extends AuthEvent {}

class LoginAsGuest extends AuthEvent {
  final String name;
  const LoginAsGuest(this.name);

  @override
  List<Object?> get props => [name];
}

class LogoutRequested extends AuthEvent {}

class DeleteAccountRequested extends AuthEvent {}
