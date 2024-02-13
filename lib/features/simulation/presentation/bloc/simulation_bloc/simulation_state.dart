import 'package:equatable/equatable.dart';
import 'package:sales_order/features/simulation/data/simulation_response_model.dart';

abstract class SimulationState extends Equatable {
  const SimulationState();

  @override
  List<Object> get props => [];
}

class SimulationInitial extends SimulationState {}

class SimulationLoading extends SimulationState {}

class SimulationLoaded extends SimulationState {
  const SimulationLoaded({required this.simulationResponseModel});
  final SimulationResponseModel simulationResponseModel;

  @override
  List<Object> get props => [simulationResponseModel];
}

class SimulationError extends SimulationState {
  const SimulationError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class SimulationException extends SimulationState {
  const SimulationException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
