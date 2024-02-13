import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';

abstract class SendPdfState extends Equatable {
  const SendPdfState();

  @override
  List<Object> get props => [];
}

class SendPdfInitial extends SendPdfState {}

class SendPdfLoading extends SendPdfState {}

class SendPdfLoaded extends SendPdfState {
  const SendPdfLoaded({required this.addClientResponseModel});
  final AddClientResponseModel addClientResponseModel;

  @override
  List<Object> get props => [addClientResponseModel];
}

class SendPdfError extends SendPdfState {
  const SendPdfError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class SendPdfException extends SendPdfState {
  const SendPdfException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
