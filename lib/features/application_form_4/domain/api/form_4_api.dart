import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_order/features/application_form_1/data/check_scoring_response_model.dart';
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';
import 'package:sales_order/features/application_form_4/data/asset_detail_response_model.dart';
import 'package:sales_order/features/application_form_4/data/look_up_merk_model.dart';
import 'package:sales_order/features/application_form_4/data/update_asset_request_model.dart';
import 'package:sales_order/utility/shared_pref_util.dart';
import 'package:sales_order/utility/url_util.dart';

class Form4Api {
  LookUpMerkModel lookUpMerkModel = LookUpMerkModel();
  AssetDetailResponseModel assetDetailResponseModel =
      AssetDetailResponseModel();
  AddClientResponseModel addClientResponseModel = AddClientResponseModel();
  CheckScoringResponseModel checkScoringResponseModel =
      CheckScoringResponseModel();

  final UrlUtil urlUtil = UrlUtil();

  Future<CheckScoringResponseModel> attemptCheckValidity(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_dummy_checking'] = code;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlAssetValidity()),
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

  Future<LookUpMerkModel> attemptLookupMerk(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['default'] = code;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlLookUpMerk()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        lookUpMerkModel = LookUpMerkModel.fromJson(jsonDecode(res.body));
        return lookUpMerkModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        lookUpMerkModel = LookUpMerkModel.fromJson(jsonDecode(res.body));
        throw lookUpMerkModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<LookUpMerkModel> attemptLookupType(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_merk_code'] = code;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlLookUpType()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        lookUpMerkModel = LookUpMerkModel.fromJson(jsonDecode(res.body));
        return lookUpMerkModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        lookUpMerkModel = LookUpMerkModel.fromJson(jsonDecode(res.body));
        throw lookUpMerkModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<LookUpMerkModel> attemptLookupModel(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_model_code'] = code;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlLookUpModel()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        lookUpMerkModel = LookUpMerkModel.fromJson(jsonDecode(res.body));
        return lookUpMerkModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        lookUpMerkModel = LookUpMerkModel.fromJson(jsonDecode(res.body));
        throw lookUpMerkModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<AssetDetailResponseModel> attemptGetAssetData(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_application_no'] = code;
    a.add(mapData);
    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlAssetDetail()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        assetDetailResponseModel =
            AssetDetailResponseModel.fromJson(jsonDecode(res.body));
        return assetDetailResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        assetDetailResponseModel =
            AssetDetailResponseModel.fromJson(jsonDecode(res.body));
        throw assetDetailResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<AddClientResponseModel> attemptUpdateAssetData(
      UpdateAssetRequestModel updateAssetRequestModel) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    a.add(updateAssetRequestModel.toJson());

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlUpdateAsset()),
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
