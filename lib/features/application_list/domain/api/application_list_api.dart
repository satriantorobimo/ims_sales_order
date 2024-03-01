import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_order/features/application_list/data/document_upload_ocr_request_model.dart';
import 'package:sales_order/features/application_list/data/document_upload_ocr_response_model.dart';
import 'package:sales_order/utility/shared_pref_util.dart';
import 'package:sales_order/utility/url_util.dart';

class ApplicationListApi {
  final UrlUtil urlUtil = UrlUtil();

  DocumentUploadOCRResponseModel documentUploadOCRResponseModel =
      DocumentUploadOCRResponseModel();
  DataDocumentUploadOCRResponseModel dataDocumentUploadOCRResponseModel =
      DataDocumentUploadOCRResponseModel();
  DataOCRResponseModel dataOCRResponseModel = DataOCRResponseModel();

  Future<DocumentUploadOCRResponseModel> attemptDocUpload(
      DocumentUploadOCRRequestModel documentUploadOCRRequestModel) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    a.add(documentUploadOCRRequestModel.toJson());

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlUploadOCRKTP()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        documentUploadOCRResponseModel =
            DocumentUploadOCRResponseModel.fromJson(jsonDecode(res.body));
        return documentUploadOCRResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        documentUploadOCRResponseModel =
            DocumentUploadOCRResponseModel.fromJson(jsonDecode(res.body));
        dataDocumentUploadOCRResponseModel =
            DataDocumentUploadOCRResponseModel.fromJson(jsonDecode(res.body));
        throw documentUploadOCRResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
