import 'package:flutter/material.dart';

class InitialsAvatar extends StatelessWidget {
  final String firstName;
  final String lastName;
  final double size;
  final Color backgroundColor;
  final Color textColor;

  const InitialsAvatar({super.key, 
    required this.firstName,
    required this.lastName,
    this.size = 48,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final initials = '${firstName[0]}${lastName[0]}'.toUpperCase();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: textColor,
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
