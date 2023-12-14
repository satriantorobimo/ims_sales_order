import 'package:flutter/material.dart';
import 'package:sales_order/utility/general_util.dart';
import 'package:sales_order/utility/shared_pref_util.dart';
import 'package:sales_order/utility/string_router_util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _checkLogin();
    super.initState();
  }

  void _checkLogin() {
    bool isTablet;
    if (GeneralUtil().deviceType() == 'tablet') {
      isTablet = true;
    } else {
      isTablet = false;
    }
    SharedPrefUtil.getSharedString('token').then((value) {
      if (value == null) {
        if (isTablet) {
          Navigator.pushNamedAndRemoveUntil(
              context, StringRouterUtil.loginScreenTabRoute, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context,
              StringRouterUtil.loginScreenMobileRoute, (route) => false);
        }
      } else {
        if (isTablet) {
          Navigator.pushNamedAndRemoveUntil(
              context, StringRouterUtil.tabScreenTabRoute, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, StringRouterUtil.tabScreenMobileRoute, (route) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Center(
              child: Image.asset(
            'assets/img/logo.png',
            width: MediaQuery.of(context).size.width * 0.45,
          )),
          Container(),
        ],
      ),
    );
  }
}
