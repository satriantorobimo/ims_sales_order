class ZipCodeResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;
  String? code;
  int? id;

  ZipCodeResponseModel(
      {this.result,
      this.statusCode,
      this.message,
      this.data,
      this.code,
      this.id});

  ZipCodeResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? code;
  String? cityCode;
  String? subDistrict;
  String? village;
  String? zipCodeName;
  String? postalCode;

  Data(
      {this.code,
      this.cityCode,
      this.subDistrict,
      this.village,
      this.zipCodeName,
      this.postalCode});

  Data.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    cityCode = json['city_code'];
    subDistrict = json['sub_district'];
    village = json['village'];
    zipCodeName = json['zip_code_name'];
    postalCode = json['postal_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['city_code'] = cityCode;
    data['sub_district'] = subDistrict;
    data['village'] = village;
    data['zip_code_name'] = zipCodeName;
    data['postal_code'] = postalCode;
    return data;
  }
}
