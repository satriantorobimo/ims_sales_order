class SimulationRequestModel {
  String? pMarketingCode;
  int? pDpAmount;
  int? pFinancingAmount;
  String? pFirstPaymentType;
  int? pFlatRate;
  String? pInsurancePackageCode;
  int? pAdminFee;
  int? pProvisiFee;
  int? pOthersFee;

  SimulationRequestModel(
      {this.pMarketingCode,
      this.pDpAmount,
      this.pFinancingAmount,
      this.pFirstPaymentType,
      this.pFlatRate,
      this.pInsurancePackageCode,
      this.pAdminFee,
      this.pProvisiFee,
      this.pOthersFee});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p_marketing_code'] = pMarketingCode;
    data['p_dp_amount'] = pDpAmount;
    data['p_financing_amount'] = pFinancingAmount;
    data['p_first_payment_type'] = pFirstPaymentType;
    data['p_flat_rate'] = pFlatRate;
    data['p_insurance_package_code'] = pInsurancePackageCode;
    data['p_admin_fee'] = pAdminFee;
    data['p_provisi_fee'] = pProvisiFee;
    data['p_others_fee'] = pOthersFee;
    return data;
  }
}
