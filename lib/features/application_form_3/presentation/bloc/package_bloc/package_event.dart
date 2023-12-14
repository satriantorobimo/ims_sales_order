import 'package:equatable/equatable.dart';

abstract class PackageEvent extends Equatable {
  const PackageEvent();
}

class PackageAttempt extends PackageEvent {
  const PackageAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
