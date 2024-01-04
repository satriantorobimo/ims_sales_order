class DocumentPreviewModel {
  Value? value;
  String? declaredType;
  int? statusCode;

  DocumentPreviewModel({this.value, this.declaredType, this.statusCode});

  DocumentPreviewModel.fromJson(Map<String, dynamic> json) {
    value = json['value'] != null ? Value.fromJson(json['value']) : null;
    declaredType = json['declaredType'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (value != null) {
      data['value'] = value!.toJson();
    }
    data['declaredType'] = declaredType;
    data['statusCode'] = statusCode;
    return data;
  }
}

class Value {
  String? data;
  String? filename;

  Value({this.data, this.filename});

  Value.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    filename = json['filename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data;
    data['filename'] = filename;
    return data;
  }
}
