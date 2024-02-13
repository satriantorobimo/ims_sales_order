class SendPdfRequestModel {
  String? pMarketingCode;
  String? pClientName;
  String? pClientPhoneNo;
  String? pClientEmail;
  String? pVehicleName;
  int? pOtr;
  int? pDpPct;
  int? pDpAmount;
  int? pFinancingAmount;
  String? pFirstPaymentType;
  int? pFlatRate;
  int? pAdminFee;
  int? pProvisiFee;
  String? pInsurancePackageCode;
  String? pInsurancePackageName;
  int? pOthersFee;

  SendPdfRequestModel(
      {this.pMarketingCode,
      this.pClientName,
      this.pClientPhoneNo,
      this.pClientEmail,
      this.pVehicleName,
      this.pOtr,
      this.pDpPct,
      this.pDpAmount,
      this.pFinancingAmount,
      this.pFirstPaymentType,
      this.pFlatRate,
      this.pAdminFee,
      this.pProvisiFee,
      this.pInsurancePackageCode,
      this.pInsurancePackageName,
      this.pOthersFee});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p_marketing_code'] = pMarketingCode;
    data['p_client_name'] = pClientName;
    data['p_client_phone_no'] = pClientPhoneNo;
    data['p_client_email'] = pClientEmail;
    data['p_vehicle_name'] = pVehicleName;
    data['p_otr'] = pOtr;
    data['p_dp_pct'] = pDpPct;
    data['p_dp_amount'] = pDpAmount;
    data['p_financing_amount'] = pFinancingAmount;
    data['p_first_payment_type'] = pFirstPaymentType;
    data['p_flat_rate'] = pFlatRate;
    data['p_admin_fee'] = pAdminFee;
    data['p_provisi_fee'] = pProvisiFee;
    data['p_insurance_package_code'] = pInsurancePackageCode;
    data['p_insurance_package_name'] = pInsurancePackageName;
    data['p_others_fee'] = pOthersFee;
    return data;
  }
}
