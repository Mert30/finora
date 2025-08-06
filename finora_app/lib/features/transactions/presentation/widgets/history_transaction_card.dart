import 'package:flutter/material.dart';

class HistoryTransactionCard extends StatelessWidget {
  final String category;
  final double amount;
  final DateTime date;
  final String? description;

  const HistoryTransactionCard({
    super.key,
    required this.category,
    required this.amount,
    required this.date,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.indigo.shade700;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      shadowColor: primaryColor.withOpacity(0.3),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        leading: CircleAvatar(
          backgroundColor: primaryColor.withOpacity(0.15),
          child: Icon(_iconForCategory(category), color: primaryColor),
        ),
        title: Text(
          '$category - ${amount.toStringAsFixed(2)} ₺',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: primaryColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDate(date),
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
            if (description != null && description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  description!,
                  style: TextStyle(color: Colors.grey.shade900, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconForCategory(String cat) {
    switch (cat) {
      case 'Gıda':
        return Icons.fastfood;
      case 'Ulaşım':
        return Icons.directions_car;
      case 'Sağlık':
        return Icons.medical_services;
      case 'Eğlence':
        return Icons.movie;
      case 'Fatura':
        return Icons.receipt_long;
      default:
        return Icons.category;
    }
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
  }
}
