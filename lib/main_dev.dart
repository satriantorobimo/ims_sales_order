import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:sales_order/utility/general_util.dart';
import 'flavor_config.dart';
import 'main.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  GeneralUtil().getDeviceType().then((value) {
    if(value == 'tablet'){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    }else{
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  });

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black, // status bar color
    statusBarBrightness: Brightness.light,
  ));

  HttpProxy httpProxy = await HttpProxy.createHttpProxy();
  HttpOverrides.global = httpProxy;
  FlavorConfig(
      flavor: Flavor.DEV, values: FlavorValues(baseUrl: '/', userId: '-'));
  runZonedGuarded(() {
    runApp(const MyApp());
  }, (Object error, StackTrace stack) {});
}
