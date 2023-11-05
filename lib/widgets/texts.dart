import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  String texto;
  TextTitle({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class TextSubtitle extends StatelessWidget {
  String texto;
  TextSubtitle({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class TextBody extends StatelessWidget {
  String texto;
  TextBody({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
