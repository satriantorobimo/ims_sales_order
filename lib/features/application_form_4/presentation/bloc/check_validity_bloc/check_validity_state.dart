import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_1/data/check_scoring_response_model.dart';

abstract class CheckValidityState extends Equatable {
  const CheckValidityState();

  @override
  List<Object> get props => [];
}

class CheckValidityInitial extends CheckValidityState {}

class CheckValidityLoading extends CheckValidityState {}

class CheckValidityLoaded extends CheckValidityState {
  const CheckValidityLoaded({required this.checkScoringResponseModel});
  final CheckScoringResponseModel checkScoringResponseModel;

  @override
  List<Object> get props => [checkScoringResponseModel];
}

class CheckValidityError extends CheckValidityState {
  const CheckValidityError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class CheckValidityException extends CheckValidityState {
  const CheckValidityException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
