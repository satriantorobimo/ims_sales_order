import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';

abstract class UpdateAssetDataState extends Equatable {
  const UpdateAssetDataState();

  @override
  List<Object> get props => [];
}

class UpdateAssetDataInitial extends UpdateAssetDataState {}

class UpdateAssetDataLoading extends UpdateAssetDataState {}

class UpdateAssetDataLoaded extends UpdateAssetDataState {
  const UpdateAssetDataLoaded({required this.addClientResponseModel});
  final AddClientResponseModel addClientResponseModel;

  @override
  List<Object> get props => [addClientResponseModel];
}

class UpdateAssetDataError extends UpdateAssetDataState {
  const UpdateAssetDataError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class UpdateAssetDataException extends UpdateAssetDataState {
  const UpdateAssetDataException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
