import 'package:equatable/equatable.dart';

abstract class InsuranceEvent extends Equatable {
  const InsuranceEvent();
}

class InsuranceAttempt extends InsuranceEvent {
  const InsuranceAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
