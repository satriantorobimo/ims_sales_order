import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_order/features/home/data/app_list_response_model.dart';
import 'package:sales_order/features/home/data/app_status_response_model.dart';
import 'package:sales_order/features/home/data/data_periode_response_model.dart';
import 'package:sales_order/utility/shared_pref_util.dart';
import 'package:sales_order/utility/url_util.dart';

class HomeApi {
  AppStatusResponseModel appStatusResponseModel = AppStatusResponseModel();
  AppListResponseModel appListResponseModel = AppListResponseModel();
  DataPeriodeResponseModel dataPeriodeResponseModel =
      DataPeriodeResponseModel();
  UrlUtil urlUtil = UrlUtil();

  Future<AppStatusResponseModel> attemptGetAppStatus(String uid) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_marketing_code'] = uid;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlAppStatus()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        appStatusResponseModel =
            AppStatusResponseModel.fromJson(jsonDecode(res.body));
        return appStatusResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        appStatusResponseModel =
            AppStatusResponseModel.fromJson(jsonDecode(res.body));
        throw appStatusResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<AppListResponseModel> attemptGetAppList(String uid) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_marketing_code'] = uid;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlAppList()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        appListResponseModel =
            AppListResponseModel.fromJson(jsonDecode(res.body));
        return appListResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        appListResponseModel =
            AppListResponseModel.fromJson(jsonDecode(res.body));
        throw appListResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<DataPeriodeResponseModel> attemptPeriodeList(String uid) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    final Map mapData = {};
    mapData['p_marketing_code'] = uid;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlDataPeriode()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        dataPeriodeResponseModel =
            DataPeriodeResponseModel.fromJson(jsonDecode(res.body));
        return dataPeriodeResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        dataPeriodeResponseModel =
            DataPeriodeResponseModel.fromJson(jsonDecode(res.body));
        throw dataPeriodeResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
