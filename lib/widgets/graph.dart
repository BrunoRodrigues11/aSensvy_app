import 'package:apptesteapi/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ScoreGraph extends StatelessWidget {
  String score;
  ScoreGraph({required this.score, super.key});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 60,
      lineWidth: 13,
      animation: true,
      percent: double.parse(score) / 100,
      center: Text(
        "${score}%",
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: _getBackgroundColor(
        int.parse(
          score,
        ),
      ),
    );
  }

  // COLORS DO HISTÓRICO
  Color _getBackgroundColor(int? score) {
    if (score! >= 75.0) {
      return AppColors.veryHigh; // muito alto -> 75% a 100%
    } else if (score >= 50.0) {
      return AppColors.high; // alto -> 50% a 75%
    } else if (score >= 25.0) {
      return AppColors.moderate; // moderado -> 25% a 50%
    } else {
      // return Color(0xff123456);
      return AppColors.low; // baixo -> 25% ou menos
    }
  }
}
