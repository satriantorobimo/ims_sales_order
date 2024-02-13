import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_order/features/simulation/domain/repo/simulation_repo.dart';
import 'bloc.dart';

class SimulationBloc extends Bloc<SimulationEvent, SimulationState> {
  SimulationState get initialState => SimulationInitial();
  SimulationRepo simulationRepo = SimulationRepo();
  SimulationBloc({required this.simulationRepo}) : super(SimulationInitial()) {
    on<SimulationEvent>((event, emit) async {
      if (event is SimulationAttempt) {
        try {
          emit(SimulationLoading());
          final simulationResponseModel = await simulationRepo
              .attemptCalculateSimulation(event.simulationRequestModel);
          if (simulationResponseModel.result == 1) {
            emit(SimulationLoaded(
                simulationResponseModel: simulationResponseModel));
          } else if (simulationResponseModel.result == 0) {
            emit(SimulationError(simulationResponseModel.message));
          } else {
            emit(const SimulationException('error'));
          }
        } catch (e) {
          emit(SimulationException(e.toString()));
        }
      }
    });
  }
}
