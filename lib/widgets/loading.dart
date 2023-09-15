import 'package:apptesteapi/config/theme.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,   
      children: const [
        CircularProgressIndicator(
          color: AppColors.primaryColor,
        ),
        Text(
          'Carregando'
        )
      ],
    );
  }
}