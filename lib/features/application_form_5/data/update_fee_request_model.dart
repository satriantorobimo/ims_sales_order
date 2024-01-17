class UpdateFeeRequestModel {
  int? pId;
  int? pFeeAmount;
  String? pFeePaymentType;
  String? pApplicationNo;

  UpdateFeeRequestModel(
      {this.pId, this.pFeeAmount, this.pFeePaymentType, this.pApplicationNo});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p_id'] = pId;
    data['p_fee_amount'] = pFeeAmount;
    data['p_fee_payment_type'] = pFeePaymentType;
    data['p_application_no'] = pApplicationNo;
    return data;
  }
}
