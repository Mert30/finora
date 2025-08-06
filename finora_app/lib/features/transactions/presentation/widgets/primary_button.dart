import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final Color? shadowColor;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color buttonColor = color ?? Colors.deepPurple;
    final Color buttonShadow = shadowColor ?? Colors.deepPurpleAccent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: buttonShadow.withOpacity(0.5),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
            gradient: LinearGradient(
              colors: [
                buttonColor.withOpacity(0.9),
                buttonColor.withOpacity(0.95),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
