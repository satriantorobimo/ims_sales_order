import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';
import 'package:sales_order/features/application_form_summary/data/detail_summary_response_model.dart';
import 'package:sales_order/utility/shared_pref_util.dart';
import 'package:sales_order/utility/url_util.dart';

class SummaryApi {
  DetailSummaryResponseModel detailSummaryResponseModel =
      DetailSummaryResponseModel();
  AddClientResponseModel addClientResponseModel = AddClientResponseModel();

  final UrlUtil urlUtil = UrlUtil();

  Future<DetailSummaryResponseModel> attemptDetailSummary(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_application_no'] = code;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlDetailSummary()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        detailSummaryResponseModel =
            DetailSummaryResponseModel.fromJson(jsonDecode(res.body));
        return detailSummaryResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        detailSummaryResponseModel =
            DetailSummaryResponseModel.fromJson(jsonDecode(res.body));
        throw detailSummaryResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<AddClientResponseModel> attemptSubmitSummary(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_application_no'] = code;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlSubmitSummary()),
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
