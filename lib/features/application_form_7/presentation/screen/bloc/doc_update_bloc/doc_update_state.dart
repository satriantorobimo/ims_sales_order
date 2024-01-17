import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';

abstract class DocUpdateState extends Equatable {
  const DocUpdateState();

  @override
  List<Object> get props => [];
}

class DocUpdateInitial extends DocUpdateState {}

class DocUpdateLoading extends DocUpdateState {}

class DocUpdateLoaded extends DocUpdateState {
  const DocUpdateLoaded({required this.addClientResponseModel});
  final AddClientResponseModel addClientResponseModel;

  @override
  List<Object> get props => [addClientResponseModel];
}

class DocUpdateError extends DocUpdateState {
  const DocUpdateError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class DocUpdateException extends DocUpdateState {
  const DocUpdateException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
