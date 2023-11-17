class DistrictModel {
  List<Data>? data;

  DistrictModel({this.data});

  DistrictModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? regencyId;
  String? name;
  String? altName;
  double? latitude;
  double? longitude;

  Data(
      {this.id,
      this.regencyId,
      this.name,
      this.altName,
      this.latitude,
      this.longitude});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    regencyId = json['regency_id'];
    name = json['name'];
    altName = json['alt_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['regency_id'] = regencyId;
    data['name'] = name;
    data['alt_name'] = altName;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
