import 'package:equatable/equatable.dart';

abstract class CheckScoringEvent extends Equatable {
  const CheckScoringEvent();
}

class CheckScoringAttempt extends CheckScoringEvent {
  const CheckScoringAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
