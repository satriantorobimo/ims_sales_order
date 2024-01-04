import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_7/data/document_list_response_model.dart';

abstract class DocListState extends Equatable {
  const DocListState();

  @override
  List<Object> get props => [];
}

class DocListInitial extends DocListState {}

class DocListLoading extends DocListState {}

class DocListLoaded extends DocListState {
  const DocListLoaded({required this.documentListResponseModel});
  final DocumentListResponseModel documentListResponseModel;

  @override
  List<Object> get props => [documentListResponseModel];
}

class DocListError extends DocListState {
  const DocListError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class DocListException extends DocListState {
  const DocListException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
