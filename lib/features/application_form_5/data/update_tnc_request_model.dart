class UpdateTncRequestModel {
  String? pApplicationNo;
  int? pTenor;
  String? pPaymentType;
  String? pInsurancePackageCode;

  UpdateTncRequestModel(
      {this.pApplicationNo,
      this.pTenor,
      this.pPaymentType,
      this.pInsurancePackageCode});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p_application_no'] = pApplicationNo;
    data['p_tenor'] = pTenor;
    data['p_payment_type'] = pPaymentType;
    data['p_insurance_package_code'] = pInsurancePackageCode;
    return data;
  }
}
