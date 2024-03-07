class DetailSummaryResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;
  String? code;
  int? id;

  DetailSummaryResponseModel(
      {this.result,
      this.statusCode,
      this.message,
      this.data,
      this.code,
      this.id});

  DetailSummaryResponseModel.fromJson(Map<String, dynamic> json) {
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
  double? tdpAmount;
  double? installmentAmount;
  int? dueDate;
  int? clientSignId;
  String? clientSignImg;
  int? clientSpouseSignId;
  String? clientSpouseSignImg;

  Data(
      {this.tdpAmount,
      this.installmentAmount,
      this.dueDate,
      this.clientSignId,
      this.clientSignImg,
      this.clientSpouseSignId,
      this.clientSpouseSignImg});

  Data.fromJson(Map<String, dynamic> json) {
    tdpAmount = json['tdp_amount'];
    installmentAmount = json['installment_amount'];
    dueDate = json['due_date'];
    clientSignId = json['client_sign_id'];
    clientSignImg = json['client_sign_img'];
    clientSpouseSignId = json['client_spouse_sign_id'];
    clientSpouseSignImg = json['client_spouse_sign_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tdp_amount'] = tdpAmount;
    data['installment_amount'] = installmentAmount;
    data['due_date'] = dueDate;
    data['client_sign_id'] = clientSignId;
    data['client_sign_img'] = clientSignImg ?? '';
    data['client_spouse_sign_id'] = clientSpouseSignId;
    data['client_spouse_sign_img'] = clientSpouseSignImg ?? '';
    return data;
  }
}
