import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';
import 'package:sales_order/features/application_form_7/data/document_list_response_model.dart';
import 'package:sales_order/features/application_form_7/data/document_preview_model.dart';
import 'package:sales_order/features/application_form_7/data/document_preview_request_model.dart';
import 'package:sales_order/features/application_form_7/data/document_upload_request_model.dart';
import 'package:sales_order/features/application_form_7/domain/api/form_7_api.dart';

class Form7Repo {
  final Form7Api form7api = Form7Api();

  Future<DocumentListResponseModel> attemptDocList(String code) =>
      form7api.attemptDocList(code);

  Future<DocumentPreviewModel> attemptDocPreview(
          DocumentPreviewRequestModel documentPreviewRequestModel) =>
      form7api.attemptDocPreview(documentPreviewRequestModel);

  Future<AddClientResponseModel> attemptDocUpload(
          DocumentUploadRequestModel documentUploadRequestModel) =>
      form7api.attemptDocUpload(documentUploadRequestModel);
}
