import 'package:equatable/equatable.dart';

abstract class CityEvent extends Equatable {
  const CityEvent();
}

class CityAttempt extends CityEvent {
  const CityAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
