import 'package:flutter/material.dart';
import 'package:sales_order/utility/color_util.dart';

class ClientInputMobileWidget extends StatelessWidget {
  final String title;
  final String content;

  const ClientInputMobileWidget(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
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
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
          )
        ],
      ),
    );
  }
}
