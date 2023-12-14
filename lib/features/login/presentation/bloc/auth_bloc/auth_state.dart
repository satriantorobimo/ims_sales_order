import 'package:equatable/equatable.dart';
import 'package:sales_order/features/login/data/auth_response_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  const AuthLoaded({required this.authResponseModel});
  final AuthResponseModel authResponseModel;

  @override
  List<Object> get props => [authResponseModel];
}

class AuthError extends AuthState {
  const AuthError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class AuthException extends AuthState {
  const AuthException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
