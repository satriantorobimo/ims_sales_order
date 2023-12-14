import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_5/data/application_fee_detail_model.dart';

abstract class FeeDataState extends Equatable {
  const FeeDataState();

  @override
  List<Object> get props => [];
}

class FeeDataInitial extends FeeDataState {}

class FeeDataLoading extends FeeDataState {}

class FeeDataLoaded extends FeeDataState {
  const FeeDataLoaded({required this.applicationFeeDetailModel});
  final ApplicationFeeDetailModel applicationFeeDetailModel;

  @override
  List<Object> get props => [applicationFeeDetailModel];
}

class FeeDataError extends FeeDataState {
  const FeeDataError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class FeeDataException extends FeeDataState {
  const FeeDataException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
