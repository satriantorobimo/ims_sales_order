import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget(
      {super.key,
      required this.width,
      required this.widthBox,
      required this.heightBox});
  final double width;
  final double widthBox;
  final double heightBox;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthBox,
      height: heightBox,
      child: Center(
        child: Image.asset(
          'assets/img/logo.png',
          width: width,
        ),
      ),
    );
  }
}
