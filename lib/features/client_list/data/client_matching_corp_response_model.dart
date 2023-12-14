class ClientMathcingCorpResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;
  String? code;
  int? id;

  ClientMathcingCorpResponseModel(
      {this.result,
      this.statusCode,
      this.message,
      this.data,
      this.code,
      this.id});

  ClientMathcingCorpResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? clientCode;
  String? clientType;
  String? corporateStatusDesc;
  String? fullName;
  String? estDate;
  String? idNo;
  String? checkStatus;
  String? clientNo;

  Data(
      {this.clientCode,
      this.clientType,
      this.corporateStatusDesc,
      this.fullName,
      this.estDate,
      this.idNo,
      this.checkStatus,
      this.clientNo});

  Data.fromJson(Map<String, dynamic> json) {
    clientCode = json['client_code'];
    clientType = json['client_type'];
    corporateStatusDesc = json['corporate_status_desc'];
    fullName = json['full_name'];
    estDate = json['est_date'];
    idNo = json['id_no'];
    checkStatus = json['check_status'];
    clientNo = json['client_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['client_code'] = clientCode;
    data['client_type'] = clientType;
    data['corporate_status_desc'] = corporateStatusDesc;
    data['full_name'] = fullName;
    data['est_date'] = estDate;
    data['id_no'] = idNo;
    data['check_status'] = checkStatus;
    data['client_no'] = clientNo;
    return data;
  }
}
