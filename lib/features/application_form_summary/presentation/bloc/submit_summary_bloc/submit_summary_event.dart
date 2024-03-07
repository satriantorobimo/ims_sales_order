import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_summary/data/detail_summary_request_model.dart';

abstract class SubmitSummaryEvent extends Equatable {
  const SubmitSummaryEvent();
}

class SubmitSummaryAttempt extends SubmitSummaryEvent {
  const SubmitSummaryAttempt(this.detailSummaryRequestModel);
  final DetailSummaryRequestModel detailSummaryRequestModel;

  @override
  List<Object> get props => [detailSummaryRequestModel];
}
