import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/simulation/domain/repo/simulation_repo.dart';
import 'bloc.dart';

class SendPdfBloc extends Bloc<SendPdfEvent, SendPdfState> {
  SendPdfState get initialState => SendPdfInitial();
  SimulationRepo simulationRepo = SimulationRepo();
  SendPdfBloc({required this.simulationRepo}) : super(SendPdfInitial()) {
    on<SendPdfEvent>((event, emit) async {
      if (event is SendPdfAttempt) {
        try {
          emit(SendPdfLoading());
          final addClientResponseModel =
              await simulationRepo.attemptSendPdf(event.sendPdfRequestModel);
          if (addClientResponseModel.result == 1) {
            emit(SendPdfLoaded(addClientResponseModel: addClientResponseModel));
          } else if (addClientResponseModel.result == 0) {
            emit(SendPdfError(addClientResponseModel.message));
          } else {
            emit(const SendPdfException('error'));
          }
        } catch (e) {
          emit(SendPdfException(e.toString()));
        }
      }
    });
  }
}
