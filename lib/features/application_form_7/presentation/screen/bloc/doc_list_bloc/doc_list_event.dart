import 'package:equatable/equatable.dart';

abstract class DocListEvent extends Equatable {
  const DocListEvent();
}

class DocListAttempt extends DocListEvent {
  const DocListAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
