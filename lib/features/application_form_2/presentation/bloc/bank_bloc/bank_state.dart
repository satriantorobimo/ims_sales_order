import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_1/data/look_up_mso_response_model.dart';

abstract class BankState extends Equatable {
  const BankState();

  @override
  List<Object> get props => [];
}

class BankInitial extends BankState {}

class BankLoading extends BankState {}

class BankLoaded extends BankState {
  const BankLoaded({required this.lookUpMsoResponseModel});
  final LookUpMsoResponseModel lookUpMsoResponseModel;

  @override
  List<Object> get props => [lookUpMsoResponseModel];
}

class BankError extends BankState {
  const BankError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class BankException extends BankState {
  const BankException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
