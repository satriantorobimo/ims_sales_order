import 'package:equatable/equatable.dart';

abstract class ProvEvent extends Equatable {
  const ProvEvent();
}

class ProvAttempt extends ProvEvent {
  const ProvAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
