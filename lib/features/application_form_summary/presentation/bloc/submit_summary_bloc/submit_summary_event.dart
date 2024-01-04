import 'package:equatable/equatable.dart';

abstract class SubmitSummaryEvent extends Equatable {
  const SubmitSummaryEvent();
}

class SubmitSummaryAttempt extends SubmitSummaryEvent {
  const SubmitSummaryAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
