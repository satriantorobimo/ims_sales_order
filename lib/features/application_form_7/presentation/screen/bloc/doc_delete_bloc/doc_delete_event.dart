import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_7/data/document_delete_request_model.dart';

abstract class DocDeleteEvent extends Equatable {
  const DocDeleteEvent();
}

class DocDeleteAttempt extends DocDeleteEvent {
  const DocDeleteAttempt(this.documentDeleteRequestModel);
  final DocumentDeleteRequestModel documentDeleteRequestModel;

  @override
  List<Object> get props => [documentDeleteRequestModel];
}
