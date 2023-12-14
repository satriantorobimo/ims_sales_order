import 'package:sales_order/features/application_form_1/data/look_up_mso_response_model.dart';
import 'package:sales_order/features/application_form_2/data/add_client_request_model.dart';
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';
import 'package:sales_order/features/application_form_2/domain/api/form_2_api.dart';

class Form2Repo {
  final Form2Api form2api = Form2Api();

  Future<LookUpMsoResponseModel> attemptLookupMso(String code) =>
      form2api.attemptLookupMso(code);

  Future<LookUpMsoResponseModel> attemptLookupBank(String code) =>
      form2api.attemptLookupBank(code);

  Future<AddClientResponseModel> attemptAddClient(
          AddClientRequestModel addClientRequestModel) =>
      form2api.attemptAddClient(addClientRequestModel);

  Future<AddClientResponseModel> attemptUpdateClient(
          AddClientRequestModel addClientRequestModel) =>
      form2api.attemptUpdateClient(addClientRequestModel);
}
