import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_order/features/application_form_1/data/check_scoring_response_model.dart';
import 'package:sales_order/features/application_form_1/data/look_up_mso_response_model.dart';
import 'package:sales_order/features/application_form_1/data/zip_code_response_model.dart';
import 'package:sales_order/utility/shared_pref_util.dart';
import 'package:sales_order/utility/url_util.dart';

class Form1Api {
  CheckScoringResponseModel checkScoringResponseModel =
      CheckScoringResponseModel();
  LookUpMsoResponseModel lookUpMsoResponseModel = LookUpMsoResponseModel();
  ZipCodeResponseModel zipCodeResponseModel = ZipCodeResponseModel();
  final UrlUtil urlUtil = UrlUtil();

  Future<CheckScoringResponseModel> attemptCheclScoring(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_dummy_checking'] = code;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlCheckScoring()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        checkScoringResponseModel =
            CheckScoringResponseModel.fromJson(jsonDecode(res.body));
        return checkScoringResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        checkScoringResponseModel =
            CheckScoringResponseModel.fromJson(jsonDecode(res.body));
        throw checkScoringResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

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

  Future<LookUpMsoResponseModel> attemptLookupProv(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['default'] = code;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlLookUpProv()),
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

  Future<LookUpMsoResponseModel> attemptLookupCity(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_province_code'] = code;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlLookUpCity()),
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

  Future<ZipCodeResponseModel> attemptLookupZipCode(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_city_code'] = code;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlLookUpZipCode()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        zipCodeResponseModel =
            ZipCodeResponseModel.fromJson(jsonDecode(res.body));
        return zipCodeResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        zipCodeResponseModel =
            ZipCodeResponseModel.fromJson(jsonDecode(res.body));
        throw zipCodeResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
