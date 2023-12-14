import 'package:equatable/equatable.dart';

abstract class TypeEvent extends Equatable {
  const TypeEvent();
}

class TypeAttempt extends TypeEvent {
  const TypeAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
