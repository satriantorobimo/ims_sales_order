import 'package:flutter/material.dart';
import 'package:sales_order/utility/color_util.dart';

class WrongWidget {
  void showBottomEmpty(context) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStates) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding:
                        const EdgeInsets.only(top: 32.0, left: 24, right: 24),
                    child: Center(
                      child: Image.asset(
                        'assets/img/expired.png',
                        width: 150,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 24.0, left: 24, right: 24, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'Ooopps....',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Format Email Salah',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 200,
                      height: 45,
                      decoration: BoxDecoration(
                        color: thirdColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                          child: Text('OK',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            );
          });
        });
  }
}
