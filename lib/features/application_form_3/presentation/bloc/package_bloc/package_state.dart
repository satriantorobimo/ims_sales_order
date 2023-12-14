import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_3/data/look_up_package_model.dart';

abstract class PackageState extends Equatable {
  const PackageState();

  @override
  List<Object> get props => [];
}

class PackageInitial extends PackageState {}

class PackageLoading extends PackageState {}

class PackageLoaded extends PackageState {
  const PackageLoaded({required this.lookUpPackageModel});
  final LookUpPackageModel lookUpPackageModel;

  @override
  List<Object> get props => [lookUpPackageModel];
}

class PackageError extends PackageState {
  const PackageError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class PackageException extends PackageState {
  const PackageException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
