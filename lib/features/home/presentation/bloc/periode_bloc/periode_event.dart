import 'package:equatable/equatable.dart';

abstract class PeriodeEvent extends Equatable {
  const PeriodeEvent();
}

class PeriodeAttempt extends PeriodeEvent {
  const PeriodeAttempt();

  @override
  List<Object> get props => [];
}
