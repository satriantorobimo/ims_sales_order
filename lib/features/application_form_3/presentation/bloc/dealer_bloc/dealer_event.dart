import 'package:equatable/equatable.dart';

abstract class DealerEvent extends Equatable {
  const DealerEvent();
}

class DealerAttempt extends DealerEvent {
  const DealerAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
