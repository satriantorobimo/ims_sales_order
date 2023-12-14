class AddClientRequestModel {
  String? pIdNo;
  String? pFullName;
  String? pBranchCode;
  String? pBranchName;
  String? pMotherMaidenName;
  String? pPlaceOfBirth;
  String? pDateOfBirth;
  String? pClientType;
  String? pDocumentType;
  String? pMarketingCode;
  String? pMarketingName;
  String? pAddressAddress;
  String? pAddressCityCode;
  String? pAddressCityName;
  int? pAddressLengthOfStay;
  int? pAddressNearestBranch;
  String? pAddressOwnershipCode;
  String? pAddressProvinceCode;
  String? pAddressProvinceName;
  String? pAddressRt;
  String? pAddressRw;
  String? pAddressSubDistrict;
  String? pAddressVillage;
  String? pAddressZipCode;
  String? pAddressZipCodeCode;
  String? pAddressZipName;
  String? pApplicationNo;
  String? pBankAccountName;
  String? pBankAccountNo;
  String? pBankCode;
  String? pBankName;
  String? pClientAreaMobileNo;
  String? pClientDateOfBirth;
  String? pClientEmail;
  String? pClientFullName;
  String? pClientGenderCode;
  String? pClientIdNo;
  String? pClientMaritalStatusCode;
  String? pClientMobileNo;
  String? pClientMotherMaidenName;
  String? pClientPlaceOfBirth;
  String? pClientSpouseIdNo;
  String? pClientSpouseName;
  String? pFamilyFullName;
  String? pFamilyGenderCode;
  String? pFamilyIdNo;
  String? pFamilyTypeCode;
  String? pWorkCompanyName;
  String? pWorkDepartmentName;
  String? pWorkEndDate;
  bool? pWorkIsLatest;
  String? pWorkPosition;
  String? pWorkStartDate;
  String? pWorkTypeCode;

  AddClientRequestModel(
      {this.pIdNo,
      this.pFullName,
      this.pBranchCode,
      this.pBranchName,
      this.pMotherMaidenName,
      this.pPlaceOfBirth,
      this.pDateOfBirth,
      this.pClientType,
      this.pDocumentType,
      this.pMarketingCode,
      this.pMarketingName,
      this.pAddressAddress,
      this.pAddressCityCode,
      this.pAddressCityName,
      this.pAddressLengthOfStay,
      this.pAddressNearestBranch,
      this.pAddressOwnershipCode,
      this.pAddressProvinceCode,
      this.pAddressProvinceName,
      this.pAddressRt,
      this.pAddressRw,
      this.pAddressSubDistrict,
      this.pAddressVillage,
      this.pAddressZipCode,
      this.pAddressZipCodeCode,
      this.pAddressZipName,
      this.pApplicationNo,
      this.pBankAccountName,
      this.pBankAccountNo,
      this.pBankCode,
      this.pBankName,
      this.pClientAreaMobileNo,
      this.pClientDateOfBirth,
      this.pClientEmail,
      this.pClientFullName,
      this.pClientGenderCode,
      this.pClientIdNo,
      this.pClientMaritalStatusCode,
      this.pClientMobileNo,
      this.pClientMotherMaidenName,
      this.pClientPlaceOfBirth,
      this.pClientSpouseIdNo,
      this.pClientSpouseName,
      this.pFamilyFullName,
      this.pFamilyGenderCode,
      this.pFamilyIdNo,
      this.pFamilyTypeCode,
      this.pWorkCompanyName,
      this.pWorkDepartmentName,
      this.pWorkEndDate,
      this.pWorkIsLatest,
      this.pWorkPosition,
      this.pWorkStartDate,
      this.pWorkTypeCode});

  Map<String, dynamic> toJsonNewClient() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p_id_no'] = pIdNo;
    data['p_full_name'] = pFullName;
    data['p_branch_code'] = pBranchCode;
    data['p_branch_name'] = pBranchName;
    data['p_mother_maiden_name'] = pMotherMaidenName;
    data['p_place_of_birth'] = pPlaceOfBirth;
    data['p_date_of_birth'] = pDateOfBirth;
    data['p_client_type'] = pClientType;
    data['p_document_type'] = pDocumentType;
    data['p_marketing_code'] = pMarketingCode;
    data['p_marketing_name'] = pMarketingName;
    return data;
  }

  Map<String, dynamic> toJsonUpdate() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p_address_address'] = pAddressAddress;
    data['p_address_city_code'] = pAddressCityCode;
    data['p_address_city_name'] = pAddressCityName;
    data['p_address_province_code'] = pAddressProvinceCode;
    data['p_address_province_name'] = pAddressProvinceName;
    data['p_address_rt'] = pAddressRt;
    data['p_address_rw'] = pAddressRw;
    data['p_address_sub_district'] = pAddressSubDistrict;
    data['p_address_village'] = pAddressVillage;
    data['p_address_zip_code'] = pAddressZipCode;
    data['p_address_zip_code_code'] = pAddressZipCodeCode;
    data['p_address_zip_name'] = pAddressZipName;
    data['p_application_no'] = pApplicationNo;
    data['p_bank_account_name'] = pBankAccountName;
    data['p_bank_account_no'] = pBankAccountNo;
    data['p_bank_code'] = pBankCode;
    data['p_bank_name'] = pBankName;
    data['p_client_area_mobile_no'] = pClientAreaMobileNo;
    data['p_client_date_of_birth'] = pClientDateOfBirth;
    data['p_client_email'] = pClientEmail;
    data['p_client_full_name'] = pClientFullName;
    data['p_client_gender_code'] = pClientGenderCode;
    data['p_client_id_no'] = pClientIdNo;
    data['p_client_marital_status_code'] = pClientMaritalStatusCode;
    data['p_client_mobile_no'] = pClientMobileNo;
    data['p_client_mother_maiden_name'] = pClientMotherMaidenName;
    data['p_client_place_of_birth'] = pClientPlaceOfBirth;
    data['p_client_spouse_id_no'] = pClientSpouseIdNo;
    data['p_client_spouse_name'] = pClientSpouseName;
    data['p_client_type'] = pClientType;
    data['p_family_full_name'] = pFamilyFullName;
    data['p_family_gender_code'] = pFamilyGenderCode;
    data['p_family_id_no'] = pFamilyIdNo;
    data['p_family_type_code'] = pFamilyTypeCode;
    data['p_work_company_name'] = pWorkCompanyName;
    data['p_work_department_name'] = pWorkDepartmentName;
    data['p_work_end_date'] = pWorkEndDate;
    data['p_work_is_latest'] = pWorkIsLatest;
    data['p_work_position'] = pWorkPosition;
    data['p_work_start_date'] = pWorkStartDate;
    data['p_work_type_code'] = pWorkTypeCode;
    return data;
  }

  Map<String, dynamic> toJsonUpdatePresent() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p_address_address'] = pAddressAddress;
    data['p_address_city_code'] = pAddressCityCode;
    data['p_address_city_name'] = pAddressCityName;
    data['p_address_province_code'] = pAddressProvinceCode;
    data['p_address_province_name'] = pAddressProvinceName;
    data['p_address_rt'] = pAddressRt;
    data['p_address_rw'] = pAddressRw;
    data['p_address_sub_district'] = pAddressSubDistrict;
    data['p_address_village'] = pAddressVillage;
    data['p_address_zip_code'] = pAddressZipCode;
    data['p_address_zip_code_code'] = pAddressZipCodeCode;
    data['p_address_zip_name'] = pAddressZipName;
    data['p_application_no'] = pApplicationNo;
    data['p_bank_account_name'] = pBankAccountName;
    data['p_bank_account_no'] = pBankAccountNo;
    data['p_bank_code'] = pBankCode;
    data['p_bank_name'] = pBankName;
    data['p_client_area_mobile_no'] = pClientAreaMobileNo;
    data['p_client_date_of_birth'] = pClientDateOfBirth;
    data['p_client_email'] = pClientEmail;
    data['p_client_full_name'] = pClientFullName;
    data['p_client_gender_code'] = pClientGenderCode;
    data['p_client_id_no'] = pClientIdNo;
    data['p_client_marital_status_code'] = pClientMaritalStatusCode;
    data['p_client_mobile_no'] = pClientMobileNo;
    data['p_client_mother_maiden_name'] = pClientMotherMaidenName;
    data['p_client_place_of_birth'] = pClientPlaceOfBirth;
    data['p_client_spouse_id_no'] = pClientSpouseIdNo;
    data['p_client_spouse_name'] = pClientSpouseName;
    data['p_client_type'] = pClientType;
    data['p_family_full_name'] = pFamilyFullName;
    data['p_family_gender_code'] = pFamilyGenderCode;
    data['p_family_id_no'] = pFamilyIdNo;
    data['p_family_type_code'] = pFamilyTypeCode;
    data['p_work_company_name'] = pWorkCompanyName;
    data['p_work_department_name'] = pWorkDepartmentName;
    data['p_work_is_latest'] = pWorkIsLatest;
    data['p_work_position'] = pWorkPosition;
    data['p_work_start_date'] = pWorkStartDate;
    data['p_work_type_code'] = pWorkTypeCode;
    return data;
  }
}
