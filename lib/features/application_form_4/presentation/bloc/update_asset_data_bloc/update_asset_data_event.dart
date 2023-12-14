import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_4/data/update_asset_request_model.dart';

abstract class UpdateAssetDataEvent extends Equatable {
  const UpdateAssetDataEvent();
}

class UpdateAssetDataAttempt extends UpdateAssetDataEvent {
  const UpdateAssetDataAttempt(this.updateAssetRequestModel);
  final UpdateAssetRequestModel updateAssetRequestModel;

  @override
  List<Object> get props => [updateAssetRequestModel];
}
