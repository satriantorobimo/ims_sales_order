import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';
import 'package:sales_order/features/application_form_5/data/application_fee_detail_model.dart';
import 'package:sales_order/features/application_form_5/data/look_up_insurance_package_model.dart';
import 'package:sales_order/features/application_form_5/data/tnc_data_detail_response_model.dart';
import 'package:sales_order/features/application_form_5/data/update_tnc_request_model.dart';
import 'package:sales_order/utility/shared_pref_util.dart';
import 'package:sales_order/utility/url_util.dart';

class Form5Api {
  LookUpInsurancePackageModel lookUpInsurancePackageModel =
      LookUpInsurancePackageModel();
  TncDataDetailResponseModel tncDataDetailResponseModel =
      TncDataDetailResponseModel();
  AddClientResponseModel addClientResponseModel = AddClientResponseModel();
  ApplicationFeeDetailModel applicationFeeDetailModel =
      ApplicationFeeDetailModel();

  final UrlUtil urlUtil = UrlUtil();

  Future<LookUpInsurancePackageModel> attemptLookupInsurance(
      String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['default'] = code;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlLookUpInsurance()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        lookUpInsurancePackageModel =
            LookUpInsurancePackageModel.fromJson(jsonDecode(res.body));
        return lookUpInsurancePackageModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        lookUpInsurancePackageModel =
            LookUpInsurancePackageModel.fromJson(jsonDecode(res.body));
        throw lookUpInsurancePackageModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<TncDataDetailResponseModel> attemptGetTncData(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_application_no'] = code;
    a.add(mapData);
    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlTncDetail()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        tncDataDetailResponseModel =
            TncDataDetailResponseModel.fromJson(jsonDecode(res.body));
        return tncDataDetailResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        tncDataDetailResponseModel =
            TncDataDetailResponseModel.fromJson(jsonDecode(res.body));
        throw tncDataDetailResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<AddClientResponseModel> attemptUpdateTncData(
      UpdateTncRequestModel updateTncRequestModel) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    a.add(updateTncRequestModel.toJson());

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlTncUpdate()),
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

  Future<ApplicationFeeDetailModel> attemptGetFeeData(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_application_no'] = code;
    a.add(mapData);
    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlFeeDetail()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        applicationFeeDetailModel =
            ApplicationFeeDetailModel.fromJson(jsonDecode(res.body));
        return applicationFeeDetailModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        applicationFeeDetailModel =
            ApplicationFeeDetailModel.fromJson(jsonDecode(res.body));
        throw applicationFeeDetailModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
