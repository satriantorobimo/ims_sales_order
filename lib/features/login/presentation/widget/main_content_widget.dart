import 'package:flutter/material.dart';

import 'form_widget.dart';

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Container(
          width: 550,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD6D6D6), width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(26))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: const TextSpan(
                      text: 'Login\n',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.w500),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'to get started',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w300),
                        )
                      ]),
                ),
                const FormWidget(),
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
        ),
      )),
    );
  }
}
