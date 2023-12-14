import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_5/data/update_tnc_request_model.dart';

abstract class UpdateTncEvent extends Equatable {
  const UpdateTncEvent();
}

class UpdateTncAttempt extends UpdateTncEvent {
  const UpdateTncAttempt(this.updateTncRequestModel);
  final UpdateTncRequestModel updateTncRequestModel;

  @override
  List<Object> get props => [updateTncRequestModel];
}
