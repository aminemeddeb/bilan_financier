import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/transaction.dart';
import '../services/project_storage.dart';
import '../widgets/transaction_tile.dart';

class BilanFinancierScreen extends StatefulWidget {
  final Project project;
  final void Function(Project updatedProject)? onProjectUpdated;

  const BilanFinancierScreen({
    super.key,
    required this.project,
    this.onProjectUpdated,
  });

  @override
  State<BilanFinancierScreen> createState() =>
      _BilanFinancierScreenState();
}

class _BilanFinancierScreenState
    extends State<BilanFinancierScreen> {
  void _addTransaction() {
    _showTransactionDialog();
  }

  void _editTransaction(Transaction transaction) {
    _showTransactionDialog(transaction: transaction);
  }

  void _deleteTransaction(Transaction transaction) {
    setState(() {
      widget.project.transactions.removeWhere(
        (t) => t.id == transaction.id,
      );
    });
    widget.onProjectUpdated?.call(widget.project);
  }

  void _showTransactionDialog({
    Transaction? transaction,
  }) {
    final descriptionController = TextEditingController(
      text: transaction?.description ?? '',
    );

    final amountController = TextEditingController(
      text: transaction?.amount.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            transaction == null
                ? 'Ajouter une transaction'
                : 'Modifier la transaction',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Montant',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final description =
                    descriptionController.text.trim();

                final amount =
                    double.tryParse(amountController.text);

                if (description.isEmpty || amount == null) {
                  return;
                }

                setState(() {
                  if (transaction == null) {
                    widget.project.transactions.add(
                      Transaction(
                        id: DateTime.now()
                            .millisecondsSinceEpoch
                            .toString(),
                        description: description,
                        amount: amount,
                        date: DateTime.now(),
                      ),
                    );
                  } else {
                    transaction.description = description;
                    transaction.amount = amount;
                  }
                });

                widget.onProjectUpdated?.call(widget.project);
                Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
      ),
      body: Column(
        children: [
          // Financial summary
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFCC9900),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'Total dépenses',
                  style: TextStyle(
                    color: Color.fromARGB(255,29,28,24),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${project.total.toStringAsFixed(2)} dt',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: project.transactions.isEmpty
                ? const Center(
                    child: Text(
                      'Aucune transaction',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    itemCount: project.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction =
                          project.transactions[index];

                      return TransactionTile(
                        transaction: transaction,
                        onEdit: () {
                          _editTransaction(transaction);
                        },
                        onDelete: () {
                          _deleteTransaction(transaction);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTransaction,
        icon: const Icon(Icons.add),
        label: const Text('Transaction'),
      ),
    );
  }
}
