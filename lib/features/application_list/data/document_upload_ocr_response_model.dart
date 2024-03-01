class DocumentUploadOCRResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<DataDocumentUploadOCRResponseModel>? data;
  String? code;
  int? id;

  DocumentUploadOCRResponseModel(
      {this.result,
      this.statusCode,
      this.message,
      this.data,
      this.code,
      this.id});

  DocumentUploadOCRResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    statusCode = json['StatusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = [DataDocumentUploadOCRResponseModel.fromJson(json['data'])];
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
    return data;
  }
}

class DataDocumentUploadOCRResponseModel {
  String? status;
  String? error;
  String? message;
  List<DataOCRResponseModel>? data;

  DataDocumentUploadOCRResponseModel(
      {this.status, this.error, this.message, this.data});

  DataDocumentUploadOCRResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = [DataOCRResponseModel.fromJson(json['data'])];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataOCRResponseModel {
  String? idNumber;
  String? name;
  String? bloodType;
  String? religion;
  String? gender;
  String? birthPlaceBirthday;
  String? province;
  String? city;
  String? district;
  String? village;
  String? rtrw;
  String? occupation;
  String? expiryDate;
  String? nationality;
  String? maritalStatus;
  String? address;
  String? placeOfBirth;
  String? birthday;

  DataOCRResponseModel(
      {this.idNumber,
      this.name,
      this.bloodType,
      this.religion,
      this.gender,
      this.birthPlaceBirthday,
      this.province,
      this.city,
      this.district,
      this.village,
      this.rtrw,
      this.occupation,
      this.expiryDate,
      this.nationality,
      this.maritalStatus,
      this.address,
      this.placeOfBirth,
      this.birthday});

  DataOCRResponseModel.fromJson(Map<String, dynamic> json) {
    idNumber = json['idNumber'];
    name = json['name'];
    bloodType = json['bloodType'];
    religion = json['religion'];
    gender = json['gender'];
    birthPlaceBirthday = json['birthPlaceBirthday'];
    province = json['province'];
    city = json['city'];
    district = json['district'];
    village = json['village'];
    rtrw = json['rtrw'];
    occupation = json['occupation'];
    expiryDate = json['expiryDate'];
    nationality = json['nationality'];
    maritalStatus = json['maritalStatus'];
    address = json['address'];
    placeOfBirth = json['placeOfBirth'];
    birthday = json['birthday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idNumber'] = idNumber;
    data['name'] = name;
    data['bloodType'] = bloodType;
    data['religion'] = religion;
    data['gender'] = gender;
    data['birthPlaceBirthday'] = birthPlaceBirthday;
    data['province'] = province;
    data['city'] = city;
    data['district'] = district;
    data['village'] = village;
    data['rtrw'] = rtrw;
    data['occupation'] = occupation;
    data['expiryDate'] = expiryDate;
    data['nationality'] = nationality;
    data['maritalStatus'] = maritalStatus;
    data['address'] = address;
    data['placeOfBirth'] = placeOfBirth;
    data['birthday'] = birthday;
    return data;
  }
}
