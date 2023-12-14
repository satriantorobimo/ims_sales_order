import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_5/data/look_up_insurance_package_model.dart';

abstract class InsuranceState extends Equatable {
  const InsuranceState();

  @override
  List<Object> get props => [];
}

class InsuranceInitial extends InsuranceState {}

class InsuranceLoading extends InsuranceState {}

class InsuranceLoaded extends InsuranceState {
  const InsuranceLoaded({required this.lookUpInsurancePackageModel});
  final LookUpInsurancePackageModel lookUpInsurancePackageModel;

  @override
  List<Object> get props => [lookUpInsurancePackageModel];
}

class InsuranceError extends InsuranceState {
  const InsuranceError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class InsuranceException extends InsuranceState {
  const InsuranceException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
