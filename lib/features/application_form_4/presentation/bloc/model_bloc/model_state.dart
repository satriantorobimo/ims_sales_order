import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_4/data/look_up_merk_model.dart';

abstract class ModelState extends Equatable {
  const ModelState();

  @override
  List<Object> get props => [];
}

class ModelInitial extends ModelState {}

class ModelLoading extends ModelState {}

class ModelLoaded extends ModelState {
  const ModelLoaded({required this.lookUpMerkModel});
  final LookUpMerkModel lookUpMerkModel;

  @override
  List<Object> get props => [lookUpMerkModel];
}

class ModelError extends ModelState {
  const ModelError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class ModelException extends ModelState {
  const ModelException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
