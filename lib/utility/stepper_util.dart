import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomStepper extends StatelessWidget {
  CustomStepper({
    Key? key,
    required int currentStep,
    required this.steps,
  })  : _curStep = currentStep,
        assert(currentStep >= 0 == true && currentStep <= steps.length),
        super(key: key);

  final int _curStep;
  final Color _activeColor = Colors.black;
  final Color _inactiveColor = Colors.grey.shade300;
  final double lineWidth = 5.0;
  final List<Map<String, dynamic>> steps;

  List<Widget> _iconViews() {
    var list = <Widget>[];
    steps.asMap().forEach((i, icon) {
      Color circleColor =
      (i == 0 || _curStep >= i) ? _activeColor : _inactiveColor;
      Color lineColor = _curStep > i ? _activeColor : _inactiveColor;

      list.add(
        Container(
          width: 55.0,
          height: 55.0,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
          ),
          child: SvgPicture.asset(
            icon['image'],
          ),
        ),
      );
      if (i != steps.length - 1) {
        list.add(Expanded(
            child: Container(
              height: lineWidth,
              color: lineColor,
            )));
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    steps.asMap().forEach((i, text) {
      list.add(Text(text["title"], style: TextStyle(color: _activeColor)));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _titleViews(),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: _iconViews(),
        ),
      ],
    );
  }
}