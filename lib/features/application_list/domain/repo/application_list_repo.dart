import 'package:sales_order/features/application_list/domain/api/application_list_api.dart';
import 'package:sales_order/features/application_list/data/document_upload_ocr_request_model.dart';
import 'package:sales_order/features/application_list/data/document_upload_ocr_response_model.dart';

class ApplicationListRepo {
  final ApplicationListApi applicationListapi = ApplicationListApi();

  Future<DocumentUploadOCRResponseModel> attemptDocUpload(
          DocumentUploadOCRRequestModel documentUploadOCRRequestModel) =>
      applicationListapi.attemptDocUpload(documentUploadOCRRequestModel);
}
