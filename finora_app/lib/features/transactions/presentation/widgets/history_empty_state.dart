import 'package:flutter/material.dart';

class HistoryEmptyState extends StatelessWidget {
  final String message;

  const HistoryEmptyState({
    super.key,
    this.message = 'Henüz işlem bulunmamaktadır.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
