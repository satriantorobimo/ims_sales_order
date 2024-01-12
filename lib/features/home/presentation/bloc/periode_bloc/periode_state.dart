import 'package:equatable/equatable.dart';
import 'package:sales_order/features/home/data/data_periode_response_model.dart';

abstract class PeriodeState extends Equatable {
  const PeriodeState();

  @override
  List<Object> get props => [];
}

class PeriodeInitial extends PeriodeState {}

class PeriodeLoading extends PeriodeState {}

class PeriodeLoaded extends PeriodeState {
  const PeriodeLoaded({required this.dataPeriodeResponseModel});
  final DataPeriodeResponseModel dataPeriodeResponseModel;

  @override
  List<Object> get props => [dataPeriodeResponseModel];
}

class PeriodeError extends PeriodeState {
  const PeriodeError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class PeriodeException extends PeriodeState {
  const PeriodeException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
