import 'package:flutter/material.dart';
import 'package:sales_order/features/login/presentation/widget/form_relogin_widget.dart';
import 'package:sales_order/features/login/presentation/widget/logo_widget.dart';

class ReloginMobileScreen extends StatelessWidget {
  const ReloginMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: LogoWidget(
                width: 250,
                widthBox: MediaQuery.of(context).size.width,
                heightBox: MediaQuery.of(context).size.height * 0.2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                        text: 'Login\n',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w500),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'to get started',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w300),
                          )
                        ]),
                  ),
                  const SizedBox(height: 32),
                  const FormReloginWidget()
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            const Center(
              child: Text(
                'copyright',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w300),
              ),
            )
          ],
        ),
      ),
    );
  }
}
