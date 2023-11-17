// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:sales_order/utility/string_util.dart';

enum Flavor { DEV, UAT, PRODUCTION }

class FlavorValues {
  FlavorValues({@required this.baseUrl, @required this.userId});
  final String? baseUrl;
  final String? userId;
}

class FlavorConfig {
  factory FlavorConfig(
      {@required Flavor? flavor, @required FlavorValues? values}) {
    _instance ??= FlavorConfig._internal(
        flavor!, StringUtil.enumName(flavor.toString()), values!);
    return _instance!;
  }
  const FlavorConfig._internal(this.flavor, this.name, this.values);
  static FlavorConfig get instance {
    return _instance!;
  }

  final Flavor flavor;
  final String name;
  final FlavorValues values;
  static FlavorConfig? _instance;

  static bool isProduction() => _instance!.flavor == Flavor.PRODUCTION;
  static bool isUat() => _instance!.flavor == Flavor.UAT;
  static bool isDevelopment() => _instance!.flavor == Flavor.DEV;
}