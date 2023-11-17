import 'package:flutter/material.dart';
import 'package:sales_order/features/home/presentation/widget/header_tab_widget.dart';
import 'package:sales_order/features/home/presentation/widget/new_applications_mobile_widget.dart';
import 'package:sales_order/features/home/presentation/widget/status_mobile_widget.dart';

class HomeMobileScreen extends StatelessWidget {
  const HomeMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40.0, left: 16, right: 16),
              child: HeaderTabWidget(),
            ),
            Expanded(
                child: ListView(
              shrinkWrap: true,
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: StatusMobileWidget(),
                ),
                NewApplicationMobileWidget()
              ],
            ))
          ],
        ));
  }
}
