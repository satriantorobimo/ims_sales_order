import 'package:equatable/equatable.dart';

abstract class CancelClientEvent extends Equatable {
  const CancelClientEvent();
}

class CancelClientAttempt extends CancelClientEvent {
  const CancelClientAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
