import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const WelcomeButton({
    super.key,
    required this.onPressed,
    this.buttonText = 'Haydi Başlayalım',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40), // Daha yuvarlak ve modern
        ),
        elevation: 8,
        shadowColor: Colors.blueAccent.withOpacity(0.4),
      ),
      child: Text(
        buttonText,
        style: GoogleFonts.poppins(
          color: Colors.blueAccent,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
