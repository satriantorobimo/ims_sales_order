import 'package:equatable/equatable.dart';

abstract class CheckValidityEvent extends Equatable {
  const CheckValidityEvent();
}

class CheckValidityAttempt extends CheckValidityEvent {
  const CheckValidityAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
