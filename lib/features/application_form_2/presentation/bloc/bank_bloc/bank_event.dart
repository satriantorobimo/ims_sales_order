import 'package:equatable/equatable.dart';

abstract class BankEvent extends Equatable {
  const BankEvent();
}

class BankAttempt extends BankEvent {
  const BankAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
