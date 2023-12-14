class TncDataDetailResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;
  String? code;
  int? id;

  TncDataDetailResponseModel(
      {this.result,
      this.statusCode,
      this.message,
      this.data,
      this.code,
      this.id});

  TncDataDetailResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    statusCode = json['StatusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    code = json['code'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['StatusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['code'] = code;
    data['id'] = id;
    return data;
  }
}

class Data {
  int? assetValue;
  int? dpPct;
  int? dpAmount;
  int? tenor;
  String? firstPaymentType;
  String? firstPaymentTypeDesc;
  double? interestFlatRate;
  int? installmentAmount;
  String? insurancePackageCode;
  String? insurancePackageDesc;

  Data(
      {this.assetValue,
      this.dpPct,
      this.dpAmount,
      this.tenor,
      this.firstPaymentType,
      this.firstPaymentTypeDesc,
      this.interestFlatRate,
      this.installmentAmount,
      this.insurancePackageCode,
      this.insurancePackageDesc});

  Data.fromJson(Map<String, dynamic> json) {
    assetValue = json['asset_value'];
    dpPct = json['dp_pct'];
    dpAmount = json['dp_amount'];
    tenor = json['tenor'];
    firstPaymentType = json['first_payment_type'];
    firstPaymentTypeDesc = json['first_payment_type_desc'];
    interestFlatRate = json['interest_flat_rate'];
    installmentAmount = json['installment_amount'];
    insurancePackageCode = json['insurance_package_code'];
    insurancePackageDesc = json['insurance_package_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['asset_value'] = assetValue;
    data['dp_pct'] = dpPct;
    data['dp_amount'] = dpAmount;
    data['tenor'] = tenor;
    data['first_payment_type'] = firstPaymentType;
    data['first_payment_type_desc'] = firstPaymentTypeDesc;
    data['interest_flat_rate'] = interestFlatRate;
    data['installment_amount'] = installmentAmount;
    data['insurance_package_code'] = insurancePackageCode;
    data['insurance_package_desc'] = insurancePackageDesc;
    return data;
  }
}
