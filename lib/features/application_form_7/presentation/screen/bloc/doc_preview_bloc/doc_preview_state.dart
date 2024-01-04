import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_7/data/document_preview_model.dart';

abstract class DocPreviewState extends Equatable {
  const DocPreviewState();

  @override
  List<Object> get props => [];
}

class DocPreviewInitial extends DocPreviewState {}

class DocPreviewLoading extends DocPreviewState {}

class DocPreviewLoaded extends DocPreviewState {
  const DocPreviewLoaded({required this.documentPreviewModel});
  final DocumentPreviewModel documentPreviewModel;

  @override
  List<Object> get props => [documentPreviewModel];
}

class DocPreviewError extends DocPreviewState {
  const DocPreviewError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class DocPreviewException extends DocPreviewState {
  const DocPreviewException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
