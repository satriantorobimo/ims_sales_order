import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_order/features/application_form_1/data/look_up_mso_response_model.dart';
import 'package:sales_order/features/application_form_2/data/add_client_request_model.dart';
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';
import 'package:sales_order/utility/shared_pref_util.dart';
import 'package:sales_order/utility/url_util.dart';

class Form2Api {
  LookUpMsoResponseModel lookUpMsoResponseModel = LookUpMsoResponseModel();
  AddClientResponseModel addClientResponseModel = AddClientResponseModel();

  final UrlUtil urlUtil = UrlUtil();

  Future<LookUpMsoResponseModel> attemptLookupMso(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_general_code'] = code;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlLookUpMso()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        lookUpMsoResponseModel =
            LookUpMsoResponseModel.fromJson(jsonDecode(res.body));
        return lookUpMsoResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        lookUpMsoResponseModel =
            LookUpMsoResponseModel.fromJson(jsonDecode(res.body));
        throw lookUpMsoResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<LookUpMsoResponseModel> attemptLookupBank(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['default'] = code;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlLookUpBank()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        lookUpMsoResponseModel =
            LookUpMsoResponseModel.fromJson(jsonDecode(res.body));
        return lookUpMsoResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        lookUpMsoResponseModel =
            LookUpMsoResponseModel.fromJson(jsonDecode(res.body));
        throw lookUpMsoResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<AddClientResponseModel> attemptAddClient(
      AddClientRequestModel addClientRequestModel) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    a.add(addClientRequestModel.toJsonNewClient());
    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlAddClient()),
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

  Future<AddClientResponseModel> attemptUpdateClient(
      AddClientRequestModel addClientRequestModel) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    if (addClientRequestModel.pWorkIsLatest! == true) {
      a.add(addClientRequestModel.toJsonUpdatePresent());
    } else {
      a.add(addClientRequestModel.toJsonUpdate());
    }

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlUpdateClient()),
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
