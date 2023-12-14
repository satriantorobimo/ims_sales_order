import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_1/data/look_up_mso_response_model.dart';

abstract class FamilyState extends Equatable {
  const FamilyState();

  @override
  List<Object> get props => [];
}

class FamilyInitial extends FamilyState {}

class FamilyLoading extends FamilyState {}

class FamilyLoaded extends FamilyState {
  const FamilyLoaded({required this.lookUpMsoResponseModel});
  final LookUpMsoResponseModel lookUpMsoResponseModel;

  @override
  List<Object> get props => [lookUpMsoResponseModel];
}

class FamilyError extends FamilyState {
  const FamilyError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class FamilyException extends FamilyState {
  const FamilyException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
