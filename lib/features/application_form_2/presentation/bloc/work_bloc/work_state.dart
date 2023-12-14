import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_1/data/look_up_mso_response_model.dart';

abstract class WorkState extends Equatable {
  const WorkState();

  @override
  List<Object> get props => [];
}

class WorkInitial extends WorkState {}

class WorkLoading extends WorkState {}

class WorkLoaded extends WorkState {
  const WorkLoaded({required this.lookUpMsoResponseModel});
  final LookUpMsoResponseModel lookUpMsoResponseModel;

  @override
  List<Object> get props => [lookUpMsoResponseModel];
}

class WorkError extends WorkState {
  const WorkError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class WorkException extends WorkState {
  const WorkException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
