import 'package:flutter/material.dart';
import 'package:sales_order/features/home/presentation/widget/header_tab_widget.dart';
import 'package:sales_order/features/home/presentation/widget/new_applications_tab_widget.dart';
import 'package:sales_order/features/home/presentation/widget/notification_tab_widget.dart';
import 'package:sales_order/features/home/presentation/widget/status_tab_widget.dart';
import 'package:sales_order/utility/color_util.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            //Main Content
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Padding(
                  padding: const EdgeInsets.only(top : 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      //Header
                      HeaderTabWidget(),
                      //Status
                      StatusTabWidget(),
                      //New Application
                      NewApplicationTabWidget()
                    ],
                  ),
                ),
              ),
            ),
            //Notification
            const NotificationTabWidget()

          ],
        ));
  }
}
