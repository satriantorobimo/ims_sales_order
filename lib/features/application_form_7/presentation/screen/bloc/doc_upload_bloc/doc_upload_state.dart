import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';

abstract class DocUploadState extends Equatable {
  const DocUploadState();

  @override
  List<Object> get props => [];
}

class DocUploadInitial extends DocUploadState {}

class DocUploadLoading extends DocUploadState {}

class DocUploadLoaded extends DocUploadState {
  const DocUploadLoaded({required this.addClientResponseModel});
  final AddClientResponseModel addClientResponseModel;

  @override
  List<Object> get props => [addClientResponseModel];
}

class DocUploadError extends DocUploadState {
  const DocUploadError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class DocUploadException extends DocUploadState {
  const DocUploadException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
