import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_4/data/look_up_merk_model.dart';

abstract class MerkState extends Equatable {
  const MerkState();

  @override
  List<Object> get props => [];
}

class MerkInitial extends MerkState {}

class MerkLoading extends MerkState {}

class MerkLoaded extends MerkState {
  const MerkLoaded({required this.lookUpMerkModel});
  final LookUpMerkModel lookUpMerkModel;

  @override
  List<Object> get props => [lookUpMerkModel];
}

class MerkError extends MerkState {
  const MerkError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class MerkException extends MerkState {
  const MerkException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
