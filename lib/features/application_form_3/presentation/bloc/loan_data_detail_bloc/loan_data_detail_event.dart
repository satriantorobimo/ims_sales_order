import 'package:equatable/equatable.dart';

abstract class LoanDataDetailEvent extends Equatable {
  const LoanDataDetailEvent();
}

class LoanDataDetailAttempt extends LoanDataDetailEvent {
  const LoanDataDetailAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
