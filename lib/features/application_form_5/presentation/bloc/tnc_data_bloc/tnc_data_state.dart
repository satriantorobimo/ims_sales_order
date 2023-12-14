import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_5/data/tnc_data_detail_response_model.dart';

abstract class TncDataState extends Equatable {
  const TncDataState();

  @override
  List<Object> get props => [];
}

class TncDataInitial extends TncDataState {}

class TncDataLoading extends TncDataState {}

class TncDataLoaded extends TncDataState {
  const TncDataLoaded({required this.tncDataDetailResponseModel});
  final TncDataDetailResponseModel tncDataDetailResponseModel;

  @override
  List<Object> get props => [tncDataDetailResponseModel];
}

class TncDataError extends TncDataState {
  const TncDataError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class TncDataException extends TncDataState {
  const TncDataException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
