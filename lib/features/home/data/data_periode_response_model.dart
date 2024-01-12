class DataPeriodeResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;
  String? code;
  int? id;

  DataPeriodeResponseModel(
      {this.result,
      this.statusCode,
      this.message,
      this.data,
      this.code,
      this.id});

  DataPeriodeResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? periodName;
  String? timePeriod;
  int? applicationCount;

  Data({this.periodName, this.timePeriod, this.applicationCount});

  Data.fromJson(Map<String, dynamic> json) {
    periodName = json['period_name'];
    timePeriod = json['time_period'];
    applicationCount = json['application_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['period_name'] = periodName;
    data['time_period'] = timePeriod;
    data['application_count'] = applicationCount;
    return data;
  }
}
