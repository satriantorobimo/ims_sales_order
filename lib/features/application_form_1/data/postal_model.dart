class PostalModel {
  List<Data>? data;

  PostalModel({this.data});

  PostalModel.fromJson(Map<String, dynamic> json) {
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
  String? urban;
  String? subDistrict;
  String? city;
  String? provinceCode;
  String? postalCode;

  Data(
      {this.urban,
      this.subDistrict,
      this.city,
      this.provinceCode,
      this.postalCode});

  Data.fromJson(Map<String, dynamic> json) {
    urban = json['urban'];
    subDistrict = json['sub_district'];
    city = json['city'];
    provinceCode = json['province_code'];
    postalCode = json['postal_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['urban'] = urban;
    data['sub_district'] = subDistrict;
    data['city'] = city;
    data['province_code'] = provinceCode;
    data['postal_code'] = postalCode;
    return data;
  }
}
