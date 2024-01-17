import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_7/data/document_update_request_model.dart';

abstract class DocUpdateEvent extends Equatable {
  const DocUpdateEvent();
}

class DocUpdateAttempt extends DocUpdateEvent {
  const DocUpdateAttempt(this.documentUDateRequestModel);
  final DocumentUDateRequestModel documentUDateRequestModel;

  @override
  List<Object> get props => [documentUDateRequestModel];
}
