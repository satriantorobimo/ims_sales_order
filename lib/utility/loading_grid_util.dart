import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingGridComp extends StatelessWidget {
  const LoadingGridComp({super.key, required this.length});

  final int length;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade300,
          ),
          width: 90,
          height: 90,
        ));
  }
}
