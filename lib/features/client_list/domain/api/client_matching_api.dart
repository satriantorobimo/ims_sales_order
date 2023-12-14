import 'dart:convert';

import 'package:sales_order/features/client_list/data/client_matching_corp_response_model.dart';
import 'package:sales_order/features/client_list/data/client_matching_mode.dart';
import 'package:sales_order/features/client_list/data/client_matching_personal_response_model.dart';
import 'package:sales_order/utility/shared_pref_util.dart';
import 'package:sales_order/utility/url_util.dart';
import 'package:http/http.dart' as http;

class ClientMatchingApi {
  ClientMathcingCorpResponseModel clientMathcingCorpResponseModel =
      ClientMathcingCorpResponseModel();
  ClientMathcingPersonalResponseModel clientMathcingPersonalResponseModel =
      ClientMathcingPersonalResponseModel();
  final UrlUtil urlUtil = UrlUtil();

  Future<ClientMathcingCorpResponseModel> attemptClientMatchingCorp(
      ClientMathcingModel clientMathcingModel) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_document_no'] = clientMathcingModel.pDocumentNo;
    mapData['p_document_type'] = clientMathcingModel.pDocumentType;
    mapData['p_est_date'] = '2023-11-17';
    mapData['p_full_name'] = clientMathcingModel.pFullName;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlClientMatchingCorp()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        clientMathcingCorpResponseModel =
            ClientMathcingCorpResponseModel.fromJson(jsonDecode(res.body));
        return clientMathcingCorpResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        clientMathcingCorpResponseModel =
            ClientMathcingCorpResponseModel.fromJson(jsonDecode(res.body));
        throw clientMathcingCorpResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<ClientMathcingPersonalResponseModel> attemptClientMatchingPersonal(
      ClientMathcingModel clientMathcingModel) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_document_no'] = clientMathcingModel.pDocumentNo;
    mapData['p_mother_maiden_name'] = clientMathcingModel.pMotherMaidenName;
    mapData['p_date_of_birth'] = '1998-11-17';
    mapData['p_full_name'] = clientMathcingModel.pFullName;
    mapData['p_place_of_birth'] = clientMathcingModel.pPlaceOfBirth;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(
          Uri.parse(urlUtil.getUrlClientMatchingPersonal()),
          body: json,
          headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        clientMathcingPersonalResponseModel =
            ClientMathcingPersonalResponseModel.fromJson(jsonDecode(res.body));
        return clientMathcingPersonalResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        clientMathcingPersonalResponseModel =
            ClientMathcingPersonalResponseModel.fromJson(jsonDecode(res.body));
        throw clientMathcingPersonalResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
