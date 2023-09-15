import 'package:flutter/material.dart';

class Skelton extends StatelessWidget {
  final double? height, width;

  Skelton({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: const BorderRadius.all(Radius.circular(16))
      ),
    );
  }
}