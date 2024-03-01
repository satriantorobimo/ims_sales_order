import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClientInputNpwpWidget extends StatelessWidget {
  final String title;
  final String content;
  final TextEditingController ctrl;

  const ClientInputNpwpWidget(
      {super.key,
      required this.title,
      required this.content,
      required this.ctrl});

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
          Material(
            elevation: 6,
            shadowColor: Colors.grey.withOpacity(0.4),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(width: 1.0, color: Color(0xFFEAEAEA))),
            child: SizedBox(
              width: 290,
              height: 55,
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(22),
                ],
                controller: ctrl,
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.fromLTRB(16.0, 20.0, 20.0, 16.0),
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
