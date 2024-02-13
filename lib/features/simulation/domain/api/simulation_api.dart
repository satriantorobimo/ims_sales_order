import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';
import 'package:sales_order/features/simulation/data/send_pdf_request_model.dart';
import 'package:sales_order/features/simulation/data/simulation_request_model.dart';
import 'package:sales_order/features/simulation/data/simulation_response_model.dart';
import 'package:sales_order/utility/shared_pref_util.dart';
import 'package:sales_order/utility/url_util.dart';

class SimulationApi {
  SimulationResponseModel simulationResponseModel = SimulationResponseModel();
  AddClientResponseModel addClientResponseModel = AddClientResponseModel();
  final UrlUtil urlUtil = UrlUtil();

  Future<SimulationResponseModel> attemptCalculateSimulation(
      SimulationRequestModel simulationRequestModel) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    a.add(simulationRequestModel.toJson());
    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlCalcSimulation()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        simulationResponseModel =
            SimulationResponseModel.fromJson(jsonDecode(res.body));
        return simulationResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        simulationResponseModel =
            SimulationResponseModel.fromJson(jsonDecode(res.body));
        throw simulationResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<AddClientResponseModel> attemptSendPdf(
      SendPdfRequestModel sendPdfRequestModel) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(token!);
    a.add(sendPdfRequestModel.toJson());
    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlSendPdf()),
          body: json, headers: header);
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
