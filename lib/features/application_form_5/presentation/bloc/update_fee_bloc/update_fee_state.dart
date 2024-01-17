import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';

abstract class UpdateFeeState extends Equatable {
  const UpdateFeeState();

  @override
  List<Object> get props => [];
}

class UpdateFeeInitial extends UpdateFeeState {}

class UpdateFeeLoading extends UpdateFeeState {}

class UpdateFeeLoaded extends UpdateFeeState {
  const UpdateFeeLoaded({required this.addClientResponseModel});
  final AddClientResponseModel addClientResponseModel;

  @override
  List<Object> get props => [addClientResponseModel];
}

class UpdateFeeError extends UpdateFeeState {
  const UpdateFeeError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class UpdateFeeException extends UpdateFeeState {
  const UpdateFeeException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
