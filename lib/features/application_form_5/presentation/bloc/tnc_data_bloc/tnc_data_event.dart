import 'package:equatable/equatable.dart';

abstract class TncDataEvent extends Equatable {
  const TncDataEvent();
}

class TncDataAttempt extends TncDataEvent {
  const TncDataAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
