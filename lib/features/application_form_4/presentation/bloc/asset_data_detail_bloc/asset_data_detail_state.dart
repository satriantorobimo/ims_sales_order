import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_4/data/asset_detail_response_model.dart';

abstract class AssetDataDetailState extends Equatable {
  const AssetDataDetailState();

  @override
  List<Object> get props => [];
}

class AssetDataDetailInitial extends AssetDataDetailState {}

class AssetDataDetailLoading extends AssetDataDetailState {}

class AssetDataDetailLoaded extends AssetDataDetailState {
  const AssetDataDetailLoaded({required this.assetDetailResponseModel});
  final AssetDetailResponseModel assetDetailResponseModel;

  @override
  List<Object> get props => [assetDetailResponseModel];
}

class AssetDataDetailError extends AssetDataDetailState {
  const AssetDataDetailError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class AssetDataDetailException extends AssetDataDetailState {
  const AssetDataDetailException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
