import 'package:sales_order/features/application_form_2/data/add_client_response_model.dart';
import 'package:sales_order/features/simulation/data/send_pdf_request_model.dart';
import 'package:sales_order/features/simulation/data/simulation_request_model.dart';
import 'package:sales_order/features/simulation/data/simulation_response_model.dart';
import 'package:sales_order/features/simulation/domain/api/simulation_api.dart';

class SimulationRepo {
  final SimulationApi simulationApi = SimulationApi();

  Future<SimulationResponseModel> attemptCalculateSimulation(
          SimulationRequestModel simulationRequestModel) =>
      simulationApi.attemptCalculateSimulation(simulationRequestModel);

  Future<AddClientResponseModel> attemptSendPdf(
          SendPdfRequestModel sendPdfRequestModel) =>
      simulationApi.attemptSendPdf(sendPdfRequestModel);
}
