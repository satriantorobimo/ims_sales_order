import 'package:flutter/material.dart';

class AnnouncementTabScreen extends StatelessWidget {
  const AnnouncementTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Announcement',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
