import 'package:equatable/equatable.dart';
import 'package:sales_order/features/simulation/data/send_pdf_request_model.dart';

abstract class SendPdfEvent extends Equatable {
  const SendPdfEvent();
}

class SendPdfAttempt extends SendPdfEvent {
  const SendPdfAttempt(this.sendPdfRequestModel);
  final SendPdfRequestModel sendPdfRequestModel;

  @override
  List<Object> get props => [sendPdfRequestModel];
}
