class AppStatusResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;
  String? code;
  int? id;

  AppStatusResponseModel(
      {this.result,
      this.statusCode,
      this.message,
      this.data,
      this.code,
      this.id});

  AppStatusResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? applicationStatus;
  String? levelStatus;
  int? applicationCount;

  Data({this.applicationStatus, this.levelStatus, this.applicationCount});

  Data.fromJson(Map<String, dynamic> json) {
    applicationStatus = json['application_status'];
    levelStatus = json['level_status'];
    applicationCount = json['application_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['application_status'] = applicationStatus;
    data['level_status'] = levelStatus;
    data['application_count'] = applicationCount;
    return data;
  }
}
