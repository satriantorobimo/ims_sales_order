import 'package:sales_order/features/application_form_1/data/check_scoring_response_model.dart';
import 'package:sales_order/features/application_form_1/data/look_up_mso_response_model.dart';
import 'package:sales_order/features/application_form_1/data/zip_code_response_model.dart';
import 'package:sales_order/features/application_form_1/domain/api/form_1_api.dart';

class Form1Repo {
  final Form1Api form1api = Form1Api();

  Future<CheckScoringResponseModel> attemptCheclScoring(String code) =>
      form1api.attemptCheclScoring(code);

  Future<LookUpMsoResponseModel> attemptLookupMso(String code) =>
      form1api.attemptLookupMso(code);

  Future<LookUpMsoResponseModel> attemptLookupProv(String code) =>
      form1api.attemptLookupProv(code);

  Future<LookUpMsoResponseModel> attemptLookupCity(String code) =>
      form1api.attemptLookupCity(code);

  Future<ZipCodeResponseModel> attemptLookupZipCode(String code) =>
      form1api.attemptLookupZipCode(code);
}
