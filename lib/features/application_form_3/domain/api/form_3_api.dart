import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';
import 'package:sales_order/features/application_form_3/data/loan_data_detail_response_model.dart';
import 'package:sales_order/features/application_form_3/data/look_up_dealer_model.dart';
import 'package:sales_order/features/application_form_3/data/look_up_package_model.dart';
import 'package:sales_order/features/application_form_3/data/update_loan_data_request_model.dart';
import 'package:sales_order/utility/shared_pref_util.dart';
import 'package:sales_order/utility/url_util.dart';

class Form3Api {
  LookUpPackageModel lookUpPackageModel = LookUpPackageModel();
  LookUpDealerModel lookUpDealerModel = LookUpDealerModel();
  LoanDataDetailResponseModel loanDataDetailResponseModel =
      LoanDataDetailResponseModel();
  AddClientResponseModel addClientResponseModel = AddClientResponseModel();

  final UrlUtil urlUtil = UrlUtil();

  Future<LookUpPackageModel> attemptLookupPackage(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['default'] = code;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlLookUpPackage()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        lookUpPackageModel = LookUpPackageModel.fromJson(jsonDecode(res.body));
        return lookUpPackageModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        lookUpPackageModel = LookUpPackageModel.fromJson(jsonDecode(res.body));
        throw lookUpPackageModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<LookUpDealerModel> attemptLookupDealer(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['default'] = code;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlLookUpDealer()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        lookUpDealerModel = LookUpDealerModel.fromJson(jsonDecode(res.body));
        return lookUpDealerModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        lookUpDealerModel = LookUpDealerModel.fromJson(jsonDecode(res.body));
        throw lookUpDealerModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<LoanDataDetailResponseModel> attemptGetLoanData(String code) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_application_no'] = code;
    a.add(mapData);
    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlLoanDataDetail()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        loanDataDetailResponseModel =
            LoanDataDetailResponseModel.fromJson(jsonDecode(res.body));
        return loanDataDetailResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        loanDataDetailResponseModel =
            LoanDataDetailResponseModel.fromJson(jsonDecode(res.body));
        throw loanDataDetailResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<AddClientResponseModel> attemptUpdateLoanData(
      UpdateLoanDataRequestModel updateLoanDataRequestModel) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    a.add(updateLoanDataRequestModel.toJson());

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(
          Uri.parse(urlUtil.getUrlUpdateLoanDataDetail()),
          body: json,
          headers: header);
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
