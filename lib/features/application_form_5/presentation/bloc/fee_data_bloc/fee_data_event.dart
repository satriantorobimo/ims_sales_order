import 'package:equatable/equatable.dart';

abstract class FeeDataEvent extends Equatable {
  const FeeDataEvent();
}

class FeeDataAttempt extends FeeDataEvent {
  const FeeDataAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
