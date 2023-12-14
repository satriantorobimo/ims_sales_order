import 'package:equatable/equatable.dart';

abstract class ModelEvent extends Equatable {
  const ModelEvent();
}

class ModelAttempt extends ModelEvent {
  const ModelAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
