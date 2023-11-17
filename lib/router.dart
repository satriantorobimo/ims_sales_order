import 'package:flutter/material.dart';
import 'package:sales_order/features/application_form_1/presentation/screen/tab/application_form_1_tab_screen.dart';
import 'package:sales_order/features/application_form_2/presentation/screen/tab/application_form_2_tab_screen.dart';
import 'package:sales_order/features/application_form_3/presentation/screen/tab/application_form_3_tab_screen.dart';
import 'package:sales_order/features/application_form_4/presentation/screen/tab/application_form_4_tab_screen.dart';
import 'package:sales_order/features/application_form_5/presentation/screen/tab/application_form_5_tab_screen.dart';
import 'package:sales_order/features/application_form_7/presentation/screen/tab/application_form_7_tab_screen.dart';
import 'package:sales_order/features/application_form_summary/presentation/screen/tab/application_form_summary_tab_screen.dart';
import 'package:sales_order/features/client_list/presentation/screen/tab/client_list_tab_screen.dart';
import 'package:sales_order/features/tab/screen/mobile/tab_mobile_screen.dart';
import 'package:sales_order/features/tab/screen/tab/tab_tab_screen.dart';
import 'package:sales_order/utility/string_router_util.dart';

import 'features/login/presentation/screen/mobile/login_mobile_screen.dart';
import 'features/login/presentation/screen/tab/login_tab_screen.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case StringRouterUtil.loginScreenTabRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const LoginTabScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.loginScreenMobileRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const LoginMobileScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.tabScreenTabRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const TabTabScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.tabScreenMobileRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const TabMobileScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.clientListScreenTabRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const ClientListTabScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationForm1ScreenTabRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const ApplicationForm1TabScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationForm2ScreenTabRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const ApplicationForm2TabScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationForm3ScreenTabRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const ApplicationForm3TabScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationForm4ScreenTabRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const ApplicationForm4TabScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationForm5ScreenTabRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const ApplicationForm5TabScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationForm7ScreenTabRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const ApplicationForm7TabScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationFormSummaryScreenTabRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) =>
                const ApplicationFormSummaryTabScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      default:
        return MaterialPageRoute<dynamic>(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
