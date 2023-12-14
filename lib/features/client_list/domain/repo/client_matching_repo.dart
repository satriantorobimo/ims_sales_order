import 'package:sales_order/features/client_list/data/client_matching_corp_response_model.dart';
import 'package:sales_order/features/client_list/data/client_matching_mode.dart';
import 'package:sales_order/features/client_list/data/client_matching_personal_response_model.dart';
import 'package:sales_order/features/client_list/domain/api/client_matching_api.dart';

class ClientMatchingRepo {
  final ClientMatchingApi clientMatchingApi = ClientMatchingApi();
  Future<ClientMathcingCorpResponseModel> attemptClientMatchingCorp(
          ClientMathcingModel clientMathcingModel) =>
      clientMatchingApi.attemptClientMatchingCorp(clientMathcingModel);

  Future<ClientMathcingPersonalResponseModel> attemptClientMatchingPersonal(
          ClientMathcingModel clientMathcingModel) =>
      clientMatchingApi.attemptClientMatchingPersonal(clientMathcingModel);
}
