import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_summary/data/detail_summary_response_model.dart';

abstract class DetailSummaryState extends Equatable {
  const DetailSummaryState();

  @override
  List<Object> get props => [];
}

class DetailSummaryInitial extends DetailSummaryState {}

class DetailSummaryLoading extends DetailSummaryState {}

class DetailSummaryLoaded extends DetailSummaryState {
  const DetailSummaryLoaded({required this.detailSummaryResponseModel});
  final DetailSummaryResponseModel detailSummaryResponseModel;

  @override
  List<Object> get props => [detailSummaryResponseModel];
}

class DetailSummaryError extends DetailSummaryState {
  const DetailSummaryError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class DetailSummaryException extends DetailSummaryState {
  const DetailSummaryException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
