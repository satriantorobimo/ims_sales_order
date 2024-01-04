import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_1/data/client_detail_response_model.dart';

abstract class GetClientState extends Equatable {
  const GetClientState();

  @override
  List<Object> get props => [];
}

class GetClientInitial extends GetClientState {}

class GetClientLoading extends GetClientState {}

class GetClientLoaded extends GetClientState {
  const GetClientLoaded({required this.clientDetailResponseModel});
  final ClientDetailResponseModel clientDetailResponseModel;

  @override
  List<Object> get props => [clientDetailResponseModel];
}

class GetClientError extends GetClientState {
  const GetClientError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class GetClientException extends GetClientState {
  const GetClientException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
