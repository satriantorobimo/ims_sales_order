import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_list/data/document_upload_ocr_request_model.dart';

abstract class DocUploadOCREvent extends Equatable {
  const DocUploadOCREvent();
}

class DocUploadOCRAttempt extends DocUploadOCREvent {
  const DocUploadOCRAttempt(this.documentUploadOCRRequestModel);
  final DocumentUploadOCRRequestModel documentUploadOCRRequestModel;

  @override
  List<Object> get props => [documentUploadOCRRequestModel];
}
