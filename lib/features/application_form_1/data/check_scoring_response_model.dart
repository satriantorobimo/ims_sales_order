class CheckScoringResponseModel {
  int? result;
  int? statusCode;
  String? message;
  String? data;

  CheckScoringResponseModel(
      {this.result, this.statusCode, this.message, this.data});

  CheckScoringResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    statusCode = json['StatusCode'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['StatusCode'] = statusCode;
    data['message'] = message;
    data['data'] = this.data;
    return data;
  }
}
