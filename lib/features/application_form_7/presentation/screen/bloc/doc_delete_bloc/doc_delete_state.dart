import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';

abstract class DocDeleteState extends Equatable {
  const DocDeleteState();

  @override
  List<Object> get props => [];
}

class DocDeleteInitial extends DocDeleteState {}

class DocDeleteLoading extends DocDeleteState {}

class DocDeleteLoaded extends DocDeleteState {
  const DocDeleteLoaded({required this.addClientResponseModel});
  final AddClientResponseModel addClientResponseModel;

  @override
  List<Object> get props => [addClientResponseModel];
}

class DocDeleteError extends DocDeleteState {
  const DocDeleteError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class DocDeleteException extends DocDeleteState {
  const DocDeleteException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
