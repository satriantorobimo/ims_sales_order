class ClientDetailResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;
  String? code;
  int? id;

  ClientDetailResponseModel(
      {this.result,
      this.statusCode,
      this.message,
      this.data,
      this.code,
      this.id});

  ClientDetailResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? applicationNo;
  String? clientIdNo;
  String? clientFullName;
  String? clientPlaceOfBirth;
  String? clientDateOfBirth;
  String? clientMotherMaidenName;
  String? clientGenderCode;
  String? clientGenderType;
  String? clientMaritalStatusCode;
  String? clientMaritalStatusType;
  String? clientEmail;
  String? clientAreaMobileNo;
  String? clientMobileNo;
  String? clientSpouseName;
  String? clientSpouseIdNo;
  String? addressProvinceCode;
  String? addressProvinceName;
  String? addressCityCode;
  String? addressCityName;
  String? addressZipCodeCode;
  String? addressZipCode;
  String? addressZipName;
  String? addressSubDistrict;
  String? addressVillage;
  String? addressAddress;
  String? addressRt;
  String? addressRw;
  String? bankCode;
  String? bankName;
  String? bankAccountNo;
  String? bankAccountName;
  String? familyFullName;
  String? familyIdNo;
  String? familyTypeCode;
  String? familyTypeDesc;
  String? familyGenderCode;
  String? familyGenderDesc;
  String? workCompanyName;
  String? workTypeCode;
  String? workTypeDesc;
  String? workDepartmentName;
  String? workPosition;
  String? workStartDate;
  String? workEndDate;
  String? workIsLatest;

  Data(
      {this.applicationNo,
      this.clientIdNo,
      this.clientFullName,
      this.clientPlaceOfBirth,
      this.clientDateOfBirth,
      this.clientMotherMaidenName,
      this.clientGenderCode,
      this.clientGenderType,
      this.clientMaritalStatusCode,
      this.clientMaritalStatusType,
      this.clientEmail,
      this.clientAreaMobileNo,
      this.clientMobileNo,
      this.clientSpouseName,
      this.clientSpouseIdNo,
      this.addressProvinceCode,
      this.addressProvinceName,
      this.addressCityCode,
      this.addressCityName,
      this.addressZipCodeCode,
      this.addressZipCode,
      this.addressZipName,
      this.addressSubDistrict,
      this.addressVillage,
      this.addressAddress,
      this.addressRt,
      this.addressRw,
      this.bankCode,
      this.bankName,
      this.bankAccountNo,
      this.bankAccountName,
      this.familyFullName,
      this.familyIdNo,
      this.familyTypeCode,
      this.familyTypeDesc,
      this.familyGenderCode,
      this.familyGenderDesc,
      this.workCompanyName,
      this.workTypeCode,
      this.workTypeDesc,
      this.workDepartmentName,
      this.workPosition,
      this.workStartDate,
      this.workEndDate,
      this.workIsLatest});

  Data.fromJson(Map<String, dynamic> json) {
    clientIdNo = json['client_id_no'];
    clientFullName = json['client_full_name'];
    clientPlaceOfBirth = json['client_place_of_birth'];
    clientDateOfBirth = json['client_date_of_birth'];
    clientMotherMaidenName = json['client_mother_maiden_name'];
    clientGenderCode = json['client_gender_code'];
    clientGenderType = json['client_gender_type'];
    clientMaritalStatusCode = json['client_marital_status_code'];
    clientMaritalStatusType = json['client_marital_status_type'];
    clientEmail = json['client_email'];
    clientAreaMobileNo = json['client_area_mobile_no'];
    clientMobileNo = json['client_mobile_no'];
    clientSpouseName = json['client_spouse_name'];
    clientSpouseIdNo = json['client_spouse_id_no'];
    addressProvinceCode = json['address_province_code'];
    addressProvinceName = json['address_province_name'];
    addressCityCode = json['address_city_code'];
    addressCityName = json['address_city_name'];
    addressZipCodeCode = json['address_zip_code_code'];
    addressZipCode = json['address_zip_code'];
    addressZipName = json['address_zip_name'];
    addressSubDistrict = json['address_sub_district'];
    addressVillage = json['address_village'];
    addressAddress = json['address_address'];
    addressRt = json['address_rt'];
    addressRw = json['address_rw'];
    bankCode = json['bank_code'];
    bankName = json['bank_name'];
    bankAccountNo = json['bank_account_no'];
    bankAccountName = json['bank_account_name'];
    familyFullName = json['family_full_name'];
    familyIdNo = json['family_id_no'];
    familyTypeCode = json['family_type_code'];
    familyTypeDesc = json['family_type_desc'];
    familyGenderCode = json['family_gender_code'];
    familyGenderDesc = json['family_gender_desc'];
    workCompanyName = json['work_company_name'];
    workTypeCode = json['work_type_code'];
    workTypeDesc = json['work_type_desc'];
    workDepartmentName = json['work_department_name'];
    workPosition = json['work_position'];
    workStartDate = json['work_start_date'];
    workEndDate = json['work_end_date'];
    workIsLatest = json['work_is_latest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['client_id_no'] = clientIdNo;
    data['client_full_name'] = clientFullName;
    data['client_place_of_birth'] = clientPlaceOfBirth;
    data['client_date_of_birth'] = clientDateOfBirth;
    data['client_mother_maiden_name'] = clientMotherMaidenName;
    data['client_gender_code'] = clientGenderCode;
    data['client_gender_type'] = clientGenderType;
    data['client_marital_status_code'] = clientMaritalStatusCode;
    data['client_marital_status_type'] = clientMaritalStatusType;
    data['client_email'] = clientEmail;
    data['client_area_mobile_no'] = clientAreaMobileNo;
    data['client_mobile_no'] = clientMobileNo;
    data['client_spouse_name'] = clientSpouseName;
    data['client_spouse_id_no'] = clientSpouseIdNo;
    data['address_province_code'] = addressProvinceCode;
    data['address_province_name'] = addressProvinceName;
    data['address_city_code'] = addressCityCode;
    data['address_city_name'] = addressCityName;
    data['address_zip_code_code'] = addressZipCodeCode;
    data['address_zip_code'] = addressZipCode;
    data['address_zip_name'] = addressZipName;
    data['address_sub_district'] = addressSubDistrict;
    data['address_village'] = addressVillage;
    data['address_address'] = addressAddress;
    data['address_rt'] = addressRt;
    data['address_rw'] = addressRw;
    data['bank_code'] = bankCode;
    data['bank_name'] = bankName;
    data['bank_account_no'] = bankAccountNo;
    data['bank_account_name'] = bankAccountName;
    data['family_full_name'] = familyFullName;
    data['family_id_no'] = familyIdNo;
    data['family_type_code'] = familyTypeCode;
    data['family_type_desc'] = familyTypeDesc;
    data['family_gender_code'] = familyGenderCode;
    data['family_gender_desc'] = familyGenderDesc;
    data['work_company_name'] = workCompanyName;
    data['work_type_code'] = workTypeCode;
    data['work_type_desc'] = workTypeDesc;
    data['work_department_name'] = workDepartmentName;
    data['work_position'] = workPosition;
    data['work_start_date'] = workStartDate;
    data['work_end_date'] = workEndDate;
    data['work_is_latest'] = workIsLatest;
    return data;
  }
}
