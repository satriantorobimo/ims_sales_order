import 'package:equatable/equatable.dart';

abstract class FamilyEvent extends Equatable {
  const FamilyEvent();
}

class FamilyAttempt extends FamilyEvent {
  const FamilyAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
