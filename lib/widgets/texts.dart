import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  String texto;
  TextTitle({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return  Text(
      texto,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w500
      ),
    );
  }
}