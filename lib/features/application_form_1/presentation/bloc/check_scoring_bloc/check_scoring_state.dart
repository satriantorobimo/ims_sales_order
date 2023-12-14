import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_1/data/check_scoring_response_model.dart';

abstract class CheckScoringState extends Equatable {
  const CheckScoringState();

  @override
  List<Object> get props => [];
}

class CheckScoringInitial extends CheckScoringState {}

class CheckScoringLoading extends CheckScoringState {}

class CheckScoringLoaded extends CheckScoringState {
  const CheckScoringLoaded({required this.checkScoringResponseModel});
  final CheckScoringResponseModel checkScoringResponseModel;

  @override
  List<Object> get props => [checkScoringResponseModel];
}

class CheckScoringError extends CheckScoringState {
  const CheckScoringError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class CheckScoringException extends CheckScoringState {
  const CheckScoringException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
