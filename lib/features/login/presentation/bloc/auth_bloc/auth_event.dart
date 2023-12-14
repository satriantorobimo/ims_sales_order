import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthAttempt extends AuthEvent {
  const AuthAttempt({required this.username, required this.password});
  final String username;
  final String password;

  @override
  List<Object> get props => [username, password];
}
