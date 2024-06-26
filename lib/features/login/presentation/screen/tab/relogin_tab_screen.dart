import 'package:flutter/material.dart';
import 'package:sales_order/features/login/presentation/widget/logo_widget.dart';
import 'package:sales_order/features/login/presentation/widget/main_content_relogin_widget.dart';

class ReloginTabScreen extends StatelessWidget {
  const ReloginTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          LogoWidget(
            width: 400,
            widthBox: MediaQuery.of(context).size.width,
            heightBox: MediaQuery.of(context).size.height * 0.3,
          ),
          const MainContentRelogin()
        ]),
      ),
    );
  }
}
