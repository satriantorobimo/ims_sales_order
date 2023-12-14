import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_3/data/loan_data_detail_response_model.dart';

abstract class LoanDataDetailState extends Equatable {
  const LoanDataDetailState();

  @override
  List<Object> get props => [];
}

class LoanDataDetailInitial extends LoanDataDetailState {}

class LoanDataDetailLoading extends LoanDataDetailState {}

class LoanDataDetailLoaded extends LoanDataDetailState {
  const LoanDataDetailLoaded({required this.loanDataDetailResponseModel});
  final LoanDataDetailResponseModel loanDataDetailResponseModel;

  @override
  List<Object> get props => [loanDataDetailResponseModel];
}

class LoanDataDetailError extends LoanDataDetailState {
  const LoanDataDetailError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class LoanDataDetailException extends LoanDataDetailState {
  const LoanDataDetailException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
