import 'package:equatable/equatable.dart';

abstract class WorkEvent extends Equatable {
  const WorkEvent();
}

class WorkAttempt extends WorkEvent {
  const WorkAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
