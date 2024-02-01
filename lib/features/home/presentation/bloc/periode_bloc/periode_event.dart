import 'package:equatable/equatable.dart';

abstract class PeriodeEvent extends Equatable {
  const PeriodeEvent();
}

class PeriodeAttempt extends PeriodeEvent {
  const PeriodeAttempt(this.uid);
  final String uid;
  @override
  List<Object> get props => [];
}
