import 'package:flutter/material.dart';

class HeaderTabWidget extends StatelessWidget {
  const HeaderTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.person_2_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'Bagas Hari',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Today',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey,
            ),
          ],
        )
      ],
    );
  }
}
