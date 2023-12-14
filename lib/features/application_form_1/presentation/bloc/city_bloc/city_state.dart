import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_1/data/look_up_mso_response_model.dart';

abstract class CityState extends Equatable {
  const CityState();

  @override
  List<Object> get props => [];
}

class CityInitial extends CityState {}

class CityLoading extends CityState {}

class CityLoaded extends CityState {
  const CityLoaded({required this.lookUpMsoResponseModel});
  final LookUpMsoResponseModel lookUpMsoResponseModel;

  @override
  List<Object> get props => [lookUpMsoResponseModel];
}

class CityError extends CityState {
  const CityError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class CityException extends CityState {
  const CityException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
