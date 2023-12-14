import 'package:equatable/equatable.dart';

abstract class MerkEvent extends Equatable {
  const MerkEvent();
}

class MerkAttempt extends MerkEvent {
  const MerkAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
