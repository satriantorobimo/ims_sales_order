import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_4/data/look_up_merk_model.dart';

abstract class TypeState extends Equatable {
  const TypeState();

  @override
  List<Object> get props => [];
}

class TypeInitial extends TypeState {}

class TypeLoading extends TypeState {}

class TypeLoaded extends TypeState {
  const TypeLoaded({required this.lookUpMerkModel});
  final LookUpMerkModel lookUpMerkModel;

  @override
  List<Object> get props => [lookUpMerkModel];
}

class TypeError extends TypeState {
  const TypeError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class TypeException extends TypeState {
  const TypeException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
