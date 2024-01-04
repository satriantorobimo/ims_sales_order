import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';
import 'package:sales_order/features/application_form_summary/data/detail_summary_response_model.dart';
import 'package:sales_order/features/application_form_summary/domain/api/summary_api.dart';

class SummaryRepo {
  final SummaryApi summaryApi = SummaryApi();

  Future<DetailSummaryResponseModel> attemptDetailSummary(String code) =>
      summaryApi.attemptDetailSummary(code);

  Future<AddClientResponseModel> attemptSubmitSummary(String code) =>
      summaryApi.attemptSubmitSummary(code);
}
