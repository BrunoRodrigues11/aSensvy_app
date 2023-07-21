import 'package:apptesteapi/config/theme.dart';
import 'package:flutter/material.dart';

class BtnDefault extends StatelessWidget {
  void Function() onPressed;
  String texto;

  BtnDefault(this.texto, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 3, left: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: const Border(
          bottom: BorderSide(color: Colors.black),
          top: BorderSide(color: Colors.black),
          left: BorderSide(color: Colors.black),
          right: BorderSide(color: Colors.black),
        )
      ),
      child: MaterialButton(
        minWidth: 300,
        height: 50,
        onPressed: () {
          onPressed();
        },
        color: AppColors.primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          texto,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}