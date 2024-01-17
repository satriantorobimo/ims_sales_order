import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';

abstract class CancelClientState extends Equatable {
  const CancelClientState();

  @override
  List<Object> get props => [];
}

class CancelClientInitial extends CancelClientState {}

class CancelClientLoading extends CancelClientState {}

class CancelClientLoaded extends CancelClientState {
  const CancelClientLoaded({required this.addClientResponseModel});
  final AddClientResponseModel addClientResponseModel;

  @override
  List<Object> get props => [addClientResponseModel];
}

class CancelClientError extends CancelClientState {
  const CancelClientError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class CancelClientException extends CancelClientState {
  const CancelClientException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
