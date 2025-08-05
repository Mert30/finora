import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  final String text;

  const WelcomeText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        fontFamily: 'Roboto',
      ),
    );
  }
}
