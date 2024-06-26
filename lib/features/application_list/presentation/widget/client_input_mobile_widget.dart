import 'package:flutter/material.dart';
import 'package:sales_order/utility/color_util.dart';

class ClientInputMobileWidget extends StatelessWidget {
  final String title;
  final String content;
  final TextEditingController ctrl;

  const ClientInputMobileWidget(
      {super.key,
      required this.title,
      required this.content,
      required this.ctrl});

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
          Material(
            elevation: 6,
            shadowColor: Colors.grey.withOpacity(0.4),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(width: 1.0, color: Color(0xFFEAEAEA))),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: ctrl,
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 16.0),
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
