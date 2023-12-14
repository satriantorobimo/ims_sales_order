import 'package:equatable/equatable.dart';
import 'package:sales_order/features/home/data/app_status_response_model.dart';
import 'package:sales_order/features/login/data/auth_response_model.dart';

abstract class AppStatusState extends Equatable {
  const AppStatusState();

  @override
  List<Object> get props => [];
}

class AppStatusInitial extends AppStatusState {}

class AppStatusLoading extends AppStatusState {}

class AppStatusLoaded extends AppStatusState {
  const AppStatusLoaded({required this.appStatusResponseModel});
  final AppStatusResponseModel appStatusResponseModel;

  @override
  List<Object> get props => [appStatusResponseModel];
}

class AppStatusError extends AppStatusState {
  const AppStatusError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class AppStatusException extends AppStatusState {
  const AppStatusException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
