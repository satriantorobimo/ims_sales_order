import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_3/data/look_up_dealer_model.dart';

abstract class DealerState extends Equatable {
  const DealerState();

  @override
  List<Object> get props => [];
}

class DealerInitial extends DealerState {}

class DealerLoading extends DealerState {}

class DealerLoaded extends DealerState {
  const DealerLoaded({required this.lookUpDealerModel});
  final LookUpDealerModel lookUpDealerModel;

  @override
  List<Object> get props => [lookUpDealerModel];
}

class DealerError extends DealerState {
  const DealerError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class DealerException extends DealerState {
  const DealerException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
