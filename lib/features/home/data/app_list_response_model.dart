class AppListResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;
  String? code;
  int? id;

  AppListResponseModel(
      {this.result,
      this.statusCode,
      this.message,
      this.data,
      this.code,
      this.id});

  AppListResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? applicationStatus;
  String? branchName;
  String? levelStatus;
  String? facilityDesc;
  String? purposeLoanName;
  String? purposeLoanDetailName;
  String? clientCode;
  String? clientName;
  double? financingAmount;
  String? applicationDate;
  String? agreementNo;
  String? modDate;

  Data(
      {this.applicationNo,
      this.applicationStatus,
      this.branchName,
      this.levelStatus,
      this.facilityDesc,
      this.purposeLoanName,
      this.purposeLoanDetailName,
      this.clientCode,
      this.clientName,
      this.financingAmount,
      this.applicationDate,
      this.agreementNo,
      this.modDate});

  Data.fromJson(Map<String, dynamic> json) {
    applicationNo = json['application_no'];
    applicationStatus = json['application_status'];
    branchName = json['branch_name'];
    levelStatus = json['level_status'];
    facilityDesc = json['facility_desc'];
    purposeLoanName = json['purpose_loan_name'];
    purposeLoanDetailName = json['purpose_loan_detail_name'];
    clientCode = json['client_code'];
    clientName = json['client_name'];
    financingAmount = json['financing_amount'];
    applicationDate = json['application_date'];
    agreementNo = json['agreement_no'];
    modDate = json['mod_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['application_no'] = applicationNo;
    data['application_status'] = applicationStatus;
    data['branch_name'] = branchName;
    data['level_status'] = levelStatus;
    data['facility_desc'] = facilityDesc;
    data['purpose_loan_name'] = purposeLoanName;
    data['purpose_loan_detail_name'] = purposeLoanDetailName;
    data['client_code'] = clientCode;
    data['client_name'] = clientName;
    data['financing_amount'] = financingAmount;
    data['application_date'] = applicationDate;
    data['agreement_no'] = agreementNo;
    data['mod_date'] = modDate;
    return data;
  }
}
