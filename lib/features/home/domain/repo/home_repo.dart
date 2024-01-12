import 'package:sales_order/features/home/data/app_list_response_model.dart';
import 'package:sales_order/features/home/data/app_status_response_model.dart';
import 'package:sales_order/features/home/data/data_periode_response_model.dart';
import 'package:sales_order/features/home/domain/api/home_api.dart';

class HomeRepo {
  final HomeApi homeApi = HomeApi();

  Future<AppStatusResponseModel?> attemptGetAppStatus() =>
      homeApi.attemptGetAppStatus();

  Future<AppListResponseModel?> attemptGetAppList() =>
      homeApi.attemptGetAppList();

  Future<DataPeriodeResponseModel?> attemptPeriodeList() =>
      homeApi.attemptPeriodeList();
}
