class ClientMathcingPersonalResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;
  String? code;
  int? id;

  ClientMathcingPersonalResponseModel(
      {this.result,
      this.statusCode,
      this.message,
      this.data,
      this.code,
      this.id});

  ClientMathcingPersonalResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? clientNo;
  String? clientType;
  String? fullName;
  String? motherMaidenName;
  String? placeOfBirth;
  String? dateOfBirth;
  String? idNo;
  String? checkStatus;

  Data(
      {this.clientCode,
      this.clientNo,
      this.clientType,
      this.fullName,
      this.motherMaidenName,
      this.placeOfBirth,
      this.dateOfBirth,
      this.idNo,
      this.checkStatus});

  Data.fromJson(Map<String, dynamic> json) {
    clientCode = json['client_code'];
    clientNo = json['client_no'];
    clientType = json['client_type'];
    fullName = json['full_name'];
    motherMaidenName = json['mother_maiden_name'];
    placeOfBirth = json['place_of_birth'];
    dateOfBirth = json['date_of_birth'];
    idNo = json['id_no'];
    checkStatus = json['check_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['client_code'] = clientCode;
    data['client_no'] = clientNo;
    data['client_type'] = clientType;
    data['full_name'] = fullName;
    data['mother_maiden_name'] = motherMaidenName;
    data['place_of_birth'] = placeOfBirth;
    data['date_of_birth'] = dateOfBirth;
    data['id_no'] = idNo;
    data['check_status'] = checkStatus;
    return data;
  }
}
