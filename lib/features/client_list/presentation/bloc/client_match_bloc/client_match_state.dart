import 'package:equatable/equatable.dart';
import 'package:sales_order/features/client_list/data/client_matching_corp_response_model.dart';
import 'package:sales_order/features/client_list/data/client_matching_personal_response_model.dart';

abstract class ClientMatchState extends Equatable {
  const ClientMatchState();

  @override
  List<Object> get props => [];
}

class ClientMatchInitial extends ClientMatchState {}

class ClientMatchLoading extends ClientMatchState {}

class ClientMatchCorpLoaded extends ClientMatchState {
  const ClientMatchCorpLoaded({required this.clientMathcingCorpResponseModel});
  final ClientMathcingCorpResponseModel clientMathcingCorpResponseModel;

  @override
  List<Object> get props => [clientMathcingCorpResponseModel];
}

class ClientMatchPersonalLoaded extends ClientMatchState {
  const ClientMatchPersonalLoaded(
      {required this.clientMathcingPersonalResponseModel});
  final ClientMathcingPersonalResponseModel clientMathcingPersonalResponseModel;

  @override
  List<Object> get props => [clientMathcingPersonalResponseModel];
}

class ClientMatchError extends ClientMatchState {
  const ClientMatchError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class ClientMatchException extends ClientMatchState {
  const ClientMatchException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
