class LoanDataDetailResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;
  String? code;
  int? id;

  LoanDataDetailResponseModel(
      {this.result,
      this.statusCode,
      this.message,
      this.data,
      this.code,
      this.id});

  LoanDataDetailResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? packageCode;
  String? packageDescription;
  String? vendorCode;
  String? vendorName;
  String? applicationRemarks;

  Data(
      {this.packageCode,
      this.packageDescription,
      this.vendorCode,
      this.vendorName,
      this.applicationRemarks});

  Data.fromJson(Map<String, dynamic> json) {
    packageCode = json['package_code'];
    packageDescription = json['package_description'];
    vendorCode = json['vendor_code'];
    vendorName = json['vendor_name'];
    applicationRemarks = json['application_remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['package_code'] = packageCode;
    data['package_description'] = packageDescription;
    data['vendor_code'] = vendorCode;
    data['vendor_name'] = vendorName;
    data['application_remarks'] = applicationRemarks;
    return data;
  }
}
