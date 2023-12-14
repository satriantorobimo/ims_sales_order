import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_1/data/look_up_mso_response_model.dart';

abstract class ProvState extends Equatable {
  const ProvState();

  @override
  List<Object> get props => [];
}

class ProvInitial extends ProvState {}

class ProvLoading extends ProvState {}

class ProvLoaded extends ProvState {
  const ProvLoaded({required this.lookUpMsoResponseModel});
  final LookUpMsoResponseModel lookUpMsoResponseModel;

  @override
  List<Object> get props => [lookUpMsoResponseModel];
}

class ProvError extends ProvState {
  const ProvError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class ProvException extends ProvState {
  const ProvException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
