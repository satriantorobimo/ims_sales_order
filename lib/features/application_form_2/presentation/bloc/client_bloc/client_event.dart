import 'package:equatable/equatable.dart';
import 'package:sales_order/features/application_form_2/data/add_client_request_model.dart';

abstract class ClientEvent extends Equatable {
  const ClientEvent();
}

class ClientAddAttempt extends ClientEvent {
  const ClientAddAttempt(this.addClientRequestModel);
  final AddClientRequestModel addClientRequestModel;

  @override
  List<Object> get props => [addClientRequestModel];
}

class ClientUpdateAttempt extends ClientEvent {
  const ClientUpdateAttempt(this.addClientRequestModel);
  final AddClientRequestModel addClientRequestModel;

  @override
  List<Object> get props => [addClientRequestModel];
}

class ClientUseAttempt extends ClientEvent {
  const ClientUseAttempt(this.addClientRequestModel);
  final AddClientRequestModel addClientRequestModel;

  @override
  List<Object> get props => [addClientRequestModel];
}
