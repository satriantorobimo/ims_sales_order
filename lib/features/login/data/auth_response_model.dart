class AuthResponseModel {
  int? status;
  String? token;
  String? refreshTokenExpiryTime;
  String? message;
  List<Datalist>? datalist;

  AuthResponseModel(
      {this.status,
      this.token,
      this.refreshTokenExpiryTime,
      this.message,
      this.datalist});

  AuthResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    refreshTokenExpiryTime = json['refreshTokenExpiryTime'];
    message = json['message'];
    if (json['datalist'] != null) {
      datalist = <Datalist>[];
      json['datalist'].forEach((v) {
        datalist!.add(Datalist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['token'] = token;
    data['refreshTokenExpiryTime'] = refreshTokenExpiryTime;
    data['message'] = message;
    if (datalist != null) {
      data['datalist'] = datalist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Datalist {
  String? uid;
  String? name;
  String? systemDate;
  String? branchCode;
  String? branchName;
  String? idpp;
  String? companyCode;
  String? companyName;
  String? idleTime;
  String? isWatermark;

  Datalist(
      {this.uid,
      this.name,
      this.systemDate,
      this.branchCode,
      this.branchName,
      this.idpp,
      this.companyCode,
      this.companyName,
      this.idleTime,
      this.isWatermark});

  Datalist.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    systemDate = json['system_date'];
    branchCode = json['branch_code'];
    branchName = json['branch_name'];
    idpp = json['idpp'];
    companyCode = json['company_code'];
    companyName = json['company_name'];
    idleTime = json['idle_time'];
    isWatermark = json['is_watermark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['system_date'] = systemDate;
    data['branch_code'] = branchCode;
    data['branch_name'] = branchName;
    data['idpp'] = idpp;
    data['company_code'] = companyCode;
    data['company_name'] = companyName;
    data['idle_time'] = idleTime;
    data['is_watermark'] = isWatermark;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'system_date': systemDate,
      'branch_code': branchCode,
      'branch_name': branchName,
      'idpp': idpp,
      'company_code': companyCode,
      'company_name': companyName,
      'idle_time': idleTime,
      'is_watermark': isWatermark
    };
  }

  factory Datalist.fromMap(Map<String, dynamic> map) {
    return Datalist(
        uid: map['uid'],
        name: map['name'],
        systemDate: map['system_date'],
        branchCode: map['branch_code'],
        branchName: map['branch_name'],
        idpp: map['idpp'],
        companyCode: map['company_code'],
        companyName: map['company_name'],
        idleTime: map['idle_time'],
        isWatermark: map['is_watermark']);
  }
}
