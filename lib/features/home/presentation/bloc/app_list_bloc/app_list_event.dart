import 'package:equatable/equatable.dart';

abstract class AppListEvent extends Equatable {
  const AppListEvent();
}

class AppListAttempt extends AppListEvent {
  const AppListAttempt();

  @override
  List<Object> get props => [];
}
