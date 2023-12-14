import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';

abstract class UpdateTncState extends Equatable {
  const UpdateTncState();

  @override
  List<Object> get props => [];
}

class UpdateTncInitial extends UpdateTncState {}

class UpdateTncLoading extends UpdateTncState {}

class UpdateTncLoaded extends UpdateTncState {
  const UpdateTncLoaded({required this.addClientResponseModel});
  final AddClientResponseModel addClientResponseModel;

  @override
  List<Object> get props => [addClientResponseModel];
}

class UpdateTncError extends UpdateTncState {
  const UpdateTncError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class UpdateTncException extends UpdateTncState {
  const UpdateTncException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
