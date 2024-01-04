import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';
import 'package:sales_order/features/application_form_7/data/document_list_response_model.dart';
import 'package:sales_order/features/application_form_7/data/document_preview_model.dart';
import 'package:sales_order/features/application_form_7/data/document_preview_request_model.dart';
import 'package:sales_order/features/application_form_7/data/document_upload_request_model.dart';
import 'package:sales_order/utility/shared_pref_util.dart';
import 'package:sales_order/utility/url_util.dart';

class Form7Api {
  DocumentListResponseModel documentListResponseModel =
      DocumentListResponseModel();
  DocumentPreviewModel documentPreviewModel = DocumentPreviewModel();
  AddClientResponseModel addClientResponseModel = AddClientResponseModel();

  final UrlUtil urlUtil = UrlUtil();

  Future<DocumentListResponseModel> attemptDocList(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_application_no'] = code;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlDocList()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        documentListResponseModel =
            DocumentListResponseModel.fromJson(jsonDecode(res.body));
        return documentListResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        documentListResponseModel =
            DocumentListResponseModel.fromJson(jsonDecode(res.body));
        throw documentListResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<DocumentPreviewModel> attemptDocPreview(
      DocumentPreviewRequestModel documentPreviewRequestModel) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);

    a.add(documentPreviewRequestModel.toJson());
    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlDocPreview()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        documentPreviewModel =
            DocumentPreviewModel.fromJson(jsonDecode(res.body));
        return documentPreviewModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        throw 'Error';
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<AddClientResponseModel> attemptDocUpload(
      DocumentUploadRequestModel documentUploadRequestModel) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    a.add(documentUploadRequestModel.toJson());

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlDocUpload()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        addClientResponseModel =
            AddClientResponseModel.fromJson(jsonDecode(res.body));
        return addClientResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        addClientResponseModel =
            AddClientResponseModel.fromJson(jsonDecode(res.body));
        throw addClientResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
