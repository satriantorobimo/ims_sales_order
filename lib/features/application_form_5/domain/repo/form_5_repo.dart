import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';
import 'package:sales_order/features/application_form_5/data/application_fee_detail_model.dart';
import 'package:sales_order/features/application_form_5/data/look_up_insurance_package_model.dart';
import 'package:sales_order/features/application_form_5/data/tnc_data_detail_response_model.dart';
import 'package:sales_order/features/application_form_5/data/update_tnc_request_model.dart';
import 'package:sales_order/features/application_form_5/domain/api/form_5_api.dart';

class Form5Repo {
  final Form5Api form5api = Form5Api();

  Future<LookUpInsurancePackageModel> attemptLookupInsurance(String code) =>
      form5api.attemptLookupInsurance(code);

  Future<TncDataDetailResponseModel> attemptGetTncData(String code) =>
      form5api.attemptGetTncData(code);

  Future<ApplicationFeeDetailModel> attemptGetFeeData(String code) =>
      form5api.attemptGetFeeData(code);

  Future<AddClientResponseModel> attemptUpdateTncData(
          UpdateTncRequestModel updateTncRequestModel) =>
      form5api.attemptUpdateTncData(updateTncRequestModel);
}
