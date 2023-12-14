import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';

abstract class ClientState extends Equatable {
  const ClientState();

  @override
  List<Object> get props => [];
}

class ClientInitial extends ClientState {}

class ClientLoading extends ClientState {}

class ClientAddLoaded extends ClientState {
  const ClientAddLoaded({required this.addClientResponseModel});
  final AddClientResponseModel addClientResponseModel;

  @override
  List<Object> get props => [addClientResponseModel];
}

class ClientUpdateLoaded extends ClientState {
  const ClientUpdateLoaded({required this.addClientResponseModel});
  final AddClientResponseModel addClientResponseModel;

  @override
  List<Object> get props => [addClientResponseModel];
}

class ClientError extends ClientState {
  const ClientError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class ClientException extends ClientState {
  const ClientException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
