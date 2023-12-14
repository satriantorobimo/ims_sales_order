import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';
import 'package:sales_order/features/application_form_3/data/loan_data_detail_response_model.dart';
import 'package:sales_order/features/application_form_3/data/look_up_dealer_model.dart';
import 'package:sales_order/features/application_form_3/data/look_up_package_model.dart';
import 'package:sales_order/features/application_form_3/data/update_loan_data_request_model.dart';
import 'package:sales_order/features/application_form_3/domain/api/form_3_api.dart';

class Form3Repo {
  final Form3Api form3api = Form3Api();

  Future<LookUpPackageModel> attemptLookupPackage(String code) =>
      form3api.attemptLookupPackage(code);

  Future<LookUpDealerModel> attemptLookupDealer(String code) =>
      form3api.attemptLookupDealer(code);

  Future<LoanDataDetailResponseModel> attemptGetLoanData(String code) =>
      form3api.attemptGetLoanData(code);

  Future<AddClientResponseModel> attemptUpdateLoanData(
          UpdateLoanDataRequestModel updateLoanDataRequestModel) =>
      form3api.attemptUpdateLoanData(updateLoanDataRequestModel);
}
