import 'package:flutter/material.dart';
import 'package:sales_order/features/application_form_1/presentation/screen/mobile/application_form_1_mobile_screen.dart';
import 'package:sales_order/features/application_form_1/presentation/screen/tab/application_form_1_tab_screen.dart';
import 'package:sales_order/features/application_form_2/data/add_client_request_model.dart';
import 'package:sales_order/features/application_form_2/presentation/screen/mobile/application_form_2_mobile_screen.dart';
import 'package:sales_order/features/application_form_2/presentation/screen/tab/application_form_2_tab_screen.dart';
import 'package:sales_order/features/application_form_3/data/update_loan_data_request_model.dart';
import 'package:sales_order/features/application_form_3/presentation/screen/mobile/application_form_3_mobile_screen.dart';
import 'package:sales_order/features/application_form_3/presentation/screen/tab/application_form_3_tab_screen.dart';
import 'package:sales_order/features/application_form_4/data/update_asset_request_model.dart';
import 'package:sales_order/features/application_form_4/presentation/screen/mobile/application_form_4_mobile_screen.dart';
import 'package:sales_order/features/application_form_4/presentation/screen/tab/application_form_4_tab_screen.dart';
import 'package:sales_order/features/application_form_5/data/update_tnc_request_model.dart';
import 'package:sales_order/features/application_form_5/presentation/screen/mobile/application_form_5_mobile_screen.dart';
import 'package:sales_order/features/application_form_5/presentation/screen/tab/application_form_5_tab_screen.dart';
import 'package:sales_order/features/application_form_7/presentation/screen/mobile/application_form_7_mobile_screen.dart';
import 'package:sales_order/features/application_form_7/presentation/screen/tab/application_form_7_tab_screen.dart';
import 'package:sales_order/features/application_form_summary/presentation/screen/mobile/application_form_summary_mobile_screen.dart';
import 'package:sales_order/features/application_form_summary/presentation/screen/tab/application_form_summary_tab_screen.dart';
import 'package:sales_order/features/client_list/data/client_matching_mode.dart';
import 'package:sales_order/features/client_list/presentation/screen/mobile/client_list_mobile_screen.dart';
import 'package:sales_order/features/client_list/presentation/screen/tab/client_list_tab_screen.dart';
import 'package:sales_order/features/splash/splash_screen.dart';
import 'package:sales_order/features/tab/screen/mobile/tab_mobile_screen.dart';
import 'package:sales_order/features/tab/screen/tab/tab_tab_screen.dart';
import 'package:sales_order/utility/string_router_util.dart';

import 'features/login/presentation/screen/mobile/login_mobile_screen.dart';
import 'features/login/presentation/screen/tab/login_tab_screen.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case StringRouterUtil.splashScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const SplashScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));
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
        final ClientMathcingModel clientMathcingModel =
            settings.arguments as ClientMathcingModel;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) =>
                ClientListTabScreen(clientMathcingModel: clientMathcingModel),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.clientListScreenMobileRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const ClientListMobileScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationForm1ScreenTabRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const ApplicationForm1TabScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationForm1ScreenMobileRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const ApplicationForm1MobileScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationForm2ScreenTabRoute:
        final AddClientRequestModel addClientRequestModel =
            settings.arguments as AddClientRequestModel;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => ApplicationForm2TabScreen(
                addClientRequestModel: addClientRequestModel),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationForm2ScreenMobileRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const ApplicationForm2MobileScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationForm3ScreenTabRoute:
        final UpdateLoanDataRequestModel updateLoanDataRequestModel =
            settings.arguments as UpdateLoanDataRequestModel;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => ApplicationForm3TabScreen(
                updateLoanDataRequestModel: updateLoanDataRequestModel),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationForm3ScreenMobileRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const ApplicationForm3MobileScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationForm4ScreenTabRoute:
        final UpdateAssetRequestModel updateAssetRequestModel =
            settings.arguments as UpdateAssetRequestModel;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => ApplicationForm4TabScreen(
                assetRequestModel: updateAssetRequestModel),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationForm4ScreenMobileRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const ApplicationForm4MobileScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationForm5ScreenTabRoute:
        final UpdateTncRequestModel updateTncRequestModel =
            settings.arguments as UpdateTncRequestModel;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => ApplicationForm5TabScreen(
                updateTncRequestModel: updateTncRequestModel),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationForm5ScreenMobileRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const ApplicationForm5MobileScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationForm7ScreenTabRoute:
        final String applicationNo = settings.arguments as String;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) =>
                ApplicationForm7TabScreen(applicationNo: applicationNo),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationForm7ScreenMobileRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const ApplicationForm7MobileScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationFormSummaryScreenTabRoute:
        final String applicationNo = settings.arguments as String;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) =>
                ApplicationFormSummaryTabScreen(applicationNo: applicationNo),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.applicationFormSummaryScreenMobileRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) =>
                const ApplicationFormSummaryMobileScreen(),
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
