import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_1/data/look_up_mso_response_model.dart';

abstract class MaritalStatusState extends Equatable {
  const MaritalStatusState();

  @override
  List<Object> get props => [];
}

class MaritalStatusInitial extends MaritalStatusState {}

class MaritalStatusLoading extends MaritalStatusState {}

class MaritalStatusLoaded extends MaritalStatusState {
  const MaritalStatusLoaded({required this.lookUpMsoResponseModel});
  final LookUpMsoResponseModel lookUpMsoResponseModel;

  @override
  List<Object> get props => [lookUpMsoResponseModel];
}

class MaritalStatusError extends MaritalStatusState {
  const MaritalStatusError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class MaritalStatusException extends MaritalStatusState {
  const MaritalStatusException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
