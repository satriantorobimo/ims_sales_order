import 'package:flutter/material.dart';

class GeneralUtil{

  Future<String> getDeviceType() async{
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' :'tablet';
  }

  String deviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' :'tablet';
  }
}