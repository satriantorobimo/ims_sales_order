import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_3/data/update_loan_data_request_model.dart';

abstract class UpdateLoanDataEvent extends Equatable {
  const UpdateLoanDataEvent();
}

class UpdateLoanDataAttempt extends UpdateLoanDataEvent {
  const UpdateLoanDataAttempt(this.updateLoanDataRequestModel);
  final UpdateLoanDataRequestModel updateLoanDataRequestModel;

  @override
  List<Object> get props => [updateLoanDataRequestModel];
}
