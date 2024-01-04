import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_7/data/document_preview_request_model.dart';

abstract class DocPreviewEvent extends Equatable {
  const DocPreviewEvent();
}

class DocPreviewAttempt extends DocPreviewEvent {
  const DocPreviewAttempt(this.documentPreviewRequestModel);
  final DocumentPreviewRequestModel documentPreviewRequestModel;

  @override
  List<Object> get props => [documentPreviewRequestModel];
}
