import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_5/data/update_fee_request_model.dart';

abstract class UpdateFeeEvent extends Equatable {
  const UpdateFeeEvent();
}

class UpdateFeeAttempt extends UpdateFeeEvent {
  const UpdateFeeAttempt(this.updateFeeRequestModel);
  final List<UpdateFeeRequestModel> updateFeeRequestModel;

  @override
  List<Object> get props => [updateFeeRequestModel];
}
