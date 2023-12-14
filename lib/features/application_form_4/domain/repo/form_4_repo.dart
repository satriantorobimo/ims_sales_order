import 'package:sales_order/features/application_form_1/data/check_scoring_response_model.dart';
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';
import 'package:sales_order/features/application_form_4/data/asset_detail_response_model.dart';
import 'package:sales_order/features/application_form_4/data/look_up_merk_model.dart';
import 'package:sales_order/features/application_form_4/data/update_asset_request_model.dart';
import 'package:sales_order/features/application_form_4/domain/api/form_4_api.dart';

class Form4Repo {
  final Form4Api form4api = Form4Api();

  Future<LookUpMerkModel> attemptLookupMerk(String code) =>
      form4api.attemptLookupMerk(code);

  Future<LookUpMerkModel> attemptLookupType(String code) =>
      form4api.attemptLookupType(code);

  Future<LookUpMerkModel> attemptLookupModel(String code) =>
      form4api.attemptLookupModel(code);

  Future<AssetDetailResponseModel> attemptGetAssetData(String code) =>
      form4api.attemptGetAssetData(code);

  Future<AddClientResponseModel> attemptUpdateAssetData(
          UpdateAssetRequestModel updateAssetRequestModel) =>
      form4api.attemptUpdateAssetData(updateAssetRequestModel);

  Future<CheckScoringResponseModel> attemptCheckValidity(String code) =>
      form4api.attemptCheckValidity(code);
}
