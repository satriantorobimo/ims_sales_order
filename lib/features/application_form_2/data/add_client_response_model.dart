class AddClientResponseModel {
  int? result;
  int? statusCode;
  String? message;
  String? code;
  int? id;

  AddClientResponseModel(
      {this.result, this.statusCode, this.message, this.code, this.id});

  AddClientResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    statusCode = json['StatusCode'];
    message = json['message'];

    code = json['code'];
    id = json['id'];
  }
}
