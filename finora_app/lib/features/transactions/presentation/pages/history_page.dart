import 'package:flutter/material.dart';
import '../widgets/history_transaction_card.dart';
import '../widgets/history_empty_state.dart';

class HistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;

  const HistoryPage({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.indigo.shade700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geçmiş İşlemler'),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 6,
        shadowColor: primaryColor.withOpacity(0.8),
      ),
      backgroundColor: Colors.grey.shade100,
      body: transactions.isEmpty
          ? const HistoryEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return HistoryTransactionCard(
                  category: tx['category'],
                  amount: tx['amount'],
                  date: tx['date'],
                  description: tx['description'],
                );
              },
            ),
    );
  }
}
