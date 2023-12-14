import 'package:equatable/equatable.dart';

abstract class AssetDataDetailEvent extends Equatable {
  const AssetDataDetailEvent();
}

class AssetDataDetailAttempt extends AssetDataDetailEvent {
  const AssetDataDetailAttempt(this.code);
  final String code;

  @override
  List<Object> get props => [code];
}
