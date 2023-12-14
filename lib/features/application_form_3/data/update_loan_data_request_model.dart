class UpdateLoanDataRequestModel {
  String? pApplicationNo;
  String? pPackageCode;
  String? pDealerCode;
  String? pRemark;
  String? pMarketingCode;
  String? pMarketingName;

  UpdateLoanDataRequestModel(
      {this.pApplicationNo,
      this.pPackageCode,
      this.pDealerCode,
      this.pRemark,
      this.pMarketingCode,
      this.pMarketingName});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p_application_no'] = pApplicationNo;
    data['p_package_code'] = pPackageCode;
    data['p_dealer_code'] = pDealerCode;
    data['p_remark'] = pRemark;
    data['p_marketing_code'] = pMarketingCode;
    data['p_marketing_name'] = pMarketingName;
    return data;
  }
}
