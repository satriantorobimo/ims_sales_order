import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_list/data/document_upload_ocr_response_model.dart';

abstract class DocUploadOCRState extends Equatable {
  const DocUploadOCRState();

  @override
  List<Object> get props => [];
}

class DocUploadOCRInitial extends DocUploadOCRState {}

class DocUploadOCRLoading extends DocUploadOCRState {}

class DocUploadOCRLoaded extends DocUploadOCRState {
  const DocUploadOCRLoaded({required this.documentUploadOCRResponseModel});
  final DocumentUploadOCRResponseModel documentUploadOCRResponseModel;

  @override
  List<Object> get props => [documentUploadOCRResponseModel];
}

class DocUploadOCRError extends DocUploadOCRState {
  const DocUploadOCRError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class DocUploadOCRException extends DocUploadOCRState {
  const DocUploadOCRException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
