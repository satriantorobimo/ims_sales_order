import 'package:equatable/equatable.dart';

abstract class GetClientEvent extends Equatable {
  const GetClientEvent();
}

class GetClientAttempt extends GetClientEvent {
  const GetClientAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
