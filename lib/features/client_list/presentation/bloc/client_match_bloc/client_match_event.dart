import 'package:equatable/equatable.dart';
import 'package:sales_order/features/client_list/data/client_matching_mode.dart';

abstract class ClientMatchEvent extends Equatable {
  const ClientMatchEvent();
}

class ClientMatchCorpAttempt extends ClientMatchEvent {
  const ClientMatchCorpAttempt(this.clientMatchingModel);
  final ClientMathcingModel clientMatchingModel;

  @override
  List<Object> get props => [clientMatchingModel];
}

class ClientMatchPersonalAttempt extends ClientMatchEvent {
  const ClientMatchPersonalAttempt(this.clientMatchingModel);
  final ClientMathcingModel clientMatchingModel;

  @override
  List<Object> get props => [clientMatchingModel];
}
