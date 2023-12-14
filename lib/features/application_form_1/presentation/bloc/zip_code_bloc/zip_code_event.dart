import 'package:equatable/equatable.dart';

abstract class ZipCodeEvent extends Equatable {
  const ZipCodeEvent();
}

class ZipCodeAttempt extends ZipCodeEvent {
  const ZipCodeAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
