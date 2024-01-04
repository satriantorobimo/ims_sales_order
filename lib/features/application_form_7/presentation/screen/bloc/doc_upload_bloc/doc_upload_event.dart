import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_7/data/document_upload_request_model.dart';

abstract class DocUploadEvent extends Equatable {
  const DocUploadEvent();
}

class DocUploadAttempt extends DocUploadEvent {
  const DocUploadAttempt(this.documentUploadRequestModel);
  final DocumentUploadRequestModel documentUploadRequestModel;

  @override
  List<Object> get props => [documentUploadRequestModel];
}
