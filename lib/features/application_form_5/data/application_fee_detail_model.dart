class ApplicationFeeDetailModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;
  String? code;
  int? id;

  ApplicationFeeDetailModel(
      {this.result,
      this.statusCode,
      this.message,
      this.data,
      this.code,
      this.id});

  ApplicationFeeDetailModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? feeDesc;
  int? feeAmount;
  String? feePaymentType;

  Data({this.id, this.feeDesc, this.feeAmount, this.feePaymentType});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feeDesc = json['fee_desc'];
    feeAmount = json['fee_amount'];
    feePaymentType = json['fee_payment_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fee_desc'] = feeDesc;
    data['fee_amount'] = feeAmount;
    data['fee_payment_type'] = feePaymentType;
    return data;
  }
}
