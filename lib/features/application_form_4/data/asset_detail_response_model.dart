class AssetDetailResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;
  String? code;
  int? id;

  AssetDetailResponseModel(
      {this.result,
      this.statusCode,
      this.message,
      this.data,
      this.code,
      this.id});

  AssetDetailResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? vehicleMerkCode;
  String? vehicleMerkDesc;
  String? vehicleModelCode;
  String? vehicleModelDesc;
  String? vehicleTypeCode;
  String? vehicleTypeDesc;
  String? assetCondition;
  String? colour;
  String? assetYear;
  String? chassisNo;
  String? engineNo;
  String? platNo1;
  String? platNo2;
  String? platNo3;

  Data(
      {this.vehicleMerkCode,
      this.vehicleMerkDesc,
      this.vehicleModelCode,
      this.vehicleModelDesc,
      this.vehicleTypeCode,
      this.vehicleTypeDesc,
      this.assetCondition,
      this.colour,
      this.assetYear,
      this.chassisNo,
      this.engineNo,
      this.platNo1,
      this.platNo2,
      this.platNo3});

  Data.fromJson(Map<String, dynamic> json) {
    vehicleMerkCode = json['vehicle_merk_code'];
    vehicleMerkDesc = json['vehicle_merk_desc'];
    vehicleModelCode = json['vehicle_model_code'];
    vehicleModelDesc = json['vehicle_model_desc'];
    vehicleTypeCode = json['vehicle_type_code'];
    vehicleTypeDesc = json['vehicle_type_desc'];
    assetCondition = json['asset_condition'];
    colour = json['colour'];
    assetYear = json['asset_year'];
    chassisNo = json['chassis_no'];
    engineNo = json['engine_no'];
    platNo1 = json['plat_no_1'];
    platNo2 = json['plat_no_2'];
    platNo3 = json['plat_no_3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vehicle_merk_code'] = vehicleMerkCode;
    data['vehicle_merk_desc'] = vehicleMerkDesc;
    data['vehicle_model_code'] = vehicleModelCode;
    data['vehicle_model_desc'] = vehicleModelDesc;
    data['vehicle_type_code'] = vehicleTypeCode;
    data['vehicle_type_desc'] = vehicleTypeDesc;
    data['asset_condition'] = assetCondition;
    data['colour'] = colour;
    data['asset_year'] = assetYear;
    data['chassis_no'] = chassisNo;
    data['engine_no'] = engineNo;
    data['plat_no_1'] = platNo1;
    data['plat_no_2'] = platNo2;
    data['plat_no_3'] = platNo3;
    return data;
  }
}
