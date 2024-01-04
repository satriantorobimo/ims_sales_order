import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';

abstract class SubmitSummaryState extends Equatable {
  const SubmitSummaryState();

  @override
  List<Object> get props => [];
}

class SubmitSummaryInitial extends SubmitSummaryState {}

class SubmitSummaryLoading extends SubmitSummaryState {}

class SubmitSummaryLoaded extends SubmitSummaryState {
  const SubmitSummaryLoaded({required this.addClientResponseModel});
  final AddClientResponseModel addClientResponseModel;

  @override
  List<Object> get props => [addClientResponseModel];
}

class SubmitSummaryError extends SubmitSummaryState {
  const SubmitSummaryError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class SubmitSummaryException extends SubmitSummaryState {
  const SubmitSummaryException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
