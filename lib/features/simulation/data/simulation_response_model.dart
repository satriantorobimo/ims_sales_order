class SimulationResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;

  SimulationResponseModel(
      {this.result, this.statusCode, this.message, this.data});

  SimulationResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    statusCode = json['StatusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  int? tenor;
  double? dpAmount;
  double? adminFee;
  double? provisiFee;
  double? insuranceAmount;
  double? othersFee;
  double? tdp;
  double? installmentAmount;

  Data(
      {this.tenor,
      this.dpAmount,
      this.adminFee,
      this.provisiFee,
      this.insuranceAmount,
      this.othersFee,
      this.tdp,
      this.installmentAmount});

  Data.fromJson(Map<String, dynamic> json) {
    tenor = json['tenor'];
    dpAmount = json['dp_amount'];
    adminFee = json['admin_fee'];
    provisiFee = json['provisi_fee'];
    insuranceAmount = json['insurance_amount'];
    othersFee = json['others_fee'];
    tdp = json['tdp'];
    installmentAmount = json['installment_amount'];
  }
}
