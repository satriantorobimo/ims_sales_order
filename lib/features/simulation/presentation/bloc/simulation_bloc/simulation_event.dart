import 'package:equatable/equatable.dart';
import 'package:sales_order/features/simulation/data/simulation_request_model.dart';

abstract class SimulationEvent extends Equatable {
  const SimulationEvent();
}

class SimulationAttempt extends SimulationEvent {
  const SimulationAttempt(this.simulationRequestModel);
  final SimulationRequestModel simulationRequestModel;

  @override
  List<Object> get props => [simulationRequestModel];
}
