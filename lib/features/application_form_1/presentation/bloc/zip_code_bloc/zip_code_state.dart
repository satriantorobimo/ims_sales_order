import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_1/data/zip_code_response_model.dart';

abstract class ZipCodeState extends Equatable {
  const ZipCodeState();

  @override
  List<Object> get props => [];
}

class ZipCodeInitial extends ZipCodeState {}

class ZipCodeLoading extends ZipCodeState {}

class ZipCodeLoaded extends ZipCodeState {
  const ZipCodeLoaded({required this.zipCodeResponseModel});
  final ZipCodeResponseModel zipCodeResponseModel;

  @override
  List<Object> get props => [zipCodeResponseModel];
}

class ZipCodeError extends ZipCodeState {
  const ZipCodeError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class ZipCodeException extends ZipCodeState {
  const ZipCodeException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
