import 'package:flutter/material.dart';
import 'package:sales_order/utility/color_util.dart';

class DetailInfoWidget extends StatelessWidget {
  final String title;
  final String content;
  final bool type;

  const DetailInfoWidget(
      {super.key,
      required this.title,
      required this.content,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 290,
      height: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          type
              ? Container(
                  width: 87,
                  height: 55,
                  decoration: BoxDecoration(
                      color: content == 'CLEAR' ? secondaryColor : thirdColor,
                      borderRadius: BorderRadius.circular(6)),
                  child: Center(
                    child: Text(
                      content,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ))
              : Container(
                  width: 290,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.1)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(-6, 4), // Shadow position
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      content,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
