import 'package:equatable/equatable.dart';

abstract class AppStatusEvent extends Equatable {
  const AppStatusEvent();
}

class AppStatusAttempt extends AppStatusEvent {
  const AppStatusAttempt();

  @override
  List<Object> get props => [];
}
