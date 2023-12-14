import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';

abstract class UpdateLoanDataState extends Equatable {
  const UpdateLoanDataState();

  @override
  List<Object> get props => [];
}

class UpdateLoanDataInitial extends UpdateLoanDataState {}

class UpdateLoanDataLoading extends UpdateLoanDataState {}

class UpdateLoanDataLoaded extends UpdateLoanDataState {
  const UpdateLoanDataLoaded({required this.addClientResponseModel});
  final AddClientResponseModel addClientResponseModel;

  @override
  List<Object> get props => [addClientResponseModel];
}

class UpdateLoanDataError extends UpdateLoanDataState {
  const UpdateLoanDataError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class UpdateLoanDataException extends UpdateLoanDataState {
  const UpdateLoanDataException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
