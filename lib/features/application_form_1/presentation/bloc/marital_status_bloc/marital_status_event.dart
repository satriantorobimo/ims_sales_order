import 'package:equatable/equatable.dart';

abstract class MaritalStatusEvent extends Equatable {
  const MaritalStatusEvent();
}

class MaritalStatusAttempt extends MaritalStatusEvent {
  const MaritalStatusAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
