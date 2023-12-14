class DocumentListResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;
  String? code;
  int? id;

  DocumentListResponseModel(
      {this.result,
      this.statusCode,
      this.message,
      this.data,
      this.code,
      this.id});

  DocumentListResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? headerCode;
  String? docSource;
  String? docName;
  String? expiredDate;
  String? promiseDate;
  String? filename;
  String? paths;
  String? isRequired;

  Data(
      {this.id,
      this.headerCode,
      this.docSource,
      this.docName,
      this.expiredDate,
      this.promiseDate,
      this.filename,
      this.paths,
      this.isRequired});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    headerCode = json['header_code'];
    docSource = json['doc_source'];
    docName = json['doc_name'];
    expiredDate = json['expired_date'];
    promiseDate = json['promise_date'];
    filename = json['filename'];
    paths = json['paths'];
    isRequired = json['is_required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['header_code'] = headerCode;
    data['doc_source'] = docSource;
    data['doc_name'] = docName;
    data['expired_date'] = expiredDate;
    data['promise_date'] = promiseDate;
    data['filename'] = filename;
    data['paths'] = paths;
    data['is_required'] = isRequired;
    return data;
  }
}
