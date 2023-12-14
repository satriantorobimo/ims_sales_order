
class UpdateAssetRequestModel {
  String? pApplicationNo;
  String? pVehicleMerkCode;
  String? pVehicleModelCode;
  String? pVehicleTypeCode;
  int? pAssetAmount;
  String? pAssetCondition;
  String? pColour;
  String? pAssetYear;
  String? pChassisNo;
  String? pEngineNo;
  String? pPlatNo1;
  String? pPlatNo2;
  String? pPlatNo3;

  UpdateAssetRequestModel(
      {this.pApplicationNo,
      this.pVehicleMerkCode,
      this.pVehicleModelCode,
      this.pVehicleTypeCode,
      this.pAssetAmount,
      this.pAssetCondition,
      this.pColour,
      this.pAssetYear,
      this.pChassisNo,
      this.pEngineNo,
      this.pPlatNo1,
      this.pPlatNo2,
      this.pPlatNo3});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p_application_no'] = pApplicationNo;
    data['p_vehicle_merk_code'] = pVehicleMerkCode;
    data['p_vehicle_model_code'] = pVehicleModelCode;
    data['p_vehicle_type_code'] = pVehicleTypeCode;
    data['p_asset_amount'] = pAssetAmount;
    data['p_asset_condition'] = pAssetCondition;
    data['p_colour'] = pColour;
    data['p_asset_year'] = pAssetYear;
    data['p_chassis_no'] = pChassisNo;
    data['p_engine_no'] = pEngineNo;
    data['p_plat_no_1'] = pPlatNo1;
    data['p_plat_no_2'] = pPlatNo2;
    data['p_plat_no_3'] = pPlatNo3;
    return data;
  }
}
