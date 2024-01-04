import 'package:equatable/equatable.dart';

abstract class DetailSummaryEvent extends Equatable {
  const DetailSummaryEvent();
}

class DetailSummaryAttempt extends DetailSummaryEvent {
  const DetailSummaryAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
